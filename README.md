# de1_soc_opencl
## Structure
![](structure.png)

## Tools
###　Windows
- Quartus Prime Standard Edition 16.1
- Intel FPGA SDK for OpenCL 16.1
- SoC Embedded Design Suite (EDS)

It's easy to use Linux commands in Soc_EDS_coomand_shell.bat On windows.Support arm-linux-guneabihf-gcc,make,dd and so on.

### Linux (Ubuntu 16.04)
- Quartus Prime Standard Edition 16.1
- Intel FPGA SDK for OpenCL 16.1
- arm-linux-gnueabihf-gcc
- arm-linux-gnueabihf-g++
- u-boot-tools

## Hardware
### Boards
[DE1SoC](http://www.terasic.com.cn/cgi-bin/page/archive.pl?Language=China&CategoryNo=182&No=870)
It's easy to move On DE10-Standard
### support USB Camera
- UVC (USB video device class) USB Cameras
- USB Cameras supported by gspca driver

for example Logitech C270, ZC301

## How To Do 

	sudo add-apt-repository multiverse
	sudo apt update
	sudo apt install u-boot-tools
	sudo apt install gcc-arm-linux-gnueabihf
	sudo apt install g++-arm-linux-gnueabihf

	wget http://www.terasic.com.cn/attachment/archive/836/DE1SOC_OpenCL_v02.pdf
	wget http://www.terasic.com/downloads/cd-rom/de1-soc/DE1_SoC_OpenCL_BSP_16.0_V1.1.zip
	unzip DE1_SoC_OpenCL_BSP_16.0_V1.1.zip
	mkdir -p ~/intelFPGA/16.1/hld/board/terasic

	cp -rf de1soc ~/intelFPGA/16.1/hld/board/terasic

	git clone https://github.com/thinkoco/de1_soc_opencl.git
	cd de1_soc_opencl 
	cp -rf de1soc_sharedonly_vga ~/intelFPGA/16.1/hld/board/terasic/de1soc

## Enviroment Setting
   For Altera SDK for OpenCL 16.1,refering to [DE1SOC_OpenCL_v02.pdf](http://www.terasic.com.cn/attachment/archive/836/DE1SOC_OpenCL_v02.pdf)
## Hardware Template
**de1soc_sharedonly_vga** is a opencl hardware project that support VGA and desktop for DE1SOC .Copy the file to de1soc OpenCL BSP path

	cp -rf de1soc_sharedonly_vga  ~/intelFPGA/16.1/hld/board/terasic/de1soc

modify the board_env.xml file

	form : hardware dir="." default="de1soc_sharedonly"

	to : hardware dir="." default="de1soc_sharedonly_vga"

**this template also support Altera SDK for OpenCL 14.1**
*planing for Altera SDK for OpenCL 17.0*

## Host APP
### colorGaryAPP
A UVC usb camera application that converting YUYV to RGB and Gray by using opencl.

Compile opencl kernel command:
  aoc device/grayKernel.cl -o bin/grayKernel.aocx --board de1soc_sharedonly_vga

Compile Host On DE1SOC 
	cd to  xxx/de1_soc_opencl/de1_soc_opencl/colorGrayApp
	make

host Usage:
	grayKernel -w960 -h720 
	grayKernel -w640 -h480 -r2 -g1 -b2 -u700 -d200 

### sobel_filter_arm32

do sobel by four mathods : arm , neon , opencl ,opencl with shared memory 

| Mathods              | Frequency |  Time     |
| :--------            |:---------:|:---------:|
| Cortex-A9            |900Mhz     | 168ms     |
| Neon                 | ?         | 37ms      |
| OpenCL Memory Copy   | 130Mhz    | 68ms      |
| OpenCL Shared Memory | 130Mhz    | 14.9ms    |

Compile opencl kernel command:
  aoc device/sobel.cl -o bin/sobel.aocx --board de1soc_sharedonly_vga
Compile Host On DE1SOC 
	cd to  xxx/de1_soc_opencl/sobel_filter_arm32/sobel_filter
	make

## SD card Image file 

You can use the SD card [Image file](http://pan.baidu.com/s/1ge6wJhp) directly without building kernel and OpenCL 16.1 enviroment.


## Linux kernel
If　you want to add more kernel features,you can build your own kernel image.When update kernel,you should recompile the opencl driver and update in SD card.

	git clone https://github.com/thinkoco/linux-socfpga.git
	cd linux-socfpga
	git checkout -b de1soc_opencl origin/de1_soc_opencl
	cp Linux-Config .config
	make zImage
	make socfpga_cyclone5_de1soc.dtb

for buliding aoc_drv.ko diver
	make moudles


## MSEL

MSEL:[4:0] ——> 00010， SW10[4:0] on,on,on,off,on

## Limits
When using desktop, copy your generated top.rbf to fat32 partition and rename to opencl.rbf.
opencl.rbf should match the same host app . Not support fpga hardware dynamic configuration.
