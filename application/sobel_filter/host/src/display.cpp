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

#define NOMINMAX // so that windows.h does not define min/max macros

#include <SDL2/SDL.h>
#include <CL/opencl.h>
#include <algorithm>
#include <iostream>
#include "parse_ppm.h"
#include "defines.h"
#include <assert.h>
#include <arm_neon.h>

#include "AOCLUtils/aocl_utils.h"

using namespace aocl_utils;
typedef unsigned char BYTE; 
#define REFRESH_DELAY 10 //ms
int Gx[3][3] = {{-1,-2,-1},{0,0,0},{1,2,1}};
int Gy[3][3] = {{-1,0,1},{-2,0,2},{-1,0,1}};
int glutWindowHandle;
int graphicsWinWidth = 1024;
int graphicsWinHeight = (int)(((float) ROWS / (float) COLS) * graphicsWinWidth);
float fZoom = 1024;
bool useHardwareFilter = false;
bool useSoftFilter = false;
bool useNeonFilter = false;

enum FilterEnum{ NONE , SOFT_INDEX , SOFT_BUFFER , SOBEL_NEON, HW_NO_SHARED_MEM , HW_SHARED_MEM } filterMode;
unsigned int thresh = 128;
double fps_raw = 0.0f;
double time_ms = 0.0f;
double delta_ms = 0.0f;
cl_uint *input = NULL;
cl_uint *softout = NULL;
cl_uint *hw_output = NULL;
cl_uchar *neonin = NULL;
cl_uchar *neonout = NULL;
//for shared Memory
static unsigned int *host_input = 0;
static unsigned int *host_output = 0;
static cl_mem device_input;
static cl_mem device_output;
BYTE graybuffer[ROWS * COLS];
char title[256];



cl_uint num_platforms;
cl_platform_id platform;
cl_uint num_devices;
cl_device_id device;
cl_context context;
cl_command_queue queue;
cl_program program;
cl_kernel kernel;
cl_mem in_buffer, out_buffer;

std::string imageFilename;
std::string aocxFilename;
std::string deviceInfo;

SDL_Window *sdlWindow = NULL;
SDL_Surface *sdlWindowSurface = NULL;
SDL_Surface *sdlInputSurface = NULL;
SDL_Surface *sdlHwSMoutSurface = NULL;
SDL_Surface *sdlHwNoSMoutSurface = NULL;
SDL_Surface *sdlSoftOutSurface  = NULL;
SDL_Surface *sdlNeonOutSurface  = NULL;

static bool profile = false;
bool useDisplay = true;
bool testMode = false;
unsigned testThresholds[] = {32, 96, 128, 192, 225};
unsigned testFrameIndex = 0;

bool initSDL();
void eventLoop();
void keyboardPressEvent(SDL_Event *event);
void repaint();

void teardown(int exit_status = 1);
void initCL();
void dumpFrame(unsigned frameIndex, unsigned *frameData);
double start_ms;
double end_ms;
double getMillSecond() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC_RAW, &ts);

    return ts.tv_sec*1000.0 + ts.tv_nsec/1000000.0;
}

int index(int x, int y){
	return y*COLS+x;
}


unsigned int gray(int x, int y){
	unsigned int pixel = input[y*COLS+x];
	unsigned int b = pixel & 0xff;
	unsigned int g = (pixel >> 8) & 0xff;
	unsigned int r = (pixel >> 16) & 0xff;
	unsigned int luma = r * 66 + g * 129 + b * 25;
	luma = (luma + 128) >> 8;
	luma += 16;
	return luma;
}

unsigned int gray_int(unsigned int * src){
	unsigned int pixel  = *src;	
	unsigned int b = pixel & 0xff;
	unsigned int g = (pixel >> 8) & 0xff;
	unsigned int r = (pixel >> 16) & 0xff;
	unsigned int luma = r * 66 + g * 129 + b * 25;
	luma = (luma + 128) >> 8;
	luma += 16;
	return luma;
}


 void soft_index_filter()
{
  //算法 最外框不处理
  // time start
	start_ms = getMillSecond();
  	for (int y = 1; y < ROWS -1; ++y) {
		int dstY1 = y*COLS;
		int dstY0 = dstY1-COLS;
		int dstY2 = dstY1+COLS;
		for (int x = 1; x < COLS-1; ++x) {
			unsigned int* dstXY0 = input+dstY0+x;
			unsigned int* dstXY1 = input+dstY1+x;
			unsigned int* dstXY2 = input+dstY2+x;
			///////////////////////////////////
			int t0 = 0;
			int t1 = 0;
			 t0 = -gray_int(dstXY0-1) + gray_int(dstXY0+1);
			 t1 = gray_int(dstXY0-1)+(gray_int(dstXY0)<<1)+gray_int(dstXY0+1); 
			 t0 += ((-gray_int(dstXY1-1)+gray_int(dstXY1+1))<<1); 
			 t0 += -gray_int(dstXY2-1)+gray_int(dstXY2+1); 
			 t1 -= ( gray_int(dstXY2-1)+(gray_int(dstXY2)<<1)+gray_int(dstXY2+1) ); 
			int tmp= abs(t0) + abs(t1);
			if (tmp > thresh) {
				softout[y*COLS+x] = 0xffffff;
			} else {
			   softout[y*COLS+x] = 0;
			}	
		}
	}
  end_ms = getMillSecond(); 
  time_ms = (end_ms - start_ms);
  fps_raw = (1.0f/(time_ms * 1e-3f));
  sprintf(title, "Sobel Filter Soft No Gray Buffer (%.3lf FPS,%.3lf ms)", fps_raw,time_ms);
}

 /*
void soft_index_filter()
{
  //算法 最外框不处理
  // time start
	start_ms = getMillSecond();
  	for (int y = 1; y < ROWS -1; ++y) {
		for (int x = 1; x < COLS-1; ++x) {
			///////////////////////////////////
			int t0 = 0;
			int t1 = 0;
			 t0 = -gray(x-1,y-1) + gray(x+1,y-1);
			 t1 = gray(x-1,y-1)+(gray(x,y-1)<<1)+gray(x+1,y-1); 
			 t0 += ((-gray(x-1,y)+gray(x+1,y))<<1); 
			 t0 += -gray(x-1,y+1)+gray(x+1,y+1); 
			 t1 -= ( gray(x-1,y+1)+(gray(x,y+1)<<1)+gray(x+1,y) ); 
			int tmp= abs(t0) + abs(t1);
			if (tmp > thresh) {
				softout[y*COLS+x] = 0xffffff;
			} else {
			   softout[y*COLS+x] = 0;
			}	
		}
	}
  end_ms = getMillSecond(); 
  time_ms = (end_ms - start_ms);
  fps_raw = (1.0f/(time_ms * 1e-3f));
  sprintf(title, "Sobel Filter Soft No Gray Buffer (%.3lf FPS,%.3lf ms)", fps_raw,time_ms);
}
*/

 void sobel(BYTE * src,int w,int h, unsigned int *dest) { 
	 int src_step = w; 
	 int dst_step = w; 
	 int x, height = h - 2; 
	 unsigned int* dstXY = dest+dst_step; 
	 for( ; height--; src += src_step, dstXY += dst_step) { 
		 const BYTE* src2 = src + src_step; 
		 const BYTE* src3 = src + src_step*2; 
		 for( x = 1; x < w-1 ; x++ ) { 
			 short t0 = 0 ; 
			 short t1 = 0 ; 
			 short tmp = 0 ; 
			 t0 = -src[x-1]+src[x+1] ; 
			 t1 = src[x-1]+(src[x]<<1)+src[x+1]; 
			 t0 += ((-src2[x-1]+src2[x+1])<<1) ; 
			 t0 += -src3[x-1]+src3[x+1] ; 
			 t1 -= ( src3[x-1]+(src3[x]<<1)+src3[x+1] ); 
			// tmp= abs(t0>>3) + abs(t1>>3);
			tmp= abs(t0) + abs(t1);
			if(tmp > thresh)
			 dstXY[x] = 0xffffff;
			else
			 dstXY[x] = 0;
		} 
	} 
 }
 
void soft_buffer_filter(){
	
	int i = ROWS * COLS -1;
	start_ms = getMillSecond();
	for ( ; i--; ){
	   graybuffer[i]= (unsigned char)gray_int(input+i);
	}
	sobel(graybuffer , COLS , ROWS , softout);
        end_ms = getMillSecond(); 
	time_ms = (end_ms - start_ms);
	fps_raw = (1.0f/(time_ms * 1e-3f));
	sprintf(title, "Sobel Filter Soft With Gray Buffer (%.3lf FPS,%.3lf ms)", fps_raw,time_ms);
}

void rgb2gray_neon(uint8_t * __restrict src ,uint8_t * __restrict dest,int n)
{
	int i;
	uint8x8_t rfac = vdup_n_u8 (77);
	uint8x8_t gfac = vdup_n_u8 (151);
	uint8x8_t bfac = vdup_n_u8 (28);
	n= n/8;
	for (i = 0 ; i < n ; i++) {
		uint16x8_t  tmp;
		uint8x8x3_t rgb = vld3_u8 (src);
		uint8x8_t result;
		tmp = vmull_u8 (    rgb.val[0],rfac);
		tmp = vmlal_u8 (tmp,rgb.val[1],gfac);
		tmp = vmlal_u8 (tmp,rgb.val[2],bfac);
		result = vshrn_n_u16 (tmp,8);
		vst1_u8(dest,result);
		src = src + 24;
		dest = dest +8;
	}
}

 void sobel_neon(BYTE * src,int w,int h,BYTE * dest, uint thresh) { 
 int src_step = w; 
 int dst_step = w; 
 int x, height = h - 2; 
 BYTE* dstX = dest+dst_step; 
     int16x8_t th = vdupq_n_s16(thresh); // {8{thresh}}
	 for( ; height--; src += src_step, dstX += dst_step) { 
		 const BYTE* src2 = src + src_step; //第二行
		 const BYTE* src3 = src + (src_step << 1); //第三行
		 x = 1; 
		 // Eight parallel
		 while((x+8) <= w-1 ) { 
		    //第一行
			 uint8x8_t left = vld1_u8(src+x-1); //取出left数据，到neon寄存器
			 uint8x8_t mid =  vld1_u8(src+x);   //取出mid数据，到neon寄存器
			 uint8x8_t right = vld1_u8(src+x+1); //取出right数据，到neon寄存器
			 // t0 = a2 - a0 //for Gx
			 int16x8_t t0 = vreinterpretq_s16_u16( vsubl_u8(right,left) ) ;  
			 // t1 = a0 +a2 +2*a1 //for Gy
			 int16x8_t t1 = vaddq_s16( vreinterpretq_s16_u16( vaddl_u8(left,right) ) , vreinterpretq_s16_u16( vshll_n_u8(mid,1) ) ); 
			  //第二行
			 left = vld1_u8(src2+x-1); 
			 right = vld1_u8(src2+x+1) ; 
			 //(b2 - b0) // for Gx Gy
			 int16x8_t temp = vreinterpretq_s16_u16( vsubl_u8(right,left) ); 
			 // t0 = (a2-a0) + 2*(b2 - b0)
			 t0 = vaddq_s16(t0,vshlq_n_s16(temp,1)); 
			 //第三行
			 left = vld1_u8(src3+x-1); 
			 mid = vld1_u8(src3+x) ; 
			 right = vld1_u8(src3+x+1) ; 
			 // t0 = ((a2-a0) + 2*(b2 - b0)) +(c2 - c0) =  Gx
			 t0 = vaddq_s16(t0,vreinterpretq_s16_u16( vsubl_u8(right,left) )); 
			 // temp = c2+c0 +2*c1
			 temp = vaddq_s16( vreinterpretq_s16_u16( vaddl_u8(left,right) ) , vreinterpretq_s16_u16( vshll_n_u8(mid,1) ) ); 
			// t1 = (a0 +2*a1 + a2) - (c0 + 2*c1 +c2) = Gy
			t1 = vsubq_s16(t1,temp); 
			// t0 = |Gx| +　|Gy|
			t0 =  vaddq_s16(vabsq_s16(t0),vabsq_s16(t1));     
			vst1_u8((uint8_t*)dstX+x, vmovn_u16(vcgeq_s16(t0,th))); 
			 x += 8; 
		 } 
	 } 
 }
 
void neon_filter(){
  int i,index;
  index=0;
  for(i=0; i< COLS*ROWS; i++){
  neonin[index++]=input[i]&0xff;
  neonin[index++]=(input[i]&0xff00)>>8;
  neonin[index++]=(input[i]&0xff0000)>>16;
  }
	start_ms = getMillSecond();
	
	start_ms = getMillSecond();
	rgb2gray_neon((uint8_t*)neonin,(uint8_t*)graybuffer, ROWS * COLS);
	sobel_neon(graybuffer, COLS , ROWS , neonout, thresh);
	end_ms = getMillSecond();
	i = ROWS * COLS -1;
	for ( ; i--; ){
	    softout[i]= neonout[i]? 0xffffff:0;
	} 
	time_ms = (end_ms - start_ms);
	fps_raw = (1.0f/(time_ms * 1e-3f));
	sprintf(title, "Sobel Filter ARM　NEON With Gray Buffer (%.3lf FPS,%.3lf ms)", fps_raw,time_ms);
}

template <typename T >
cl_mem alloc_shared_buffer (size_t size, T **host_ptr) {
  cl_int status;
  cl_mem device_ptr = clCreateBuffer(context, CL_MEM_ALLOC_HOST_PTR, sizeof(T) * size, NULL, &status);
  checkError(status, "Failed to create buffer");
  assert (host_ptr != NULL);
  *host_ptr = (T*)clEnqueueMapBuffer(queue, device_ptr, CL_TRUE, CL_MAP_WRITE|CL_MAP_READ, 0, sizeof(T) * size, 0, NULL, NULL, NULL);
  assert (*host_ptr != NULL);
  // populate the buffer with garbage data
  for (size_t i=0; i< size; i++) {
    *((unsigned int*)(*host_ptr) + i) = 13;
  }
  return device_ptr;
}

void filter_CL()
{
  size_t sobelSize = 1;
  cl_int status;
  cl_ulong start, end, delta_ms;
  cl_event event_rd,event,event_wr;
  /* USE_SM == 0 */
  
  if(filterMode == HW_NO_SHARED_MEM) {
	  status = clEnqueueWriteBuffer(queue, in_buffer, CL_FALSE, 0, sizeof(unsigned int) * ROWS * COLS, input, 0, NULL, &event_wr);
	  checkError(status, "Error: could not copy data into device");
	  status  = clFinish(queue);
      checkError(status, "Error: could not finish successfully");
  
	  status  = clGetEventProfilingInfo(event_wr, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &start, NULL);
      status |= clGetEventProfilingInfo(event_wr, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &end, NULL);
      checkError(status, "Error: could not get profile information");
      clReleaseEvent(event_wr);
	  delta_ms =  (end - start)* 1e-6f ;
	  checkError(status, "Error: could not finish successfully");
	  status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &in_buffer);
	  checkError(status, "Error: could not set sobel arg 0");
	  status = clSetKernelArg(kernel, 1, sizeof(cl_mem), &out_buffer);
	  checkError(status, "Error: could not set sobel arg 1");
  }
  else
  {
	  status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &device_input);
	  checkError(status, "Error: could not set sobel arg 0");
	  status = clSetKernelArg(kernel, 1, sizeof(cl_mem), &device_output);
	  checkError(status, "Error: could not set sobel arg 1");
  }
  int pixels = COLS * ROWS;
  status = clSetKernelArg(kernel, 2, sizeof(int), &pixels);
  checkError(status, "Error: could not set sobel arg 2");  
	  
  if(!testMode) {
    status = clSetKernelArg(kernel, 3, sizeof(unsigned int), &thresh);
  }
  else {
    // In test mode, iterate through different thresholds automatically.
    status = clSetKernelArg(kernel, 3, sizeof(unsigned int), &testThresholds[testFrameIndex]);
  }
  checkError(status, "Error: could not set sobel threshold");

  
  status = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &sobelSize, &sobelSize, 0, NULL, &event);
  checkError(status, "Error: could not enqueue sobel filter");

  status  = clFinish(queue);
  checkError(status, "Error: could not finish successfully");

  status  = clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &start, NULL);
  status |= clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &end, NULL);
  checkError(status, "Error: could not get profile information");
  clReleaseEvent(event);

  
  if(filterMode == HW_NO_SHARED_MEM) {
      delta_ms = delta_ms + (end-start) * 1e-6f ;
	  status = clEnqueueReadBuffer(queue, out_buffer, CL_FALSE, 0, sizeof(unsigned int) * ROWS * COLS, hw_output, 0, NULL, &event_rd);
	  checkError(status, "Error: could not copy data from device");
	  status = clFinish(queue);
	  checkError(status, "Error: could not successfully finish copy");
	  status  = clGetEventProfilingInfo(event_rd, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &start, NULL);
      status |= clGetEventProfilingInfo(event_rd, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &end, NULL);
      checkError(status, "Error: could not get profile information");
      clReleaseEvent(event_rd);
	  time_ms = delta_ms + (end-start) * 1e-6f ;
      fps_raw = (1.0f/(time_ms * 1e-3f));
	  sprintf(title, "Sobel Filter HW No Shared Memory:(%.3lf FPS,%.5lf ms)", fps_raw , time_ms);
  }
  else
  {
	  // Display FPS in window title bar.
	  fps_raw = (1.0f / ((end - start) * 1e-9f));
	  time_ms = (end-start) * 1e-6f ;
	  sprintf(title, "Sobel Filter HW Shared Memory:(%.3lf FPS,%.5lf ms)", fps_raw , time_ms);
  }
  if (profile) {
    printf("Throughput: %.3lf FPS\n", fps_raw);
  }
  
  if(testMode) {
    // Dump out frame data in PPM (ASCII).
	 if(filterMode == HW_NO_SHARED_MEM) 
		dumpFrame(testFrameIndex, hw_output); 
	 else
        dumpFrame(testFrameIndex, host_output);

    // Increment test frame index.
    testFrameIndex++;
    if(testFrameIndex == sizeof(testThresholds)/sizeof(testThresholds[0])) {
      // Exit - all test thresholds completed.
      SDL_Event quitEvent;
      quitEvent.type = SDL_QUIT;
      SDL_PushEvent(&quitEvent);
    }
  }

  
}

// Dump frame data in PPM format.
void dumpFrame(unsigned frameIndex, unsigned *frameData) {
  char fname[256];
  sprintf(fname, "frame%d.ppm", frameIndex);
  printf("Dumping %s\n", fname);

  FILE *f = fopen(fname, "wb");
  fprintf(f, "P6 %d %d %d\n", COLS, ROWS, 255);
  for(unsigned y = 0; y < ROWS; ++y) {
    for(unsigned x = 0; x < COLS; ++x) {
      // This assumes byte-order is little-endian.
      unsigned pixel = frameData[y * COLS + x];
      fwrite(&pixel, 1, 3, f);
    }
    fprintf(f, "\n");
  }
  fclose(f);
}

int main(int argc, char **argv)
{
  cl_int status;
  Options options(argc, argv);
  profile = options.has("profile");
  
  if(options.has("display")) {
    useDisplay = options.get<bool>("display");
  }

  imageFilename = "butterflies.ppm";
  if(options.has("img")) {
    imageFilename = options.get<std::string>("img");
  }

  // If in test mode, start with useHardwareFilter = true.
  if(options.has("test")) {
    useHardwareFilter = true;
    testMode = true;
  }
  
  filterMode = NONE;
  
  
  input = (cl_uint*)alignedMalloc(sizeof(unsigned int) * ROWS * COLS);
  hw_output = (cl_uint*)alignedMalloc(sizeof(unsigned int) * ROWS * COLS);
  softout = (cl_uint*)alignedMalloc(sizeof(unsigned int) * ROWS * COLS);
  neonin = (cl_uchar*)alignedMalloc(sizeof(unsigned char) * ROWS * COLS*3);
  neonout = (cl_uchar*)alignedMalloc(sizeof(unsigned char) * ROWS * COLS);
  
  
  initCL();

  // Read the image
  if (!parse_ppm(imageFilename.c_str(), COLS, ROWS, (unsigned char *)host_input)) {
    std::cerr << "Error: could not load " << argv[1] << std::endl;
    teardown();
  }
    // Read the image
  if (!parse_ppm(imageFilename.c_str(), COLS, ROWS, (unsigned char *)input)) {
    std::cerr << "Error: could not load " << argv[1] << std::endl;
    teardown();
  }
    if(!initSDL()) {
    return 1;
  }
 

  kernel = clCreateKernel(program, "sobel", &status);
  checkError(status, "Error: could not create sobel kernel");


  
  std::cout << "Commands:" << std::endl;
  std::cout << " <space>  Toggle filter on or off" << std::endl;
  std::cout << " -" << std::endl
            << "  Reduce filter threshold" << std::endl;
  std::cout << " +" << std::endl
            << "  Increase filter threshold" << std::endl;
  std::cout << " =" << std::endl
            << "  Reset filter threshold to default" << std::endl;
  std::cout << " q/<enter>/<esc>" << std::endl
            << "  Quit the program" << std::endl;

  eventLoop();

  teardown(0);
}

void initCL()
{
  cl_int status;

  if (!setCwdToExeDir()) {
    teardown();
  }

  platform = findPlatform("Intel(R) FPGA");
  if (platform == NULL) {
    teardown();
  }

  status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, 1, &device, NULL);
  checkError (status, "Error: could not query devices");
  num_devices = 1; // always only using one device

  char info[256];
  clGetDeviceInfo(device, CL_DEVICE_NAME, sizeof(info), info, NULL);
  deviceInfo = info;


  context = clCreateContext(0, num_devices, &device, &oclContextCallback, NULL, &status);
  checkError(status, "Error: could not create OpenCL context");

  queue = clCreateCommandQueue(context, device, 0, &status);
  checkError(status, "Error: could not create command queue");
  
  std::string binary_file = getBoardBinaryFile("sobel", device);
  std::cout << "Using AOCX: " << binary_file << "\n";
  program = createProgramFromBinary(context, binary_file.c_str(), &device, 1);

  status = clBuildProgram(program, num_devices, &device, "", NULL, NULL);
  checkError(status, "Error: could not build program");

  device_input = alloc_shared_buffer<unsigned int> (ROWS * COLS, &host_input);
  device_output = alloc_shared_buffer<unsigned int> (ROWS * COLS, &host_output);
  
  in_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(unsigned int) * ROWS * COLS, NULL, &status);
  checkError(status, "Error: could not create device buffer");
  out_buffer = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(unsigned int) * ROWS * COLS, NULL, &status);
  checkError(status, "Error: could not create output buffer");
   
}

bool initSDL()
{
  // Initialize.
  if(SDL_Init(useDisplay ? SDL_INIT_VIDEO : 0) != 0) {
    std::cerr << "Error: Could not initialize SDL: " << SDL_GetError() << "\n";
    return false;
  }

  if(useDisplay) {
    // Create the window.
    sdlWindow = SDL_CreateWindow("Sobel Filter", 
      SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
      1024, 1024 * ROWS / COLS, 0);
    if(sdlWindow == NULL) {
      std::cerr << "Error: Could not create SDL window: " << SDL_GetError() << "\n";
      return false;
    }

    // Get the window's surface.
    sdlWindowSurface = SDL_GetWindowSurface(sdlWindow);
    if(sdlWindowSurface == NULL) {
      std::cerr << "Error: Could not get SDL window surface: " << SDL_GetError() << "\n";
      return false;
    }

    // Create the input and output surfaces.
	// sdlInputSurface = SDL_CreateRGBSurfaceFrom(input, COLS, ROWS, 32, COLS * sizeof(unsigned int),
	// 0xff, 0xff00, 0xff0000, 0);
    sdlInputSurface = SDL_CreateRGBSurfaceFrom(input, COLS, ROWS, 32, COLS * sizeof(unsigned int),
        0xff, 0xff00, 0xff0000, 0);
    sdlSoftOutSurface = SDL_CreateRGBSurfaceFrom(softout ,COLS, ROWS, 32, COLS * sizeof(unsigned int),
        0xff, 0xff00, 0xff0000, 0);
    sdlHwSMoutSurface = SDL_CreateRGBSurfaceFrom(host_output, COLS, ROWS, 32, COLS * sizeof(unsigned int),
        0xff, 0xff00, 0xff0000, 0);
    sdlHwNoSMoutSurface = SDL_CreateRGBSurfaceFrom(hw_output, COLS, ROWS, 32, COLS * sizeof(unsigned int),
        0xff, 0xff00, 0xff0000, 0);
	//sdlNeonOutSurface  = SDL_CreateRGBSurfaceFrom(neonin , COLS, ROWS, 24, COLS * sizeof(unsigned char)*3,
        //0xff, 0xff, 0xff, 0);
       	sdlNeonOutSurface  = SDL_CreateRGBSurfaceFrom(softout , COLS, ROWS, 32, COLS * sizeof(unsigned int),
        0xff, 0xff00, 0xff0000, 0);
  }

  return true;
}

void eventLoop()
{
  bool running = true;
  while(running) {
    SDL_Event event;
    if(SDL_PollEvent(&event)) {
      switch(event.type) {
        case SDL_QUIT:
          running = false;
          break;

        case SDL_KEYDOWN:
          keyboardPressEvent(&event);
          break;

        case SDL_WINDOWEVENT:
          if(event.window.event == SDL_WINDOWEVENT_EXPOSED) {
            repaint();
          }
          break;
      }
    }
    else {
      repaint();
    }
  }
}

void keyboardPressEvent(SDL_Event *event) 
{
  SDL_KeyboardEvent *keyEvent = (SDL_KeyboardEvent *)event;
  switch(keyEvent->keysym.sym) {
    // Quit.
    case SDLK_ESCAPE:
    case SDLK_RETURN:
    case SDLK_q: {
      SDL_Event quitEvent;
      quitEvent.type = SDL_QUIT;
      SDL_PushEvent(&quitEvent);
      break;
    }
    // Toggle filter.
	case SDLK_1:
	case SDLK_SPACE:
		filterMode = NONE;
		break; 
	case SDLK_2:
    case SDLK_s:
		filterMode = SOFT_INDEX;
		break; 
	case SDLK_3:
		filterMode = SOFT_BUFFER;
		break; 
	case SDLK_4:
		filterMode = SOBEL_NEON;
		break;
    case SDLK_h:		
	case SDLK_5:
		filterMode = HW_NO_SHARED_MEM;
		break; 
	case SDLK_6:
		filterMode = HW_SHARED_MEM;
		break; 	
    // Threshold adjustments.
	case SDLK_EQUALS:
      thresh = 128;
      break;

    case SDLK_KP_MINUS:
    case SDLK_MINUS:
      thresh = std::max(thresh - 10, 16u);
      break;

    case SDLK_KP_PLUS:
    case SDLK_PLUS:
      thresh = std::min(thresh + 10, 255u);
      break;
  }
}

void repaint() 
{
 switch(filterMode){
	case NONE :	
		sprintf(title, "Sobel Filter Original Image!");
		break;	
	case SOFT_INDEX:
		soft_index_filter();
	    break;
	case SOFT_BUFFER:
		soft_buffer_filter();
		break;
	case SOBEL_NEON:
		neon_filter();
		break;
	case HW_NO_SHARED_MEM:
	case HW_SHARED_MEM:
		filter_CL();
		break;	
	}    
  if(useDisplay) {	  
    SDL_SetWindowTitle(sdlWindow, title);
    switch(filterMode){
	case NONE :	
		SDL_BlitScaled(sdlInputSurface, NULL, sdlWindowSurface, NULL);
		break;
	case SOFT_INDEX:
	case SOFT_BUFFER:
		SDL_BlitScaled(sdlSoftOutSurface , NULL, sdlWindowSurface, NULL);
		break;
	case SOBEL_NEON:
		SDL_BlitScaled(sdlNeonOutSurface , NULL, sdlWindowSurface, NULL);
		break;
	case HW_NO_SHARED_MEM:
		SDL_BlitScaled(sdlHwNoSMoutSurface , NULL, sdlWindowSurface, NULL);
		break;
	case HW_SHARED_MEM:
		SDL_BlitScaled(sdlHwSMoutSurface , NULL, sdlWindowSurface, NULL);
		break;	
	}  
    // Update the window surface.
    SDL_UpdateWindowSurface(sdlWindow);
  }
}

void cleanup()
{
  // Called from aocl_utils::check_error, so there's an error.
  teardown(-1);
}

void teardown(int exit_status)
{

  if (host_input) {
    clEnqueueUnmapMemObject (queue, device_input, host_input, 0, NULL, NULL);
    clReleaseMemObject (device_input);
    host_input = 0;
  }
    if (host_output) {
    clEnqueueUnmapMemObject (queue, device_output, host_output, 0, NULL, NULL);
    clReleaseMemObject (device_output);
    host_output = 0;
  }
  if (input) alignedFree(input);
  if (neonin) alignedFree(neonin);
  if (hw_output) alignedFree(hw_output);
  if(softout) alignedFree(softout); 
  if(neonout) alignedFree(neonout);
  if (in_buffer) clReleaseMemObject(in_buffer);
  if (out_buffer) clReleaseMemObject(out_buffer);
  if (kernel) clReleaseKernel(kernel);
  if (program) clReleaseProgram(program);
  if (queue) clReleaseCommandQueue(queue);
  if (context) clReleaseContext(context);

  SDL_Quit();
  exit(exit_status);
}

