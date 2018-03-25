#ifndef OPT_H
#define OPT_H
 
struct options
{
	int verbose;
	int hw;
	int gray;
	int width;
	int height;
	int r;
	int g;
	int b;
	int upvalue;
	int downvalue;
};

void options_init();
void parseArgs(int argc, char *argv[], options *opt);

#endif

