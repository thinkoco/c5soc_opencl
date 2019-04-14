# How to update OpenCL Driver
Once updating the zImage,you should rebuild the OpenCL driver and update it to SD card.

- Firstly,get the `Intel FPGA Runtime Environment for OpenCL Linux Cyclone V SoC TGZ` on [Altera Download Website](https://fpgasoftware.intel.com).

- Secondly,make zImage

```
git clone https://github.com/thinkoco/linux-socfpga.git
cd linux-socfpga
git checkout -b socfpga-opencl_3.18 origin/socfpga-3.18
cp config_opencl .config
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export LOADADDR=0x8000

make zImage
make modules
```

- Thirdly,indicate the KDIR when compiling the OpenCL driver.

```
cd PATHto/aocl-rte-16.1.0-1.arm32/board/c5soc/driver
cd PATHto/aocl-rte-17.1.0-590.arm32/board/c5soc/arm32/driver
make KDIR=PATHto/linux-socfpga
```
in my case,
```
cd ~/terasic/aocl-rte-17.1.0-590.arm32/board/c5soc/arm32/driver
make KDIR=~/terasic/linux-socfpga
```

- Finally,update the zImage and aclsoc\_drv.ko to sd card.Also,you may need to update the insmod path in `init_opencl_17.1.sh`,such as `insmod /root/aclsoc_drv/17.1/aclsoc_drv.ko`
