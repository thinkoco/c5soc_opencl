#include <stdio.h>
#include <assert.h>
#include <iostream>
#include <algorithm>
#include <stdlib.h>
#include <string.h>
#include "screen.h"
#include "opt.h"
#include "video.h"
#include "color.h"
#include <SDL2/SDL.h>
extern struct options opt;
extern struct video video;
extern unsigned int   *host_output;
extern unsigned short *host_input;
extern unsigned int thresh;
struct screen screen;

static void sdl_init();
static void create_rgb_surface();
static void update_rgb_surface(int index);
static void update_rgb_pixels(const void *start);
static void keyboardPressEvent(SDL_Event *event);

 
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
	screen.rgb.pixels_num = screen.width * screen.height;
	screen.rgb.pixels = (unsigned int *)malloc(sizeof(unsigned int)*screen.rgb.pixels_num);
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
static void update_rgb_pixels(const void *start){
	unsigned short * data = (unsigned short *) start;
	unsigned int* pixels = (unsigned int*)screen.rgb.pixels;
	int width = screen.rgb.width;
	int height = screen.rgb.height;
	unsigned char Y;	 
	for (int y = 0; y < height; y++)
	{
		for (int x = 0; x < width; x++)
		{   
			Y = data[y*width + x] & 0xFF;
			pixels[y*width + x] = Y | (Y <<8) |(Y << 16) | (0xFF << 24);
		}
	}

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

