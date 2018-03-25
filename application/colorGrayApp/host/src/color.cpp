#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cstring>
#include <CL/opencl.h>
#include "AOCLUtils/aocl_utils.h"
#include <float.h>
#include <time.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include "opt.h"

using namespace aocl_utils;
#define STRING_BUFFER_LEN 1024

extern options opt;
cl_uchar *host_input;
cl_uchar *host_output;
cl_uchar *host_gray;

static cl_int status;
// OpenCL runtime configuration
static cl_platform_id platform = NULL;
static cl_device_id device = NULL;
static cl_context context = NULL;
static cl_command_queue queue = NULL;
static cl_kernel kernel = NULL;
static cl_program program = NULL;

static cl_mem buf_rgb;
static cl_mem buf_gray;
static cl_mem buf_yuyv;

static unsigned int width;
static unsigned int height;
static unsigned int srcStride;
static unsigned int dstStride;

template <typename T >
cl_mem alloc_shared_buffer (size_t size, T **host_ptr) {
	cl_int status;
	cl_mem device_ptr = clCreateBuffer(context, CL_MEM_ALLOC_HOST_PTR, sizeof(T) * size, NULL, &status);
	checkError(status, "Failed to create buffer");
	assert (host_ptr != NULL);
	*host_ptr = (T*)clEnqueueMapBuffer(queue, device_ptr, CL_TRUE, CL_MAP_WRITE|CL_MAP_READ, 0, sizeof(T) * size, 0, NULL, NULL, NULL);
	assert (*host_ptr != NULL);
	// populate the buffer with garbage data
	return device_ptr;
}

// Function prototypes
static double getMillSecond();

bool init_opencl() {


	width = opt.width;
	height = opt.height;
	srcStride = width * 2;
	dstStride = width * 4;
	if(!setCwdToExeDir()) {
    	return false;
	}

	platform = findPlatform("Intel");
	if(platform == NULL) {
    	printf("ERROR: Unable to find IntelFPGA OpenCL platform.\n");
    	return false;
	}

  // User-visible output - Platform information
    char char_buffer[STRING_BUFFER_LEN]; 
    printf("Querying platform for info:\n");
    printf("==========================\n");
    clGetPlatformInfo(platform, CL_PLATFORM_NAME, STRING_BUFFER_LEN, char_buffer, NULL);
    printf("%-40s = %s\n", "CL_PLATFORM_NAME", char_buffer);
    clGetPlatformInfo(platform, CL_PLATFORM_VENDOR, STRING_BUFFER_LEN, char_buffer, NULL);
    printf("%-40s = %s\n", "CL_PLATFORM_VENDOR ", char_buffer);
    clGetPlatformInfo(platform, CL_PLATFORM_VERSION, STRING_BUFFER_LEN, char_buffer, NULL);
    printf("%-40s = %s\n\n", "CL_PLATFORM_VERSION ", char_buffer);

  // Query the available OpenCL devices.
	scoped_array<cl_device_id> devices;
	cl_uint num_devices;

	devices.reset(getDevices(platform, CL_DEVICE_TYPE_ALL, &num_devices));

  // We'll just use the first device.
	device = devices[0];

  // Create the context.
	context = clCreateContext(NULL, 1, &device, NULL, NULL, &status);
	checkError(status, "Failed to create context");

  // Create the command queue.
	queue = clCreateCommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &status);
	checkError(status, "Failed to create command queue");

  // Create the program.
	std::string binary_file = getBoardBinaryFile("grayKernel", device);
	printf("Using AOCX: %s\n", binary_file.c_str());
	program = createProgramFromBinary(context, binary_file.c_str(), &device, 1);

  // Build the program that was just created.
	status = clBuildProgram(program, 0, NULL, "", NULL, NULL);
	checkError(status, "Failed to build program");

  // Create the kernel - name passed in here must match kernel name in the
  // original CL file, that was compiled into an AOCX file using the AOC tool
	const char *kernel_name = "grayKernel";  // Kernel name, as defined in the CL file
	kernel = clCreateKernel(program, kernel_name, &status);
	checkError(status, "Failed to create kernel");


	host_input = (cl_uchar*)alignedMalloc(width*height*2*sizeof(unsigned char));
	host_output = (cl_uchar*)alignedMalloc(width*height*4*sizeof(unsigned char));
	host_gray = (cl_uchar*)alignedMalloc(width*height*sizeof(unsigned char));

	buf_yuyv = alloc_shared_buffer<unsigned char> (width*height*2*sizeof(unsigned char), &host_input);
	buf_rgb = alloc_shared_buffer<unsigned char> ( width*height*4*sizeof(unsigned char), &host_output);
	buf_gray = alloc_shared_buffer<unsigned char> (width*height*sizeof(unsigned char), &host_gray);

	status= clSetKernelArg(kernel, 1, sizeof(int), &srcStride);
	status= clSetKernelArg(kernel, 2, sizeof(int), &dstStride);
	status= clSetKernelArg(kernel, 3, sizeof(cl_mem), &buf_rgb);
	status= clSetKernelArg(kernel, 4, sizeof(cl_mem), &buf_gray);
  	return true;
}

// Free the resources allocated during initialization
void cleanup() {
  // Free the resources allocated
  if (host_input) {
    clEnqueueUnmapMemObject (queue, buf_yuyv, host_input, 0, NULL, NULL);
    clReleaseMemObject (buf_yuyv);
    host_input = 0;
  }
    if (host_output) {
    clEnqueueUnmapMemObject (queue, buf_rgb, host_output, 0, NULL, NULL);
    clReleaseMemObject (buf_rgb);
    host_output = 0;
  }

  if(kernel) {
    clReleaseKernel(kernel);  
  }
  if(program) {
    clReleaseProgram(program);
  }
  if(queue) {
    clReleaseCommandQueue(queue);
  }
  if(context) {
    clReleaseContext(context);
  }
}


double getMillSecond() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC_RAW, &ts);
    return ts.tv_sec*1000.0 + ts.tv_nsec/1000000.0;
}

void yuyv2rgb_hw(const void *start)
{
	unsigned char *data = (unsigned char *)start;
	double sta = getMillSecond();
	status= clEnqueueWriteBuffer(queue, buf_yuyv, CL_TRUE, 0, width*height*2*sizeof(unsigned char), data, 0, NULL, NULL);
	status= clSetKernelArg(kernel, 0, sizeof(cl_mem), &buf_yuyv);
	// Configure work set over which the kernel will execute
	size_t globalSize[] = {width/2, height,0};
	size_t localSize[] = {1, 1, 1};
	// Launch the kernel
	double st = getMillSecond();
	status= clEnqueueNDRangeKernel(queue, kernel, 2, NULL, globalSize, localSize, 0, NULL, NULL);
	//checkError(status, "Failed to launch kernel");
	status = clFinish(queue);
	double et= getMillSecond();
	double time = et-st;
	double eta = getMillSecond();
	double time2 = eta-sta;
	checkError(status, "\nKernel Failed to finish");
	if(opt.verbose){
		printf("OpenCL Kernel run time = %.3fms\n", (float)time);
		printf("OpenCL run time = %.3fms\n", (float)time2);
	}

}
