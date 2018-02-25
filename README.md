# IntelFPGA Cyclone V SoC OpenCL

##  Hardware Architecture
![](picture/arch.png)


## Supported Boards
- [x] [DE1-SoC](http://www.terasic.com.cn/cgi-bin/page/archive.pl?Language=China&CategoryNo=182&No=870)
- [x] [DE10-Nano](http://www.terasic.com.cn/cgi-bin/page/archive.pl?Language=China&CategoryNo=203&No=1048)
- [ ] [DE10-Standard](http://www.terasic.com.cn/cgi-bin/page/archive.pl?Language=China&CategoryNo=182&No=1105)
- [ ] [DE0-Nano-SoC](http://www.terasic.com.cn/cgi-bin/page/archive.pl?Language=China&CategoryNo=203&No=954) + Arduino LCD 

## Supported USB Cameras

- UVC (USB video device class) USB Cameras,for example Logitech C270
- USB Cameras supported by gspca driver,for example ZC301

## SD Card Image links

You can use the SD card Image files directly without building kernel and OpenCL 16.1 environment.

- [x] DE1-SoC [Baidu Cloud Link](http://pan.baidu.com/s/1ge6wJhp) or [Google Drive Link](https://drive.google.com/drive/folders/1Ly0_IXAf4yZpqq_qGX45RUcDkPlZyk-U)
- [x] DE10-Nano [Baidu Cloud Link](https://pan.baidu.com/s/1pNsUHSn) or [Google Drive Link](https://drive.google.com/open?id=1NGk-Dp_oo90QLhaNKBRPbdPdf7fR1IJv)
- [ ] DE10-Standard
- [ ] DE0-Nano-SoC

## Run OpenCL Application

1. Download  the Image file and write it into the microSD card
2. Insert the SD card into the microSD card socket(J11)
3. MSEL[4:0] ——> 01010， SW10(**1 to 6**) on,off,on,off,on,N/A
4. For de1soc D version , use an USB cable to connect your Host PC with the UART-to-USB port (J4) on DE1-SoC.(F version no need)
5. Connect the monitor,keyboard and mouse to DE1-SoC
6. Power on DE1-SoC to boot Linux 
7. Open the kconsole (Ctrl+Alt+T) on the de1soc desktop and run OpenCL host directly. 

Some compiled binaries are in [compiled_bin_sdk16.1](https://github.com/thinkoco/de1_soc_opencl/tree/master/compiled_bin_sdk16.1) folder.

## OpenCL Hardware Template
**de1soc_sharedonly_vga** is a DE1SOC's OpenCL hardware template that supports VGA and desktop.Copy the file to de1soc OpenCL BSP path.
**this template also supports Altera SDK for OpenCL 14.1**

**de10_nano_sharedonly_hdmi** is a DE10_nano's OpenCL hardware template (Intel FPGA SDK for OpenCL 16.1)that supports VGA and desktop .
**release edition**

**de10_standard_sharedonly_vga** is a DE10_Standard's OpenCL hardware template (Intel FPGA SDK for OpenCL 16.1)that supports VGA and desktop .
**Not release edition**

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

## Planing

- [x] add mandelbrot application
- [x]  **update to DE10-nano**
- [ ]  **add DE10-Standard BSP**
- [ ]  **add DE0-Nano-SoC BSP**
- [ ] **DE0-Nano-SoC + Arduino LCD BSP**
- [ ] update template to Intel FPGA SDK for OpenCL 17.x
- [ ] add colorGaryAPP shared memory edition



## Limits

Set the CL_CONTEXT_COMPILER_MODE_ALTERA=3 flag in your host code to disable the reading of the .aocx file and the reprogramming of the FPGA.
When running desktop, copy your generated top.rbf to fat32 partition and rename to opencl.rbf.
opencl.rbf file should match the same host app and run host with CL_CONTEXT_COMPILER_MODE_ALTERA=3 flag . 

## How to do
Here are some [guides](HowToDo.md).

