#ifndef COLOR_H
#define COLOR_H

bool init_opencl();
void yuyv2rgb_hw(const void *ptr);
void cleanup();

#endif
