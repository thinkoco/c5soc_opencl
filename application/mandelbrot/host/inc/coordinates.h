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

#ifndef COORDINATES_H
#define COORDINATES_H

// Define the number of example coordinates
#define NUMBER_OF_COORDINATES 10

// A structure containing origin positions and a scale for a Mandelbrot frame
struct coordinates {
  double x;
  double y;
  double scale;
};

const double demo_scale_factor = 3.0;

// Location and scales of a set of positions to run through when
// the program is run in "demo mode"
const struct coordinates theDemoLocations[NUMBER_OF_COORDINATES] =
{
  {-2.0, 1.15, 0.0035*demo_scale_factor},
  {-0.7302032, -0.2080147, 0.0000002*demo_scale_factor},
  {-2.0, 1.15, 0.0035*demo_scale_factor},
  {-0.1072627, -0.9120693, 0.0000001*demo_scale_factor},
  {-2.0, 1.15, 0.0035*demo_scale_factor},
  {-1.7868170, 0.0030061, 0.0000002*demo_scale_factor},
  {-2.0, 1.15, 0.0035*demo_scale_factor},
  {0.3382314, -0.4132462, 0.0000002*demo_scale_factor},
  {-2.0, 1.15, 0.0035*demo_scale_factor},
  {-0.708210525513, -0.244819641113, 0.000000381470*demo_scale_factor},
  //{-2.0, 1.15, 0.0035*demo_scale_factor},
  //{-0.793605729416, -0.149912039936, 0.000000000373*demo_scale_factor},
};

// Location and scales of a set of positions for test mode.
const struct coordinates theTestLocations[] =
{
  {-0.7302032, -0.2080147, 0.004},
  {-2.0, 1.05, 0.0035},
  {0.1, 0.9, 0.003},
  {-0.79, 0.1, 0.00008}
};
const unsigned NUM_TEST_LOCATIONS = sizeof(theTestLocations)/sizeof(theTestLocations[0]);

#endif

