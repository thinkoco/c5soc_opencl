#include <stdlib.h>
#include "opt.h"
#include "video.h"
#include "screen.h"
#include "color.h"
extern options opt;
int main(int argc, char *argv[])
{
	options_init();
	parseArgs(argc, argv, &opt);
	init_opencl();
	video_init();
	screen_init();
	screen_mainloop();
	screen_quit();
	video_quit();
	cleanup();
	exit(EXIT_SUCCESS);
}

