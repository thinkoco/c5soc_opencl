// Copyright (C) 2013-2017 Altera Corporation, San Jose, California, USA. All rights reserved.
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
// whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// 
// This agreement shall be governed in all respects by the laws of the State of California and
// by the laws of the United States of America.

#include "MandelbrotWindow.h"
#include <stdio.h>
#include <stdlib.h>

using namespace aocl_utils;

// define color depth
#define COLOR_DEPTH 32

// The event used to poll the SDL event queue
static SDL_Event theEvent;

// SDL Objects used to display
static SDL_Window* theWindow;
SDL_Surface* theWindowSurface;
SDL_Surface* theFrames[2]; // double buffer of frames
static void* thePixels[2];  // actual pixel data
static unsigned int theCurrentFrame;

// Motion driver variables
bool theProgramRunning = true;
unsigned theDemoRunning = true;    // bool causes problems with MSVC Release mode
extern int theCalculationMethod;
extern bool smoothMotion;

// SDL window properties
double theCurrentX = theDemoLocations[0].x;  // set starting X
double theCurrentY = theDemoLocations[0].y;  // set starting Y
double theCurrentScale = theDemoLocations[0].scale;  // set starting scale

double theTargetX = theCurrentX;  // set starting target X
double theTargetY = theCurrentY;  // set starting target Y
double theTargetScale = theCurrentScale;  // set starting target scale

unsigned int theWidth;
unsigned int theHeight;

extern bool useDisplay;

extern bool testMode;
extern unsigned testFrameCount;
extern unsigned testFrameDump;
unsigned testCurFrameCount = 0;


void mandelbrotWindowRepaint();
bool mandelbrotDumpFrame(unsigned frameIndex, unsigned short int *pixels);

// Initialize the window to a width and height specified
int mandelbrotWindowInitialize(
  unsigned int aWidth,
  unsigned int aHeight)
{
  // Start the mandelbrot
  mandelbrotInitialize();

  // Initialize SDL to show video
  if (SDL_Init(useDisplay ? SDL_INIT_VIDEO : 0) != 0)
  {
    printf("Unable to initialize SDL: %s\n", SDL_GetError());
    SDL_Quit();
    mandelbrotRelease();
    exit(1);
  }

  // Set the width and height
  theWidth = aWidth;
  theHeight = aHeight;

  // Set current frame to start at frame 0
  theCurrentFrame = 0;

  if(useDisplay)
  {
    // Create the SDL Window
    theWindow = SDL_CreateWindow("Mandelbrot",
      //SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
      theWidth, theHeight,
      SDL_WINDOW_SHOWN);

    // Make sure the window was created successfully
    if(theWindow == NULL)
    {
      printf("SDL_CreateWindow failed: %s\n", SDL_GetError());
      SDL_Quit();
      mandelbrotRelease();
      exit(1);
    }

    // Get the surface of the window
    theWindowSurface = SDL_GetWindowSurface(theWindow);

    // Make sure the window surface was retrieved successfully
    if(theWindowSurface == NULL)
    {
      printf("SDL_GetWindowSurface failed: %s\n", SDL_GetError());
      SDL_Quit();
      mandelbrotRelease();
      exit(1);
    }
  }

  // Create the 2 surfaces (double buffer)
  thePixels[0] = alignedMalloc(theWidth*theHeight*(COLOR_DEPTH/8));
  thePixels[1] = alignedMalloc(theWidth*theHeight*(COLOR_DEPTH/8));
  unsigned int thePitch = theWidth * (COLOR_DEPTH/8);  // pitch size in bytes
  theFrames[0] = SDL_CreateRGBSurfaceFrom(thePixels[0], theWidth, theHeight, COLOR_DEPTH, thePitch, 0, 0, 0, 0);
  theFrames[1] = SDL_CreateRGBSurfaceFrom(thePixels[1], theWidth, theHeight, COLOR_DEPTH, thePitch, 0, 0, 0, 0);

  // Make sure the surfaces were created correctly
  if(theFrames[0] == NULL || theFrames[1] == NULL)
  {
    printf("SDL_CreateRGBSurface failed: %s\n", SDL_GetError());
    SDL_Quit();
    mandelbrotRelease();
    exit(1);
  }

  // Return success
  return 0;
}

int mandelbrotWindowRelease()
{
  if(useDisplay)
  {
    // Free Surfaces
    SDL_FreeSurface(theFrames[0]);
    SDL_FreeSurface(theFrames[1]);

    // Free Window
    SDL_DestroyWindow(theWindow);
  }

  // Release the mandelbrot
  mandelbrotRelease();

  // Return success
  return 0;
}

// Reset the window position
int mandelbrotWindowResetView()
{
  theTargetX = theDemoLocations[0].x;
  theTargetY = theDemoLocations[0].y;
  theTargetScale = theDemoLocations[0].scale;
  return 0;
}

// Free Motion funtion and fixed motion function
int mandelbrotWindowUpdate()
{
  // Swap frames
  theCurrentFrame ^= 1;

  // Distance variables
  double xDistance = (theTargetX - theCurrentX);
  double yDistance = (theTargetY - theCurrentY);
  double scaledXDistance = xDistance/theCurrentScale;
  double scaledYDistance = yDistance/theCurrentScale;
  double scaleDistance = theTargetScale - theCurrentScale;
  double scaleScale = theTargetScale/theCurrentScale;

  // If our distance is greater than 5% of the window size, do a fluid motion
  if(smoothMotion && 
    (scaledXDistance > 5.0 ||
    scaledYDistance > 5.0 ||
    scaleScale > 10 ||
    scaledXDistance < -5.0 ||
    scaledYDistance < -5.0 ||
    scaleScale < 0.1))
  {
    // Move half the distance
    theCurrentX += xDistance*0.2;
    theCurrentY += yDistance*0.2;
    theCurrentScale += scaleDistance*0.2;
  }
  else
  {
    // Move the final step
    theCurrentX = theTargetX;
    theCurrentY = theTargetY;
    theCurrentScale = theTargetScale;
  }

  // Get start time for FPS calculation
  const double start_time = getCurrentTimestamp();

  // Recalculate the frame at the current position
  mandelbrotCalculateFrame(
    theCurrentX,
    theCurrentY,
    theCurrentScale,
    (unsigned int*)theFrames[theCurrentFrame]->pixels);

  const double end_time = getCurrentTimestamp();
  const double elapsed_time = end_time - start_time;

  // Output FPS
  char title[256];
#ifdef _WIN32
  sprintf_s(title, 256, "Using %s, Current FPS: %.2f", (theCalculationMethod)? "Software" : "Hardware" ,1.0/elapsed_time);
#else
  sprintf(title, "Using %s, Current FPS: %.2f", (theCalculationMethod)? "Software" : "Hardware" ,1.0/elapsed_time);
#endif

  if(useDisplay)
  {
    SDL_SetWindowTitle(theWindow, title);

    // Repaint the window.
    mandelbrotWindowRepaint();
  }

  // Print out some performance metrics (unless in test mode)
  if(!testMode) 
  {
    static unsigned last_print_length = 0;

    // Erase the last line that was printed.
    for(unsigned i = 0; i < last_print_length; ++i) {
      printf("\b \b");
    }
    printf("%s", title);
    last_print_length = strlen(title);
    fflush(stdout);
  }

  // If in test mode, check if it's time to dump out the frame.
  if(testMode && testCurFrameCount < testFrameDump) 
  {
    mandelbrotDumpFrame(testCurFrameCount, (unsigned int*)theFrames[theCurrentFrame]->pixels);
  }

  // Return success
  return 0;
}

int mandelbrotWindowMainLoop()
{
  // Give the window an initial update
  mandelbrotWindowUpdate();

  // Create a variable to track which demo coordinate we are at
  int currentCoordinate = 0;

  // The last frame update time.
  unsigned lastFrameUpdate = 0;

  // Poll event so long as it isn't returning QUIT
  while(theProgramRunning)
  {
    // Handle events.
    if(SDL_PollEvent( &theEvent ))
    {
      // If we have a quit event
      if(theEvent.type == SDL_QUIT)
        theProgramRunning = false;

      // If we have a keyboard event
      else if(theEvent.type == SDL_KEYDOWN)
        keyboardPressEvent(&theEvent);

      // If window is exposed
      else if(theEvent.type == SDL_WINDOWEVENT && theEvent.window.event == SDL_WINDOWEVENT_EXPOSED)
        mandelbrotWindowRepaint();

      // IF we aren't running the demo
      else if(!theDemoRunning)
      {
        // If we have a mousebutton event
        if(theEvent.type == SDL_MOUSEBUTTONDOWN)
          mousePressEvent(&theEvent);
        else if(theEvent.type == SDL_MOUSEBUTTONUP)
          mouseReleaseEvent(&theEvent);
      }
    }
    // No events; do frame processing.
    else
    {
      // Frame update. Limit FPS to 60.
      unsigned currentTime = SDL_GetTicks();
      if(currentTime > lastFrameUpdate + 16)
      {
        // Demo:
        // Only update the location after reaching the previous target location.
        if(theDemoRunning)
        {
          bool reachedDemoTarget = 
            theTargetX == theCurrentX && 
            theTargetY == theCurrentY &&
            theTargetScale == theCurrentScale;

          if(reachedDemoTarget)
          {
            // Set targets to demo location
            theTargetX = theDemoLocations[currentCoordinate].x;
            theTargetY = theDemoLocations[currentCoordinate].y;
            theTargetScale = theDemoLocations[currentCoordinate].scale;

            // Increment the demo location used
            currentCoordinate = (currentCoordinate + 1) % NUMBER_OF_COORDINATES;
          }
        }

        // Test:
        if(testMode)
        {
          unsigned testIndex = testCurFrameCount % NUM_TEST_LOCATIONS;
          theTargetX = theTestLocations[testIndex].x;
          theTargetY = theTestLocations[testIndex].y;
          theTargetScale = theTestLocations[testIndex].scale;

          testCurFrameCount++;
          if(testCurFrameCount == testFrameCount)
            theProgramRunning = false; // done all test positions
        }

        mandelbrotWindowUpdate();
        lastFrameUpdate = currentTime;
      }
    }
  }

  // return success
  return 0;
}

void mandelbrotWindowRepaint()
{
  // Display the current frame on the surface
  if (SDL_BlitSurface(theFrames[theCurrentFrame], NULL, theWindowSurface, NULL) != 0)
    printf("Unable to SDL_BlitSurface: %s\n", SDL_GetError());

  // Update the window surface
  if (SDL_UpdateWindowSurface(theWindow) != 0)
    printf("Unable to SDL_UpdateWindowSurface: %s\n", SDL_GetError());
}

// Dumps the given frame's pixel data to a PPM file.
bool mandelbrotDumpFrame(unsigned frameIndex, unsigned int *pixels) {
  char fname[256];
  sprintf(fname, "frame%d.ppm", frameIndex);

  FILE *f = fopen(fname, "w");
  if(!f)
  {
    printf("Failed to open %s.\n", fname);
    return false;
  }
  printf("Dumping frame file '%s'.\n", fname);

  fprintf(f, "P3\n%d %d\n%d\n", theWidth, theHeight, 255);
  for(unsigned y = 0; y < theHeight; ++y)
  {
    for(unsigned x = 0; x < theWidth; ++x)
    {
      unsigned char r, g, b;
      SDL_GetRGB(pixels[y*theWidth + x], theFrames[0]->format, &r, &g, &b);
      fprintf(f, "%d %d %d ", r, g, b);
    }
    fprintf(f, "\n");
  }

  fclose(f);
  return true;
}

