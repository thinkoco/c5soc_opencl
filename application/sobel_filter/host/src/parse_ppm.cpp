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

#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <iostream>

#include "parse_ppm.h"

bool parse_ppm(const char *filename, const unsigned int width, const unsigned int height, unsigned char *data)
{
  FILE *fp = NULL;
#ifdef _WIN32
  errno_t err;
  if ((err = fopen_s(&fp, filename, "rb")) != 0)
#else
  if ((fp = fopen(filename, "rb")) == 0)
#endif
  {
    if (fp) { fclose(fp); }
    std::cerr << "Error: failed to load '" << filename << "'" << std::endl;
    return false;
  }

  const size_t headerSize = 0x40;
  char header[headerSize];
  if ((fgets(header, headerSize, fp) == NULL) && ferror(fp)) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: '" << filename << "' is not a valid PPM image" << std::endl;
    return false;
  }

  if (strncmp(header, "P6", 2) != 0) {
    std::cerr << "Error: '" << filename << "' is not a valid PPM image" << std::endl;
    return false;
  }

  int i = 0;
  unsigned int maxval = 0;
  unsigned int w = 0;
  unsigned int h = 0;
  while (i < 3) {
    if ((fgets(header, headerSize, fp) == NULL) && ferror(fp)) {
      if (fp) { fclose(fp); }
      std::cerr << "Error: '" << filename << "' is not a valid PPM image" << std::endl;
      return false;
    }
    // Skip comments
    if (header[0] == '#') continue;
#ifdef _WIN32
    if (i == 0) {
      i += sscanf_s(header, "%u %u %u", &w, &h, &maxval);
    } else if (i == 1) {
      i += sscanf_s(header, "%u %u", &h, &maxval);
    } else if (i == 2) {
      i += sscanf_s(header, "%u", &maxval);
    }
#else
    if (i == 0) {
      i += sscanf(header, "%u %u %u", &w, &h, &maxval);
    } else if (i == 1) {
      i += sscanf(header, "%u %u", &h, &maxval);
    } else if (i == 2) {
      i += sscanf(header, "%u", &maxval);
    }
#endif
  }

  if (maxval == 0) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: maximum color value must be greater than 0" << std::endl;
    return false;
  }
  if (maxval > 255) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: parser only supports 1 byte value PPM images" << std::endl;
    return false;
  }

  if (w != width) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: expected width of " << width
          << " pixels, but file contains image of width "
          << w << " pixels" << std::endl;
    return false;
  }

  if (h != height) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: expected width of " << height
          << " pixels, but file contains image of height "
          << h << " pixels" << std::endl;
    return false;
  }

  unsigned char *raw = (unsigned char *)malloc(sizeof(unsigned char) * width * height * 3);
  if (!raw) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: could not allocate data buffer" << std::endl;
    return false;
  }
  if (fread(raw, sizeof(unsigned char), width * height * 3, fp) != width * height * 3) {
    if (fp) { fclose(fp); }
    std::cerr << "Error: invalid image data" << std::endl;
    return false;
  }
  if (fp) { fclose(fp); }

  // Transfer the raw data
  unsigned char *raw_ptr = raw;
  unsigned char *data_ptr = data;
  for (int i = 0, e = width * height; i != e; ++i) {
    // Read rgb and pad
    *data_ptr++ = *raw_ptr++;
    *data_ptr++ = *raw_ptr++;
    *data_ptr++ = *raw_ptr++;
    *data_ptr++ = 0;
  }
  free(raw);
  return true;
}
