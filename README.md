# IntelFPGA Cyclone V SoC OpenCL

##  Hardware Architecture
![](picture/arch.png)


## Supported Boards
- [x] [DE1-SoC](http://www.terasic.com.cn/cgi-bin/page/archive.pl?Language=China&CategoryNo=182&No=870)
- [x] [DE10-Nano](http://www.terasic.com.cn/cgi-bin/page/archive.pl?Language=China&CategoryNo=203&No=1048)
- [x] [DE10-Standard](http://www.terasic.com.cn/cgi-bin/page/archive.pl?Language=China&CategoryNo=182&No=1105)
- [ ] ~~[DE0-Nano-SoC](http://www.terasic.com.cn/cgi-bin/page/archive.pl?Language=China&CategoryNo=203&No=954) + Arduino LCD~~

## Supported USB Cameras

- UVC (USB video device class) USB Cameras,for example Logitech C270
- USB Cameras supported by gspca driver
- etc.

## SD Card Image Features

- [x] both IntelFPGA OpenCL SDK 16.1 and 17.1
- [x] also working with terasic's OpenCL hardware template BSP(no vedio ip core)
- [x] also working without OpenCL
- [x] support x2go server (run desktop through ethernet)
- [x] All in one ( DE1-SoC , DE10-Nano and DE10-Standard)
- [x] usb host and uvc driver for UVC cameras


You can downlaod the all in one SD card Image file here [Baidu Cloud Link](https://pan.baidu.com/s/1KDyexwHD39uyvcMDm0G97A) or [Google Drive Link](https://drive.google.com/open?id=1mAYHFvOw2xtgf-e8pntFCxCGOdaYNsgG).

- [x] DE1-SoC
- [x] DE10-Nano 
- [x] DE10-Standard

## Run OpenCL Application

1. Download the Image file and write it into the microSD card
2. Cpoy the xxxx.rbf and xxxx_socfpga.dtb (which keep same as your target board) to Windows fat32 partition and rename them to opencl.rbf and socfpga.dtb 
3. Insert the programmed microSD card to the DE10-nano or DE1-SoC or DE10-Standard board 
4. Set the MSEL[4:0] on your board to 01010 , SW10(**1 to 6**) on,off,on,off,on,N/A
5. Connect a  monitor to the HDMI or VGA port on baord
6. Conect USB mouse and keyboard to the USB ports on the board
7. Conect UART to PC ( ** must conect to PC or Power **)
8. Power on the board and you will see the LXDE graphical environment
9. Open the console (Ctrl+Alt+T) on the desktop 
10. source the **init_opencl_16.1.sh** or  **init_opencl_17.1.sh** file 
11. run OpenCL host (which keep same as your target board and the OpenCL SDK version ) directly. 

## OpenCL Hardware Template

**Both supports IntelFPGA SDK for OpenCL 16.1 and 17.1**

**de1soc_sharedonly_vga** is a DE1SOC's OpenCL hardware template that supports VGA and desktop.

**de10_nano_sharedonly_hdmi** is a DE10_nano's OpenCL hardware template that supports HDMI and desktop .

**de10_standard_sharedonly_vga** is a DE10_Standard's OpenCL hardware template that supports VGA and desktop .


## App
### colorApp
A UVC usb camera application program is used to convert YUYV to RGB and Gray by using opencl.

![](picture/colorApp.png)

Host usage:

	grayKernel -w960 -h720 
	grayKernel -w640 -h480 -r2 -g1 -b2 -u700 -d200 

### sobel_filter

do sobel by using four methods : arm , neon , opencl ,opencl with shared memory

![](picture/sobel.png)

| Methods              | Frequency |  Time     |
| :--------            |:---------:|:---------:|
| Cortex-A9            | 800Mhz    | 168ms     |
| Neon                 | ?         | 37ms      |
| OpenCL Memory Copy   | 140Mhz    | 256ms     |
| OpenCL Shared Memory | 140Mhz    | 14.8ms    |

Host useage:

	number 1 2 3 4 5 6 different ways to run filter
	"+"  Increase filter threshold
	"="  Reset filter threshold to default
	 " q/<enter>/<esc>" Quit the program

### Mandelbrot

![](picture/mandelbrot.png)

Host useage:

	mandelbrot -w=800 -h=640 -c=32

## X2GO

X2Go enables you to access a graphical desktop of a computer over a low bandwidth (or high bandwidth) connection.
You can also use terasic's hardware templates which includes no vedio ip core to build the OpenCL aocx file.Then,
you can get more fpga resouce and dynamic configuration for OpenCL.In this way, you need update the device tree
binary file which contains no vedio ip core descriptoin and delete the CL_CONTEXT_COMPILER_MODE_xxx flag in initail shell file.

![](picture/x2go.png)

## Plans

- [x] add mandelbrot application
- [x] add to DE10-nano BSP
- [x] update template to Intel FPGA SDK for OpenCL 17.x
- [x] add DE10-Standard BSP
- [ ] add DE0-Nano-SoC BSP
- [ ] DE0-Nano-SoC + Arduino LCD BS
- [ ] add colorGaryAPP shared memory edition

## Limits

Set the CL_CONTEXT_COMPILER_MODE_ALTERA=3  (opencl sdk16.1 ) flag in environment to disable the reprogramming of the FPGA by host. When running desktop, copy your generated top.rbf to fat32 partition and rename to opencl.rbf. opencl.rbf file should match the same host app and run host with CL_CONTEXT_COMPILER_MODE_ALTERA=3 flag .

CL_CONTEXT_COMPILER_MODE_INTELFPGA=3 (opencl sdk17.1)

## How to do
Here are some [guides](HowToDo.md).

