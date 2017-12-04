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

#include "StopWatch.h"
#include "AOCLUtils/aocl_utils.h"
#include <stdlib.h>

// Set the start data of a stopwatch
void startTime(StopWatch* aStopWatch)
{
#ifdef _WIN32
    QueryPerformanceCounter(&(*aStopWatch).startCount);
    QueryPerformanceFrequency(&(*aStopWatch).frequency);
#else
    gettimeofday(&aStopWatch->startCount, NULL);
#endif
}

// Get the time elapsed since a stopwatch was started
double getElapsedTime(StopWatch* aStopWatch)
{
#ifdef _WIN32
  QueryPerformanceCounter(&(*aStopWatch).endCount);
  double endInMicroSec = (*aStopWatch).endCount.QuadPart * (1000000.0 /(*aStopWatch).frequency.QuadPart);
  double startInMicroSec = (*aStopWatch).startCount.QuadPart * (1000000.0 / (*aStopWatch).frequency.QuadPart);
  return (double)((endInMicroSec - startInMicroSec) / 1000000);
#else
  gettimeofday(&aStopWatch->endCount, NULL);
  return ((aStopWatch->endCount.tv_sec * 1000000.0) + aStopWatch->endCount.tv_usec - (aStopWatch->startCount.tv_sec * 1000000.0) + aStopWatch->startCount.tv_usec) / 1000000;
#endif
}
