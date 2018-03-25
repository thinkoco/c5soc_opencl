#ifndef OPT_H
#define OPT_H
 
struct options
{
	int verbose;
	int hw;
	int width;
	int height;
};

void options_init();
void parseArgs(int argc, char *argv[], options *opt);

#endif

