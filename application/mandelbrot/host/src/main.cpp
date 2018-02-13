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

#include <iostream>
#include <sstream>
#include <iomanip>
#include <cstdlib>
#include <algorithm>
#include <math.h>

using std::stringstream;
using std::cout;
using std::endl;
using std::ends;
using std::min;

#include "AOCLUtils/aocl_utils.h"
#include "MandelbrotWindow.h"
#include "AOCLUtils/aocl_utils.h"

using namespace aocl_utils;

// Define the size of the color table, which doubles as 
// the maximum number of iterations when computing the 
// Mandelbrot frame
unsigned COLOR_TABLE_SIZE = 1000;

// Controls if motion across all large distances are smoothed or
// are instant.
bool smoothMotion = true;

// Use the display?
bool useDisplay = true;

// Test mode.
bool testMode = false;

// Test frame count.
unsigned testFrameCount = 100;

// Test frame dump, every Nth frame.
unsigned testFrameDump = 25;

extern SDL_Surface* theFrames[2];
extern unsigned theDemoRunning;

///////////////////////////////////////////////////////////////////////////////
// Create default color table
///////////////////////////////////////////////////////////////////////////////
void colorTableInit() 
{
  // Allocate temporary space for the color table
  unsigned short int* aColorTable = (unsigned short int*)alignedMalloc(COLOR_TABLE_SIZE * sizeof(unsigned short int));
  
  // Initialize color table values
  for(unsigned int i = 0; i < COLOR_TABLE_SIZE; i++)
  {
    if (i < 64) 
      aColorTable[i] = SDL_MapRGB(theFrames[0]->format, min(5*i+20,255u), 0, 0);

    else if (i < 128)
      aColorTable[i] = SDL_MapRGB(theFrames[0]->format, 255, 2*i, 0);

    else if (i < 512)
      aColorTable[i] = SDL_MapRGB(theFrames[0]->format, min((int)(0.25*i),255), min((int)(0.25*i),255), 0);

    else if (i < 768)
      aColorTable[i] = SDL_MapRGB(theFrames[0]->format, min((int)(0.25*i),255), min((int)(0.25*i),255), 0);

    else
      aColorTable[i] = SDL_MapRGB(theFrames[0]->format, min((int)(0.10*i),255), min((int)(0.10*i),255), 0);
  }

  // Set the color table
  mandelbrotSetColorTable(aColorTable, COLOR_TABLE_SIZE);

  // Free temporary table
  alignedFree(aColorTable);
}

///////////////////////////////////////////////////////////////////////////////
// Print program usage
///////////////////////////////////////////////////////////////////////////////
void printUsage()
{
  printf("\n");
  printf("Usage: mandelbrot [-w=<#>] [-h=<#>] [-c=<#>]\n");
  printf("  -w, -h: width and height\n");
  printf("  -c: number of colors\n");
  printf("Press 'q' to quit\n");
  printf("Press 'h' to toggle CPU and OpenCL (Hardware) modes\n");
  printf("Press 'd' to toggle auto-location selection mode (ignores mouse input while on)\n");
  printf("Press 'r' to reset view\n");
  printf("Left Click: move to location,\nRight Click: zoom in to location,\nMiddle Click: zoom out from location\n");
  printf("\n");
}

///////////////////////////////////////////////////////////////////////////////
// Main program
///////////////////////////////////////////////////////////////////////////////
int main(int argc, char **argv)
{
  // Process options.
  Options options(argc, argv);

  unsigned width = 800;
  unsigned height = 640;

  if(options.has("w")) {
    width = options.get<unsigned>("w");
  }
  if(options.has("h")) {
    height = options.get<unsigned>("h");
  }
  if(options.has("c")) {
    COLOR_TABLE_SIZE = options.get<unsigned>("c");
  }
  if(options.has("nosmooth")) {
    smoothMotion = false;
  }
  if(options.has("display")) {
    useDisplay = options.get<bool>("display");
  }

  testMode = options.get<bool>("test");
  if(testMode) {
    if(options.has("test-frames")) {
      testFrameCount = options.get<unsigned>("test-frames");
    }
    if(options.has("test-dump")) {
      testFrameDump = options.get<unsigned>("test-dump");
    }
  }

  // Initialize the SDL Utils with a window size
  mandelbrotWindowInitialize( width, height );

  // Print program usage every time for user
  printUsage();

  // Create and set the color table
  colorTableInit();

  // Run the program main loop
  mandelbrotWindowMainLoop();
  
  // Finish
  mandelbrotWindowRelease();

  return 0;
}
