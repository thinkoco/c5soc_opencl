unsigned char clamp_uc(int v, int l, int h)
{
    if (v > h)
        v = h;
    if (v < l)
        v = l;
    return (unsigned char)v;
}

__kernel void grayKernel(	__global unsigned char *restrict yuyv,
							unsigned int srcStride,
							unsigned int dstStride,
							__global unsigned char *restrict rgb,
							__global unsigned char *restrict gray)
{
    int x = get_global_id(0) * 2; // extend the x-width since it is macropixel indexed
    int y = get_global_id(1);
    int y0,u0,y1,v0,r,g,b;
    
    // determine yuyv index 
    int i = (y * srcStride) + (x * 2); // xstride == 2
    
    // determine rgb index
    int j = (y * dstStride) + (x * 4); // xstride == 4
	
    int k = (y * srcStride>>1) + x; // xstride == 1
	
	y0 = yuyv[i+0] - 16;
	u0 = yuyv[i+1] - 128;
    y1 = yuyv[i+2] - 16;
    v0 = yuyv[i+3] - 128;
    
   
    r = clamp_uc(((74 * y0) + (102 * v0)) >> 6 ,0,255); 
    g = clamp_uc(((74 * y0) - (52 * v0) - (25 * u0)) >> 6,0,255);
    b = clamp_uc(((74 * y0) + (129 * u0)) >> 6,0,255);
    
    rgb[j + 0] = r;
    rgb[j + 1] = g;
    rgb[j + 2] = b;
	rgb[j + 3] = 255;
	gray[k+0] = clamp_uc((77*r+151*g+28*b) >> 8,0,255);
    
	r = clamp_uc(((74 * y1) + (102 * v0)) >> 6 ,0,255); 
    g = clamp_uc(((74 * y1) - (52 * v0) - (25 * u0)) >> 6,0,255);
    b = clamp_uc(((74 * y1) + (129 * u0)) >> 6,0,255);
    
    rgb[j + 4] = r;
    rgb[j + 5] = g;
    rgb[j + 6] = b;
	rgb[j + 7] = 255;
	gray[k+1] = clamp_uc((77*r+151*g+28*b) >> 8,0,255);
}
