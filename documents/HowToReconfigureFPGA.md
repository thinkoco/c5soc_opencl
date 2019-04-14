# How to do FPGA reconfiguration with VIP core

**Now,you can download the `c5soc_opencl_lxde_fpga_reconfigurable.img` from the Cloud Drive and write it to SD card.**

## Start desktop 
run following commands in the `serial port terminal`
```
modprobe altvipfb
service lightdm start
export DISPLAY=:0

```

## FPGA reconfiguration
source the `init_opencl_xxxx.sh` file in the serial port terminal

```
service lightdm stop

rmmod -f altvipfb
rmmod cfbfillrect
rmmod cfbimgblt
rmmod cfbcopyarea

aocl program /dev/acl0 yourtarget.aocx
 
modprobe altvipfb
service lightdm start
export DISPLAY=:0
```
the `yourtarget.aocx` is the new aocx file which contains the VIP core.then run opencl host on `desktop terminal`.

