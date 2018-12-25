# How To Do
## Tools install & Environment Setting
### Windows x64

- Quartus Prime Lite 17.1 to 18.1
- Intel FPGA SDK for OpenCL 17.1 to 18.1
- SoC Embedded Design Suite (EDS)

It's easy to use linux commands (arm-linux-guneabihf-gcc,make) in Soc_EDS_command_shell.bat on windows.

### Linux (Ubuntu 16.04)

- Quartus Prime Lite 17.1 to 18.1
- Intel FPGA SDK for OpenCL 17.1 to 18.1
- SoC Embedded Design Suite (EDS)
- arm-linux-gnueabihf-gcc
- arm-linux-gnueabihf-g++
- u-boot-tools

Install tools and set BSP

	sudo apt update
	sudo apt install u-boot-tools gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf libncurses5-dev make lsb uml-utilities git

	git clone https://github.com/thinkoco/c5soc_opencl.git

	cd c5soc_opencl
	cp -rf de1soc_sharedonly_vga ~/intelFPGA/16.1/hld/board/c5soc
	cp -rf de10_nano_sharedonly_hdmi ~/intelFPGA/16.1/hld/board/c5soc
	cp -rf de10_standard_sharedonly_vga ~/intelFPGA/16.1/hld/board/c5soc

for 17.1 or later,change the `ALTERAOCLSDKROOT` to `INTELFPGAOCLSDKROOT`

	cd c5soc_opencl
	sed -i "s/ALTERAOCLSDKROOT/INTELFPGAOCLSDKROOT/g" `grep ALTERAOCLSDKROOT -rl ./de*/`
	cp -rf de1soc_sharedonly_vga ~/intelFPGA_lite/18.0/hld/board/c5soc/hardware
	cp -rf de10_nano_sharedonly_hdmi ~/intelFPGA_lite/18.0/hld/board/c5soc/hardware
	cp -rf de10_standard_sharedonly_vga ~/intelFPGA_lite/18.0/hld/board/c5soc/hardware


modify the ~/intelFPGA/16.1/hld/board/c5soc/board_env.xml file

	form : hardware dir="." default="c5soc"

	to : hardware dir="." default="de1soc_sharedonly_vga"
	
About  environment，write the following to env.sh file and change the paths for your situation. Source it using "**source env.sh**" before compiling .aocx and .rbf.

	#!/bin/bash
	export ARCH=arm
	export CROSS_COMPILE=arm-linux-gnueabihf-
	export LOADADDR=0x8000

	export ALTERAOCLSDKROOT="~/intelFPGA/16.1/hld"
	export QSYS_ROOTDIR="~/intelFPGA/16.1/quartus/sopc_builder/bin"
	export QUARTUS_ROOTDIR="~/intelFPGA/16.1/quartus"

	export PATH="$PATH:${QUARTUS_ROOTDIR}/bin:${QUARTUS_ROOTDIR}/linux64:${QSYS_ROOTDIR}:${ALTERAOCLSDKROOT}/linux64/bin:${ALTERAOCLSDKROOT}/bin"
	export LD_LIBRARY_PATH="${ALTERAOCLSDKROOT}/linux64/lib"
	export AOCL_BOARD_PACKAGE_ROOT="${ALTERAOCLSDKROOT}/board/c5soc"
	export QUARTUS_64BIT=1
	export LM_LICENSE_FILE="~/intelFPGA/license.dat"

for 18.0 lite

	#!/bin/bash
	export INTELFPGAOCLSDKROOT="~/intelFPGA_lite/18.0/hld"
	export QSYS_ROOTDIR="~/intelFPGA_lite/18.0/quartus/sopc_builder/bin"
	export QUARTUS_ROOTDIR_OVERRIDE="~/intelFPGA_lite/18.0/quartus"
	export PATH="$PATH:${QUARTUS_ROOTDIR_OVERRIDE}/bin:${QUARTUS_ROOTDIR_OVERRIDE}/linux64:${INTELFPGAOCLSDKROOT}/linux64/bin:${INTELFPGAOCLSDKROOT}/bin:${QSYS_ROOTDIR}"
	export LD_LIBRARY_PATH="${INTELFPGAOCLSDKROOT}/host/linux64/lib:${AOCL_BOARD_PAKAGE_ROOT}/linux64/lib:${LD_LIBRARY_PATH}"
	export AOCL_BOARD_PACKAGE_ROOT="${INTELFPGAOCLSDKROOT}/board/c5soc"
	export QUARTUS_64BIT=1


## Compile OpenCL Host  and Kernel

### Windows

Compile opencl kernel command on PC:

	aoc device/grayKernel.cl -o bin/grayKernel.aocx --board de1soc_sharedonly_vga -v --report
	aoc device/sobel.cl -o bin/sobel.aocx --board de1soc_sharedonly_vga -v --report
	aoc device/mandelbrot_kernel.cl -o bin/mandelbrot_kernel.aocx  --board de1soc_sharedonly_vga -v --report 
	aoc device/camera_sobel.cl -o bin/camera_sobel.aocx -board=de1soc_sharedonly_vga -v -report

Compile host on DE1SOC:

	make host

### Linux
You can modify the target boards name in the make file for hardware compiling.

Compile opencl kernel command on PC:

	aoc --list-boards
	make fpga

Compile host on DE1SOC:

	make host


## Linux kernel and Driver
If you want to add more kernel features,you can build your own kernel image.When updating kernel,you should recompile the opencl driver and update to SD card.
*for windows, complie kernel image in Soc_EDS_coomand_shell.bat*

	git clone https://github.com/thinkoco/linux-socfpga.git
	cd linux-socfpga
	git checkout -b socfpga-opencl_3.18 origin/socfpga-3.18
	cp config_opencl_de10_nano .config
	
	export ARCH=arm
	export CROSS_COMPILE=arm-linux-gnueabihf-
	export LOADADDR=0x8000

	make zImage
	make socfpga_cyclone5_de1soc.dtb
	make socfpga_cyclone5_de10_nano.dtb
	make socfpga_cyclone5_de10_standard.dtb

for x2go only mode.If you just need x2go only, you should remove the video ip core description in the dts files.

	make socfpga_cyclone5_de1soc_x2go.dtb
	make socfpga_cyclone5_de10_nano_x2go.dtb
	make socfpga_cyclone5_de10_standard_x2go.dtb

Also,you can reduce the VIP driver in kernel and rebuild OpenCL driver(This is an optional step).For rebuliding aoc_drv.ko diver,cd to the dirver folder:

	make KDIR=../(to the linux-socfpga kernel path)

## USB Cameras Driver

- UVC (USB video device class) USB Cameras,for example Logitech C270

	Device Drivers > Multimedia support > Media USB Adapters
	
![](picture/uvc.png)

- USB Cameras supported by gspca driver

	Drivers > Multimedia support > Media USB Adapters > GSPCA based webcams
	
![](picture/gspca.png)

## MSEL
- compression rbf (default generated top.rbf)

	quartus_cpf -c -o bitstream_compression=on top.sof opencl.rbf

	MSEL[4:0] ——> 01010， SW10(**1 to 6**) on,off,on,off,on,N/A

- no compression rbf

	quartus_cpf -c top.sof opencl.rbf

	MSEL[4:0] ——> 01000， SW10(**1 to 6**) on,on,on,off,on,N/A


## How to get rbf  form aocx file

If you lost the rbf file and do not want recompile hardware,you can get it from the aocx file.

	aocl binedit boardtest.aocx list
	aocl binedit boardtest.aocx get .acl.fpga.bin fpga.bin
	aocl binedit fpga.bin get .acl.rbf opencl.rbf


## Intel FPGA SDK for OpenCL license issue on Ubuntu 16.04

**mac address of license must be eth0's mac address**

	sudo apt install lsb uml-utilities

~~sudo tunctl~~                                           # Create the tap0 network interface

~~sudo ip link set dev tap0 name eth0~~                   # Rename the tap0 interface to eth0

~~sudo ifconfig eth0 hw ether xx:xx:xx:xx:xx:xx~~         # Set the MAC address for the eth0 interface

~~sudo ifconfig eth0 up~~                                 # Bring up the eth0 interface

