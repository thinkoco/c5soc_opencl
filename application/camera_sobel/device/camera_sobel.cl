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

#include "../host/inc/defines.h"

// Sobel filter kernel
// frame_in and frame_out are different buffers. Specify restrict on
// them so that the compiler knows they do not alias each other.
__kernel
void camera_sobel(global unsigned short * restrict frame_in, global unsigned int * restrict frame_out,
           const int iterations, const unsigned int threshold)
{
    // Filter coefficients
    int Gx[3][3] = {{-1,-2,-1},{0,0,0},{1,2,1}};
    int Gy[3][3] = {{-1,0,1},{-2,0,2},{-1,0,1}};

    // Pixel buffer of 2 rows and 3 extra pixels
    unsigned short rows[2 * COLS + 3];

    // The initial iterations are used to initialize the pixel buffer.
    int count = -(2 * COLS + 3);
    while (count != iterations) {
        // Each cycle, shift a new pixel into the buffer.
        // Unrolling this loop allows the compile to infer a shift register.
        #pragma unroll
        for (int i = COLS * 2 + 2; i > 0; --i) {
            rows[i] = rows[i - 1];
        }
        rows[0] = count >= 0 ? frame_in[count] : 0;

        int x_dir = 0;
        int y_dir = 0;

        #pragma unroll
        for (int i = 0; i < 3; ++i) {
            #pragma unroll
            for (int j = 0; j < 3; ++j) {
		//Get Y form YU or YV
                unsigned int pixel = rows[i * COLS + j];
                unsigned int luma = (pixel >> 8) & 0xff;
                x_dir += luma * Gx[i][j];
                y_dir += luma * Gy[i][j];
            }
        }
        int temp = abs(x_dir) + abs(y_dir);
        unsigned int clamped;
        if (temp > threshold) {
            clamped = 0xffffffff;
        } else {
            clamped = 0xff000000;
        }

        if (count >= 0) {
            frame_out[count] = clamped;
        }
        count++;
    }
}
