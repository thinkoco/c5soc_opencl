#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <iostream>
#include <assert.h>
#include <getopt.h>
#include "opt.h"



struct options opt;
 
static void show_usage();

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
  opt.verbose = 1;
  opt.hw = 0 ;
  opt.width = 640;
  opt.height = 480;
  opt.r = 1;
  opt.g = 1;
  opt.b = 1;
  opt.upvalue = 76500;
  opt.downvalue = 0;
}


void parseArgs(int argc, char *argv[], options *opt)
 {
     const char shortOptions[] = "vw:h:r:g:b:u:d:";
     const struct option longOptions[] = {
         {"verbose",		no_argument, 		NULL, 'v'},
         {"width",		required_argument, NULL, 'w'},
         {"height", 		required_argument, NULL, 'h'},
         {"rtimes",		required_argument, NULL, 'r'},
         {"gtimes",		required_argument, NULL, 'g'},
         {"btimes",		required_argument, NULL, 'b'},
	 {"upvalue",		required_argument, NULL, 'u'},
	 {"downvalue",		required_argument, NULL, 'd'},
         {0, 0, 0, 0}
     };
	int index;
     int     c;
 
     for (;;) {
         c = getopt_long(argc, argv, shortOptions, longOptions, &index);
 
         if (c == -1) {
             break;
        }

         switch (c) {
             case 0:
                break;
 
             case 'v':
		   opt->verbose=1;
			opt->hw = 1;
                break;

             case 'h':
                 opt->height = atoi(optarg);
                 break;

             case 'w':
                 opt->width = atoi(optarg);
                 break;

             case 'r':
                 opt->r = atoi(optarg);
                 break;

             case 'g':
                 opt->g = atoi(optarg);
                 break;
             case 'b':
                 opt->b = atoi(optarg);
                 break;

             case 'u':
                 opt->upvalue = atoi(optarg);
                 break;

             case 'd':
                 opt->downvalue = atoi(optarg);
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

