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

#include "SoftwareMandelbrot.h"

using namespace aocl_utils;

// Global frame sizes
extern unsigned int theWidth;
extern unsigned int theHeight;

// Local Data
static short int* theSoftColorTable = 0;
static unsigned short int theSoftColorTableSize = 0;

// compute the mandel value of a pixel
inline unsigned int mandel_pixel(
  float x0,
  float y0,
  unsigned int maxIterations)
{
  // variables for the calculation
  float x = 0.0;
  float y = 0.0;
  float xSqr = 0.0;
  float ySqr = 0.0;
  unsigned int iterations = 0;

  // perform up to the maximum number of iterations to solve
  // the current work-item's position in the image
  while (xSqr + ySqr < 4.0 &&
      iterations < maxIterations)
  {
    // perform the current iteration
    xSqr = x*x;
    ySqr = y*y;

    y = 2*x*y + y0;
    x = xSqr - ySqr + x0;

    // increment iteration count
    iterations++;
  }

  // return the iteration count
  return iterations;
}

// Initialize by doing nothing
int softwareInitialize()
{
  return 0;
}

// Set the color table
int softwareSetColorTable(
  unsigned short int* aColorTable,
  unsigned int aColorTableSize)
{
  // If the color table is a different size than before
  if(theSoftColorTableSize != aColorTableSize)
  {
    // Set new table size
    theSoftColorTableSize = aColorTableSize;

    // Free old table
    if(theSoftColorTable) alignedFree(theSoftColorTable);

    // Create new table
    theSoftColorTable = (short int*)alignedMalloc(theSoftColorTableSize * sizeof(short int));
  }

  // Write the color table data to the device on the current queue
  memcpy(theSoftColorTable, aColorTable, theSoftColorTableSize*sizeof(unsigned short int));

  // Return success
  return 0;
}

// Use the cpu to calculate a frame
int softwareCalculateFrame(
  float aStartX,
  float aStartY,
  float aScale,
  unsigned short int* aFrameBuffer)
{
  // temporary pointer and index variables
  unsigned short int * fb_ptr = aFrameBuffer;
  unsigned int j, k, pixel;

  // window position variables
  float x = aStartX;
  float y = aStartY;
  float cur_x, cur_y;
  float cur_step_size = aScale;

  // for each pixel in the y dimension window
  for (j = 0, cur_y = y; j < theHeight; j++, cur_y -= cur_step_size)
  {
    // for each pixel in the x dimension of the window
    for (cur_x = x, k = 0; k < theWidth; k++, cur_x += cur_step_size)
    {
      // set the value of the pixel in the window
      pixel = mandel_pixel(cur_x, cur_y, theSoftColorTableSize);
      if (pixel == theSoftColorTableSize)
        *fb_ptr++ = 0x0;
      else
        *fb_ptr++ = theSoftColorTable[pixel];
    }
  }

  //return success
  return 0;
}

// Release by doing nothing
int softwareRelease()
{
  return 0;
}
