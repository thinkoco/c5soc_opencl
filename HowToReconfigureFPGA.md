# How to do FPGA reconfiguration with VIP core

**Now,you can download the `c5soc_opencl_lxde_fpga_reconfigurable.img` from the Cloud Drive and write it to SD card. Then, you can run it directly without updating `fpga_reconfigurable_with_VIP` files**

## FPGA reconfigurable files
 you can get the `fpga_reconfigurable_with_VIP` folder in [Baidu Cloud Link](https://pan.baidu.com/s/1KDyexwHD39uyvcMDm0G97A) or [Google Drive Link](https://drive.google.com/open?id=1mAYHFvOw2xtgf-e8pntFCxCGOdaYNsgG)


1. write the c5soc_opencl_lxde_all_in_one_180317.img to sd card 
2. mount the sd card on ubuntu
3. run update_files_cmd.sh in fpga_reconfigurable_with_VIP folder

```
cd fpga_reconfigurable_with_VIP
./update_files_cmd.sh
```

| file or folder             | copy into     | description     |
| :--------                  |:---------     |:---------                 |
| 3.18.0-00265-gc61e1803c309 | /lib/modules  | vip driver                |
| aclsoc_drv                 | /root         | opencl driver             |
| init_opencl_16.1.sh        | /root         | 16.1 environment          |
| init_opencl_17.1.sh        | /root         | 17.1 environment          |
| zImage                     | FAT Partition | zImage without VIP driver |

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

