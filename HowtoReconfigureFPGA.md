# How to do FPGA reconfiguration with VIP core
## FPGA reconfigurable sd card image
[Baidu Cloud Link](https://pan.baidu.com/s/1KDyexwHD39uyvcMDm0G97A) or [Google Drive Link](https://drive.google.com/open?id=1mAYHFvOw2xtgf-e8pntFCxCGOdaYNsgG)

## Start desktop 
run following commands in the serial port terminal
```
modprobe altvipfb
service lightdm start
export DISPLAY=:0

```
then, source the `init_opencl_16.1.sh` or `init_opencl_17.1.sh` file and run opencl host in the serial port terminal

## FPGA reconfiguration
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
the `yourtarget.aocx` is the new aocx file which contains the VIP core.

