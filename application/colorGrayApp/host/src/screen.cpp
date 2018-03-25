#include <stdio.h>
#include <assert.h>
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include "screen.h"
#include "opt.h"
#include "video.h"
#include "color.h"
#include <SDL2/SDL.h>
extern struct options opt;
extern struct video video;
extern unsigned char *host_output;
extern unsigned char *host_input;
struct screen screen;

static void sdl_init();
static void create_rgb_surface();
static void update_rgb_surface(int index);
static void update_rgb_pixels(const void *start);
static void keyboardPressEvent(SDL_Event *event);
static void yuv2rgb(unsigned char Y,
            unsigned char Cb,
            unsigned char Cr,
            int *ER,
            int *EG,
            int *EB);
static int clamp(double x);
 
static void sdl_init()
{
  // Initialize.
  if(SDL_Init(SDL_INIT_VIDEO) != 0) {
    std::cerr << "Error: Could not initialize SDL: " << SDL_GetError() << "\n";
  }

    // Create the window.
      screen.theWindow = SDL_CreateWindow("YUYV to RGB", 
      SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
      screen.width, screen.height, 0);
    if(screen.theWindow == NULL) {
      std::cerr << "Error: Could not create SDL window: " << SDL_GetError() << "\n";
    }

    // Get the window's surface.
    screen.theWindowSurface = SDL_GetWindowSurface( screen.theWindow);
    if(screen.theWindowSurface == NULL) {
      std::cerr << "Error: Could not get SDL window surface: " << SDL_GetError() << "\n";
    }
}

static void
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

	screen.rgb.surface = SDL_CreateRGBSurfaceFrom(host_output,
	                    screen.rgb.width,
	                    screen.rgb.height,
	                    screen.rgb.bpp,
	                    screen.rgb.pitch,
	                    screen.rgb.rmask,
	                    screen.rgb.gmask,
	                    screen.rgb.bmask,
	                    screen.rgb.amask);

	screen.rgb.surface_sw = SDL_CreateRGBSurfaceFrom(screen.rgb.pixels,
	                    screen.rgb.width,
	                    screen.rgb.height,
	                    screen.rgb.bpp,
	                    screen.rgb.pitch,
	                    screen.rgb.rmask,
	                    screen.rgb.gmask,
	                    screen.rgb.bmask,
	                    screen.rgb.amask);
}

int saveVideo(char* fileName, char* pData, int dataLen)
{
	//open file.
	FILE* fp = fopen(fileName, "a+");
	if(!fp)
	{
		perror("open file error");
		return -1;
	}

	//write data to file
	fwrite(pData, dataLen, 1, fp);

	//close file.
	fclose(fp);

	return 0;
}

static void update_rgb_surface(int index)
{
	if(opt.hw == 1){
		yuyv2rgb_hw(host_input);
		SDL_BlitScaled(screen.rgb.surface, NULL, screen.theWindowSurface, NULL);
	}else{
		update_rgb_pixels(video.buffer.buf[index].start);
		SDL_BlitScaled(screen.rgb.surface_sw, NULL, screen.theWindowSurface, NULL);
	}
	SDL_UpdateWindowSurface(screen.theWindow);
}
 
static void update_rgb_pixels(const void *start)
{
	unsigned char *data = (unsigned char *)start;
	unsigned char *pixels = screen.rgb.pixels;
	int width = screen.rgb.width;
	int height = screen.rgb.height;
	unsigned char Y, Cr, Cb;
	int r, g, b;
	int x, y;
	int p1, p2, p3, p4;
 
	for (y = 0; y < height; y++)
	{
		for (x = 0; x < width; x++)
		{
			p1 = y * width * 2 + x * 2;
			Y = data[p1];
			if (x % 2 == 0)
			{
				p2 = y * width * 2 + (x * 2 + 1);
				p3 = y * width * 2 + (x * 2 + 3);
			}
			else
			{
				p2 = y * width * 2 + (x * 2 - 1);
				p3 = y * width * 2 + (x * 2 + 1);
			}
			Cb = data[p2];
			Cr = data[p3];
			yuv2rgb(Y, Cb, Cr, &r, &g, &b);
			p4 = y * width * 4 + x * 4;
			pixels[p4] = r;
			pixels[p4 + 1] = g;
			pixels[p4 + 2] = b;
			pixels[p4 + 3] = 255;
		}
	}
}
 
static void yuv2rgb(unsigned char Y,
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
 
static int clamp(double x)
{
	int r = x;
	if (r < 0)
		return 0;
	else if (r > 255)
		return 255;
	else
		return r;
}
 
void screen_init()
{
	screen.width = opt.width;
	screen.height = opt.height;
	screen.bpp = 32;
	screen.running = 1;
	sdl_init();
	create_rgb_surface();
}
 
void
screen_quit()
{
	free(screen.rgb.pixels);
	SDL_Quit();
}
 
void screen_mainloop()
{
	int i;

	for (i = 0; screen.running && i <= (int)video.buffer.req.count; i++)
	{
		if (i == (int)video.buffer.req.count)
		{
			i = 0;
		}

		buffer_dequeue(i);
		update_rgb_surface(i);
		if (SDL_PollEvent(&screen.event))
		{
			switch (screen.event.type)
			{
				case SDL_KEYDOWN:
					keyboardPressEvent(&screen.event);
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


static void keyboardPressEvent(SDL_Event *event) 
{
  SDL_KeyboardEvent *keyEvent = (SDL_KeyboardEvent *)event;
  switch(keyEvent->keysym.sym) {
    // Quit.
    case SDLK_ESCAPE:
    case SDLK_RETURN:
    case SDLK_q: {
	screen.running = 0;
      SDL_Event quitEvent;
      quitEvent.type = SDL_QUIT;
      SDL_PushEvent(&quitEvent);
    	}
      break;

    	case SDLK_s:
		opt.hw = 0;
		buffer_mmap(0);
		SDL_SetWindowTitle(screen.theWindow,"YUYC to RGB Soft");
		break; 
    	case SDLK_h:
		opt.hw = 1;
		buffer_mmap(0);
		SDL_SetWindowTitle(screen.theWindow,"YUYC to RGB Hardware");
		break; 	
  }
}

