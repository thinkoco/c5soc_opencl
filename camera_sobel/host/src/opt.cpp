#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <iostream>
#include <assert.h>
#include <getopt.h>
#include "opt.h"
#include "defines.h"


struct options opt;
 
static void show_usage();

void show_usage()
{
   fprintf(stderr, "Usage: camera_sobel [options]\n"
      "Options:\n"
       "-v | --verbose       Show message in shell\n"
       "-h | --hardware        height of Video\n"

       "For example: camera_sobel -v \n\n");
}
 

void
options_init()
{
  opt.verbose = 1;
  opt.hw = 0 ;
  opt.width = COLS;
  opt.height = ROWS;
}


void parseArgs(int argc, char *argv[], options *opt)
 {
     const char shortOptions[] = "vh:";
     const struct option longOptions[] = {
         {"verbose",		no_argument, 		NULL, 'v'},
         {"hardware", 		required_argument, NULL, 'h'},

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
                 opt->hw = atoi(optarg);
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

