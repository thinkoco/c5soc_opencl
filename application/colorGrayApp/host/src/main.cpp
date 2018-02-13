#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cstring>
#include <CL/opencl.h>
#include "AOCLUtils/aocl_utils.h"
#include <float.h>
#include <time.h>
#include <SDL.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <linux/videodev2.h>
#include <getopt.h> 
#include "jpeglib.h"
#include <setjmp.h>
using namespace aocl_utils;

int shotRGBPic=0;
int shotGRAYPic=0;
enum colorConvWay{SOFTWARE,HARDWARE}colorConvertWay;
unsigned char grayPic[1280*720];//max 1280*720
#define STRING_BUFFER_LEN 1024

typedef  struct Args{
	int verbose;
	int width;
	int height;
	int r;
	int g;
	int b;
	int upvalue;
	int downvalue;
	}Args;

struct buff{              // 缓冲/
    void *start;
    size_t length;
  } 
;
struct buffer {
  struct v4l2_requestbuffers req; // 请求/
  struct v4l2_buffer query;      // 获取/
  struct buff *buf;
};
 
struct video {
  int fd;
  struct v4l2_format format;    // 视频帧格式
  struct buffer buffer;        // 视频缓冲
};
 


struct rgb_surface {
  SDL_Surface *surface;
  unsigned int rmask;
  unsigned int gmask;
  unsigned int bmask;
  unsigned int amask;
  int width;
  int height;
  int bpp;
  int pitch;
  unsigned char *pixels;
  int pixels_num;
};
 
struct screen {
  SDL_Surface *display;
  SDL_Event event;
  int width;
  int height;
  int bpp;
  int running;
  struct rgb_surface rgb;
};
 


struct options {
  int verbose;
  int width;
  int height;
};

void screen_init();
void screen_quit();
void screen_mainloop();

#define BUFFER_NUM 1
 
int stream_flag = V4L2_BUF_TYPE_VIDEO_CAPTURE;
struct Args opt;
struct video video;
struct screen screen;

 void video_open();
 void video_close();
 void video_set_format();
 void video_streamon();
 void video_streamoff();
 void buffer_init();
 void buffer_free();
 void buffer_request();
 void buffer_mmap(int index);

void video_init();
void video_quit();
void buffer_enqueue(int index);
void buffer_dequeue(int index);

void options_init();
void options_deal(int argc, char *argv[]);
void show_usage();
void parseArgs(int argc, char *argv[], Args *argsp);


 
void sdl_init();
void create_rgb_surface();
void update_rgb_surface(int index);
void yuyv2rgb_sw(const void *start);
void yuyv2rgb_hw(const void *start);
void yCbCr2rgb(unsigned char Y,
            unsigned char Cb,
            unsigned char Cr,
            int *ER,
            int *EG,
            int *EB);
int clamp(double x);



// Runtime constants
// Used to define the work set over which this kernel will execute.
static const size_t work_group_size = 8;  // 8 threads in the demo workgroup
// Defines kernel argument value, which is the workitem ID that will
// execute a printf call
static const int thread_id_to_output = 2;

// OpenCL runtime configuration
static cl_platform_id platform = NULL;
static cl_device_id device = NULL;
static cl_context context = NULL;
static cl_command_queue queue = NULL;
static cl_kernel kernel = NULL;
static cl_program program = NULL;


static cl_int status;
// Function prototypes
bool init_opencl();
void cleanup();
double getMillSecond();

int encode_rgb_jpeg(unsigned char *lpbuf,int width,int height,char *filename);
int encode_rgbx_jpeg(unsigned char *lpbuf,int width,int height,char *filename);
int encode_gray_jpeg(unsigned char *lpbuf,int width,int height,char *filename);
// Entry point.
int main(int argc, char* argv[]) {

  colorConvertWay=HARDWARE;

  options_init();
  parseArgs(argc, argv, &opt);
  
  if(!init_opencl()) {
    return -1;
  }
  video_init();
  screen_init();
  screen_mainloop();
  screen_quit();
  video_quit();
  cleanup();
  exit(EXIT_SUCCESS);
  return 0;
}



/////// HELPER FUNCTIONS ///////

bool init_opencl() {

  if(!setCwdToExeDir()) {
    return false;
  }
  // Get the OpenCL platform. for SDK 14.1
  //platform = findPlatform("Altera");
  // Get the OpenCL platform. for SDK 16.1
  platform = findPlatform("Intel");
  if(platform == NULL) {
    printf("ERROR: Unable to find Altera OpenCL platform.\n");
    return false;
  }

  // User-visible output - Platform information
  {
    char char_buffer[STRING_BUFFER_LEN]; 
    printf("Querying platform for info:\n");
    printf("==========================\n");
    clGetPlatformInfo(platform, CL_PLATFORM_NAME, STRING_BUFFER_LEN, char_buffer, NULL);
    printf("%-40s = %s\n", "CL_PLATFORM_NAME", char_buffer);
    clGetPlatformInfo(platform, CL_PLATFORM_VENDOR, STRING_BUFFER_LEN, char_buffer, NULL);
    printf("%-40s = %s\n", "CL_PLATFORM_VENDOR ", char_buffer);
    clGetPlatformInfo(platform, CL_PLATFORM_VERSION, STRING_BUFFER_LEN, char_buffer, NULL);
    printf("%-40s = %s\n\n", "CL_PLATFORM_VERSION ", char_buffer);
  }

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

  return true;
}

// Free the resources allocated during initialization
void cleanup() {
  // Free the resources allocated
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


void show_usage()
{
 // printf("usage: colorMatrix [options]-h-v\n");
   fprintf(stderr, "Usage: colorMatrix [options]\n"
      "Options:\n"
       "-v | --verbose       Show message in shell\n"
       "-w | --width         width of Video \n"
       "-h | --height        height of Video\n"
       "-r | --rtimes        Times of Color R\n"
       "-g | --gtimes        Times of Color G\n"
       "-b | --btimes        Times of Color B\n"
       "-u | --upvalue       up value of threshold\n"
       "-d | --downvalue     down value of threshold\n"
       "For example: colorMatrix -w640 -h480 -r2 -g1 -b2 -u700 -d200 \n\n");
}
 

void
options_init()
{
  opt.verbose = 0;
  opt.width = 640;
  opt.height = 480;
  opt.r = 1;
  opt.g = 1;
  opt.b = 1;
  opt.upvalue = 76500;
  opt.downvalue = 0;
}

void parseArgs(int argc, char *argv[], Args *argsp)
 {
     const char shortOptions[] = "vw:h:r:g:b:u:d:";
     const struct option longOptions[] = {
         {"verbose",		no_argument, 		NULL, 'v'},
         {"width",			required_argument, NULL, 'w'},
         {"height", 		required_argument, NULL, 'h'},
         {"rtimes",			required_argument, NULL, 'r'},
         {"gtimes",			required_argument, NULL, 'g'},
         {"btimes",			required_argument, NULL, 'b'},
		 {"upvalue",		required_argument, NULL, 'u'},
		 {"downvalue",		required_argument, NULL, 'd'},
         {0, 0, 0, 0}
     };

     int     index;
     int     c;
     char    *extension;
 
     for (;;) {
         c = getopt_long(argc, argv, shortOptions, longOptions, &index);
 
         if (c == -1) {
             break;
        }

         switch (c) {
             case 0:
                break;
 
             case 'v':
				argsp->verbose=1;
                break;

             case 'h':
                 argsp->height = atoi(optarg);
                 break;

             case 'w':
                 argsp->width = atoi(optarg);
                 break;

             case 'r':
                 argsp->r = atoi(optarg);
                 break;

             case 'g':
                 argsp->g = atoi(optarg);
                 break;
             case 'b':
                 argsp->b = atoi(optarg);
                 break;

             case 'u':
                 argsp->upvalue = atoi(optarg);
                 break;

             case 'd':
                 argsp->downvalue = atoi(optarg);
                 break;

 
//             case 'h':
//                 usage();
                 exit(EXIT_SUCCESS);
 
             default:
                 show_usage();
                 exit(EXIT_FAILURE);
         }
    }

}


void
sdl_init()
{
  if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_EVENTTHREAD) < 0) {
    perror("SDL_Init");
    exit(EXIT_FAILURE);
  }
  SDL_WM_SetCaption("OpenCL WebCam", NULL);
  atexit(SDL_Quit);
}
 
void
create_rgb_surface()
{
  screen.rgb.rmask = 0x000000ff;
  screen.rgb.gmask = 0x0000ff00;
  screen.rgb.bmask = 0x00ff0000;
  screen.rgb.amask = 0xff000000;
  screen.rgb.width = screen.width;
  screen.rgb.height = screen.height;
  screen.rgb.bpp = screen.bpp;
  screen.rgb.pitch = screen.width * 4;
  screen.rgb.pixels_num = screen.width * screen.height * 4;
  screen.rgb.pixels = (unsigned char *)malloc(screen.rgb.pixels_num);
  memset(screen.rgb.pixels, 0, screen.rgb.pixels_num);
  screen.rgb.surface = SDL_CreateRGBSurfaceFrom(screen.rgb.pixels,
                        screen.rgb.width,
                        screen.rgb.height,
                        screen.rgb.bpp,
                        screen.rgb.pitch,
                        screen.rgb.rmask,
                        screen.rgb.gmask,
                        screen.rgb.bmask,
                        screen.rgb.amask);
}
 
void
update_rgb_surface(int index)
{
 if(colorConvertWay==HARDWARE)
  yuyv2rgb_hw(video.buffer.buf[index].start);
 else
  yuyv2rgb_sw(video.buffer.buf[index].start);

  if(shotRGBPic==1)
  {
	shotRGBPic=0;
  	encode_rgbx_jpeg(screen.rgb.pixels,screen.rgb.width,screen.rgb.height,(char *)"rgb.jpeg");
  }
  if(shotGRAYPic==1)
  {
	shotGRAYPic=0;
	encode_gray_jpeg(grayPic,screen.rgb.width,screen.rgb.height,(char *)"gray.jpeg");	
  }

  SDL_BlitSurface(screen.rgb.surface, NULL, screen.display, NULL);
  SDL_Flip(screen.display);
}
 
void
yuyv2rgb_sw(const void *start)
{
  unsigned char *data = (unsigned char *)start;
  unsigned char *pixels = screen.rgb.pixels;
  int width = screen.rgb.width;
  int height = screen.rgb.height;
  unsigned char Y, Cr, Cb;
  int r, g, b;
  int x, y;
  int p1, p2, p3, p4;
 
  double st= getMillSecond();
  for (y = 0; y < height; y++) {
    for (x = 0; x < width; x++) {
      p1 = y * width * 2 + x * 2;
      Y = data[p1];
      if (x % 2 == 0) {
    p2 = y * width * 2 + (x * 2 + 1);
    p3 = y * width * 2 + (x * 2 + 3);
      }
      else {
    p2 = y * width * 2 + (x * 2 - 1);
    p3 = y * width * 2 + (x * 2 + 1);
      }
      Cb = data[p2];
      Cr = data[p3];
      yCbCr2rgb(Y, Cb, Cr, &r, &g, &b);
      p4 = y * width * 4 + x * 4;
      pixels[p4] = r;
      pixels[p4 + 1] = g;
      pixels[p4 + 2] = b;
      pixels[p4 + 3] = 255;
      grayPic[width*y+x]=clamp(0.299*r + 0.587*g + 0.114*b);

    }
  }
    double et= getMillSecond();
    double time = et-st;
    printf("soft use time = %.3fms\n", (float)time);
}
 
void
yCbCr2rgb(unsigned char Y,
    unsigned char Cb,
    unsigned char Cr,
    int *ER,
    int *EG,
    int *EB)
{
  double y1, pb, pr, r, g, b;
 
  y1 = (255 / 219.0) * (Y - 16);
  pb = (255 / 224.0) * (Cb - 128);
  pr = (255 / 224.0) * (Cr - 128);
  r = 1.0 * y1 + 0 * pb + 1.402 * pr;
  g = 1.0 * y1 - 0.344 * pb - 0.714 * pr;
  b = 1.0 * y1 + 1.722 * pb + 0 * pr;
  *ER = clamp(r);
  *EG = clamp(g);
  *EB = clamp(b);
}
 
int
clamp(double x)
{
  int r = x;
  if (r < 0)
    return 0;
  else if (r > 255)
    return 255;
  else
    return r;
}

void yuyv2rgb_hw(const void *start)
{

  unsigned char *data = (unsigned char *)start;
  unsigned char *pixels = screen.rgb.pixels;
  int width = screen.rgb.width;
  int height = screen.rgb.height;
  unsigned int srcStride = width * 2;
  unsigned int dstStride = width * 4;


    double sta = getMillSecond();

    cl_mem buf_yuyv = clCreateBuffer(context, CL_MEM_READ_ONLY, width*height*2*sizeof(unsigned char), NULL, NULL);
    cl_mem buf_rgb = clCreateBuffer(context, CL_MEM_WRITE_ONLY, width*height*4*sizeof(unsigned char), NULL, NULL);
    cl_mem buf_gray = clCreateBuffer(context, CL_MEM_WRITE_ONLY, width*height*sizeof(unsigned char), NULL, NULL);

    status= clEnqueueWriteBuffer(queue, buf_yuyv, CL_TRUE, 0, width*height*2*sizeof(unsigned char), data, 0, NULL, NULL);
   
    status= clSetKernelArg(kernel, 0, sizeof(cl_mem), &buf_yuyv);
    status= clSetKernelArg(kernel, 1, sizeof(int), &srcStride);
    status= clSetKernelArg(kernel, 2, sizeof(int), &dstStride);
    status= clSetKernelArg(kernel, 3, sizeof(cl_mem), &buf_rgb);
    status= clSetKernelArg(kernel, 4, sizeof(cl_mem), &buf_gray);
  // Configure work set over which the kernel will execute
   size_t globalSize[] = {width/2, height,0};
   size_t localSize[] = {1, 1, 1};

  // Launch the kernel
    double st = getMillSecond();
    status= clEnqueueNDRangeKernel(queue, kernel, 2, NULL, globalSize, localSize, 0, NULL, NULL);
     //checkError(status, "Failed to launch kernel");
     // Wait for command queue to complete pending events
    status = clFinish(queue);
    double et= getMillSecond();
    double time = et-st;
    printf("OpenCL Kernel run time = %.3fms\n", (float)time);
    checkError(status, "\nKernel Failed to finish");

    status = clEnqueueReadBuffer(queue, buf_rgb, CL_TRUE, 0, width*height*4*sizeof(unsigned char), pixels, 0, NULL, NULL);
    status = clEnqueueReadBuffer(queue, buf_gray, CL_TRUE, 0, width*height*sizeof(unsigned char), grayPic, 0, NULL, NULL);
    checkError(status, "Failed to Copy RGB");

  //	clReleaseEvent(event);
    clReleaseMemObject(buf_yuyv);
    clReleaseMemObject(buf_rgb);
    clReleaseMemObject(buf_gray);
   double eta = getMillSecond();
   double time2 = eta-sta;
   printf("OpenCL run time = %.3fms\n", (float)time2);

}

 
void
screen_init()
{
  screen.width = opt.width;
  screen.height = opt.height;
  screen.bpp = 32;
  screen.running = 1;
  screen.display = SDL_SetVideoMode(screen.width,
                    screen.height,
                    screen.bpp,
                    SDL_SWSURFACE | SDL_DOUBLEBUF);
  if (screen.display == NULL) {
    perror("SDL_SetVideoMode");
    exit(EXIT_FAILURE);
  }
  sdl_init();
  create_rgb_surface();
}
 
void
screen_quit()
{
  SDL_FreeSurface(screen.display);
  SDL_FreeSurface(screen.rgb.surface);
  free(screen.rgb.pixels);
  SDL_Quit();
}
 
void
screen_mainloop()
{
  int i;
 
  for (i = 0; screen.running && i <= video.buffer.req.count; i++) {
    if (i == video.buffer.req.count) {
      i = 0;
    }
    buffer_dequeue(i);
    update_rgb_surface(i);
    if (SDL_PollEvent(&screen.event) == 1) {
      switch (screen.event.type) {
      case SDL_KEYDOWN:
    switch (screen.event.key.keysym.sym) {
    case SDLK_q:
      puts("bye");
      screen.running = 0;
      break;
    case SDLK_s:
      SDL_WM_SetCaption("SOFT WebCam", NULL);
      colorConvertWay = SOFTWARE;
      break;
    case SDLK_h:
      SDL_WM_SetCaption("HW WebCam", NULL);
      colorConvertWay = HARDWARE;
      break;
    case SDLK_r:
	shotRGBPic=1;
      break;
    case SDLK_g:
	shotGRAYPic=1;
      break;
	
    default:
      break;
    }
    break;
      case SDL_QUIT:
    screen.running = 0;
    break;
      default:
    break;
      }
    }
    buffer_enqueue(i);
  }
}


 void
video_open()
{
  int i, fd;
  char device[13];
 
  for (i = 0; i < 99; i++) {
    sprintf(device, "%s%d", "/dev/video", i);
    fd = open(device, O_RDWR);
    if (fd != -1) {
      if (opt.verbose) {
    printf("open %s success\n", device);
      }
      break;
    }
  }
  if (i == 100) {
    perror("video open fail");
    exit(EXIT_FAILURE);
  }
  video.fd = fd;
}
 
 void
video_close()
{
  close(video.fd);
}
 
 void
video_set_format()
{
  memset(&video.format, 0, sizeof(video.format));
  video.format.type = stream_flag;
  video.format.fmt.pix.width = opt.width;
  video.format.fmt.pix.height = opt.height;
  video.format.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
  if (ioctl(video.fd, VIDIOC_S_FMT, &video.format) == -1) {
    perror("VIDIOC_S_FORMAT");
    exit(EXIT_FAILURE);
  }
}
 
 void
video_streamon()
{
  if (ioctl(video.fd, VIDIOC_STREAMON, &stream_flag) == -1) {
    if (errno == EINVAL) {
      perror("streaming i/o is not support");
    }
    else {
      perror("VIDIOC_STREAMON");
    }
    exit(EXIT_FAILURE);
  }
}
 
 void
video_streamoff()
{
  if (ioctl(video.fd, VIDIOC_STREAMOFF, &stream_flag) == -1) {
    if (errno == EINVAL) {
      perror("streaming i/o is not support");
    }
    else {
      perror("VIDIOC_STREAMOFF");
    }
    exit(EXIT_FAILURE);
  }
}
 
 void
buffer_init()
{
  int i;
 
  buffer_request();
  for (i = 0; i < video.buffer.req.count; i++) {
    buffer_mmap(i);
    buffer_enqueue(i);
  }
}
 
 void
buffer_free()
{
  int i;
 
  for (i = 0; i < video.buffer.req.count; i++) {
    munmap(video.buffer.buf[i].start, video.buffer.buf[i].length);
  }
  free(video.buffer.buf);
}
 
 void buffer_request()
{
 
  memset(&video.buffer.req, 0, sizeof(video.buffer.req));
  video.buffer.req.type = stream_flag;
  video.buffer.req.memory = V4L2_MEMORY_MMAP;
  video.buffer.req.count = BUFFER_NUM;
  /* 设置视频帧缓冲规格 */
  if (ioctl(video.fd, VIDIOC_REQBUFS, &video.buffer.req) == -1) {
    if (errno == EINVAL) {
      perror("video capturing or mmap-streaming is not support");
    }
    else {
      perror("VIDIOC_REQBUFS");
    }
    exit(EXIT_FAILURE);
  }
  if (video.buffer.req.count < BUFFER_NUM) {
    perror("no enough buffer");
    exit(EXIT_FAILURE);
  }
  video.buffer.buf = (buff *)calloc(video.buffer.req.count, sizeof(*video.buffer.buf));
  assert(video.buffer.buf != NULL);
}
 
 void
buffer_mmap(int index)
{
  memset(&video.buffer.query, 0, sizeof(video.buffer.query));
  video.buffer.query.type = video.buffer.req.type;
  video.buffer.query.memory = V4L2_MEMORY_MMAP;
  video.buffer.query.index = index;
  /* 视频帧缓冲映射 */
  if (ioctl(video.fd, VIDIOC_QUERYBUF, &video.buffer.query) == -1) {
    perror("VIDIOC_QUERYBUF");
    exit(EXIT_FAILURE);
  }
  video.buffer.buf[index].length = video.buffer.query.length;
  video.buffer.buf[index].start = mmap(NULL,
                       video.buffer.query.length,
                       PROT_READ | PROT_WRITE,
                       MAP_SHARED,
                       video.fd,
                       video.buffer.query.m.offset);
  if (video.buffer.buf[index].start == MAP_FAILED) {
    perror("mmap");
    exit(EXIT_FAILURE);
  }
}
 
void
video_init()
{
  video_open();
  video_set_format();
  buffer_init();
  video_streamon();
}
 
void
video_quit()
{
  video_streamoff();
  video_close();
  buffer_free();
}
 
void
buffer_enqueue(int index)
{
    memset(&video.buffer.query, 0, sizeof(video.buffer.query));
    video.buffer.query.type = video.buffer.req.type;
    video.buffer.query.memory = V4L2_MEMORY_MMAP;
    video.buffer.query.index = index;
    /* 视频帧缓冲入队 */
    if (ioctl(video.fd, VIDIOC_QBUF, &video.buffer.query) == -1) {
      perror("VIDIOC_QBUF");
      exit(EXIT_FAILURE);
    }
}
 
void
buffer_dequeue(int index)
{
    memset(&video.buffer.query, 0, sizeof(video.buffer.query));
    video.buffer.query.type = video.buffer.req.type;
    video.buffer.query.memory = V4L2_MEMORY_MMAP;
    video.buffer.query.index = index;
    /* 视频帧缓冲出队 */
    if (ioctl(video.fd, VIDIOC_DQBUF, &video.buffer.query) == -1) {
      perror("VIDIOC_DQBUF");
      exit(EXIT_FAILURE);
    }
}

int encode_gray_jpeg(unsigned char *lpbuf,int width,int height,char *filename)  
{  
    struct jpeg_compress_struct cinfo ;  
    struct jpeg_error_mgr jerr ;  
    JSAMPROW  row_pointer[1] ;  
    int row_stride ;   
  
    FILE *fptr_jpg = fopen (filename,"wb");
    if(fptr_jpg==NULL)  
    {  
    printf("Encoder:open file failed!/n") ;  
     return FALSE;  
    }  
  
    cinfo.err = jpeg_std_error(&jerr);  
    jpeg_create_compress(&cinfo);  
    jpeg_stdio_dest(&cinfo, fptr_jpg);  
  
    cinfo.image_width = width;  
    cinfo.image_height = height;  
    cinfo.input_components = 1;  
    cinfo.in_color_space = JCS_GRAYSCALE;  
  
    jpeg_set_defaults(&cinfo);  
  
  
    jpeg_set_quality(&cinfo, 80,TRUE);  
  
  
    jpeg_start_compress(&cinfo, TRUE);  
  
    row_stride = width;  
    while (cinfo.next_scanline < height)  
    {  
    row_pointer[0]=&lpbuf[cinfo.next_scanline*width];
    jpeg_write_scanlines (&cinfo, row_pointer, 1);//critical  
  
    }  
  
    jpeg_finish_compress(&cinfo);  
    fclose(fptr_jpg);  
    jpeg_destroy_compress(&cinfo);   
    return TRUE ;  
} 


int encode_rgb_jpeg(unsigned char *lpbuf,int width,int height,char *filename)  
{  
    struct jpeg_compress_struct cinfo ;  
    struct jpeg_error_mgr jerr ;  
    JSAMPROW  row_pointer[1] ;  
    int row_stride ;  
    unsigned char *buf=NULL ;  
    int i,j ;  
  
    FILE *fptr_jpg = fopen (filename,"wb");
    if(fptr_jpg==NULL)  
    {  
    printf("Encoder:open file failed!/n") ;  
     return FALSE;  
    }  
  
    cinfo.err = jpeg_std_error(&jerr);  
    jpeg_create_compress(&cinfo);  
    jpeg_stdio_dest(&cinfo, fptr_jpg);  
  
    cinfo.image_width = width;  
    cinfo.image_height = height;  
    cinfo.input_components = 3;  
    cinfo.in_color_space = JCS_RGB;  
  
    jpeg_set_defaults(&cinfo);  
  
  
    jpeg_set_quality(&cinfo, 80,TRUE);  
  
  
    jpeg_start_compress(&cinfo, TRUE);  
  
    row_stride = width * 3;  
    buf=(unsigned char *)malloc(row_stride) ;  
    row_pointer[0] = buf;  
    while (cinfo.next_scanline < height)  
    {  
     for (i=0,j=0; i < row_stride; i+=3,j+=4)  //4 channel JCS_EXT_RGBX to 3 channel JCS_RGB; 
    {  
  
    buf[i]   = lpbuf[j];  
    buf[i+1] = lpbuf[j+1];  
    buf[i+2] = lpbuf[j+2];  

    }  
    jpeg_write_scanlines (&cinfo, row_pointer, 1);//critical  
    lpbuf += width*4;  
    }  
  
    jpeg_finish_compress(&cinfo);  
    fclose(fptr_jpg);  
    jpeg_destroy_compress(&cinfo);  
    free(buf) ;  
    return TRUE ;  
  
}    


int encode_rgbx_jpeg(unsigned char *lpbuf,int width,int height,char *filename)  
{  
    struct jpeg_compress_struct cinfo ;  
    struct jpeg_error_mgr jerr ;  
    JSAMPROW  row_pointer[1] ;  
    int row_stride ;  
    unsigned char *buf=NULL ;  
    int i;  
  
    FILE *fptr_jpg = fopen (filename,"wb");//fopen
    if(fptr_jpg==NULL)  
    {  
    printf("Encoder:open file failed!/n") ;  
     return FALSE;  
    }  
  
    cinfo.err = jpeg_std_error(&jerr);  
    jpeg_create_compress(&cinfo);  
    jpeg_stdio_dest(&cinfo, fptr_jpg);  
  
    cinfo.image_width = width;  
    cinfo.image_height = height;  
    cinfo.input_components = 4;  
    cinfo.in_color_space = JCS_EXT_RGBX;  //4 channel
  
    jpeg_set_defaults(&cinfo);  
  
  
    jpeg_set_quality(&cinfo, 80,TRUE);  
  
  
    jpeg_start_compress(&cinfo, TRUE);  
  
    row_stride = width * 4;  
    row_pointer[0] = lpbuf;  
    while (cinfo.next_scanline < height)  
    {  
    row_pointer[0]=&lpbuf[cinfo.next_scanline*row_stride]; 
    jpeg_write_scanlines (&cinfo, row_pointer, 1);//critical  
    }  
  
    jpeg_finish_compress(&cinfo);  
    fclose(fptr_jpg);  
    jpeg_destroy_compress(&cinfo);   
    return TRUE ;  
  
}    


