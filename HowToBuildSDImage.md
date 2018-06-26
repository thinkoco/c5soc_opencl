# How to Build SD card Image

## 1. Build opencl.rbf
```
cd ~ 
mkdir sdcard && cd sdcard

echo -e  "__kernel void hello_world(int thread_id_from_which_to_print_message) { \n\tunsigned thread_id = get_global_id(0);\n\tif(thread_id == thread_id_from_which_to_print_message) {\n\t\tprintf(\"Thread #%u: Hello from Altera's OpenCL Compiler! \\\n \", thread_id);\n\t}\n}" > hello_world.cl

aoc hello_world.cl -o hello_world.aocx --board de10_nano_sharedonly_hdmi --report -v
cp hello_world/top.rbf opencl.rbf
```
## 2. Build preloader-mkpimage.bin and u-boot.img
```
~/intelFPGA/17.1/embedded/embedded_command_shell.sh
cd ~/sdcard/hello_world
bsp-editor& 
```
File --> New HPS BSP,set `Preloader settings directory`path to `~/sdcard/hello_world/hps_isw_handoff/system_acl_iface_hps`

![](picture/NewBsp.png)

Then, OK --> Generate --> Exit
[ENTER]

```
cd ~/sdcard/hello_world/software/spl_bsp/
make
cp preloader-mkpimage.bin ~/sdcard/
export CROSS_COMPILE=arm-linux-gnueabihf-
cd uboot-socfpga/
make
cp u-boot.img ~/sdcard/
```
## 3. Build u-boot.scr

```
cd ~/sdcard/
wget https://releases.rocketboards.org/release/2017.10/gsrd/src/boot.script
sed -i 's/soc_system/opencl/g' boot.script
mkimage   -A arm -O linux -T script -C none -a 0 -e 0 -n "My script" -d boot.script u-boot.scr
```
## 4. Build zImage and socfpga.dtb
```
cd ~/sdcard/
cp ~/terasic/linux-socfpga/arch/arm/boot/zImage ./
cp ~/terasic/linux-socfpga/arch/arm/boot/dts/socfpga_cyclone5_de10_nano.dtb  ./socfpga.dtb
```

## 5. Build ubuntu rootfs
```
sudo apt install qemu-user-static
cd ~/sdcard/
wget https://raw.githubusercontent.com/psachin/bash_scripts/master/ch-mount.sh
wget http://cdimage.ubuntu.com/ubuntu-base/releases/18.04/release/ubuntu-base-18.04-base-armhf.tar.gz
chmod +x ch-mount.sh
mkdir rootfs
sudo tar xpf ubuntu-base-18.04-base-armhf.tar.gz -C rootfs/
sudo cp /usr/bin/qemu-arm-static rootfs/usr/bin/
```
Mount proc, sys, dev, dev/pts to new fileystem
```
sudo ./ch-mount.sh -m ./rootfs/
```
Now,in chroot environment

```
# set DNS
echo nameserver 8.8.8.8 > /etc/resolv.conf

# install minimal packages required for X server and some core utils
apt update
apt-get install language-pack-en-base vim sudo ssh net-tools ethtool wireless-tools lxde xfce4-power-manager xinit xorg xserver-xorg-video-fbdev xserver-xorg-input-all network-manager iputils-ping rsyslog lightdm-gtk-greeter alsa-utils mplayer lightdm bash-completion lxtask htop python-gobject-2 python-gtk2 synaptic --no-install-recommends

apt install locales-all tzdata resolvconf  --no-install-recommends

echo "c5soc">/etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "127.0.1.1 c5soc" >> /etc/hosts

# Now add a user of your choice and include him in suitable groups
adduser knat && addgroup knat adm && addgroup knat sudo && addgroup knat audio

# add root password
passwd root

# update DNS automatically,Set ‘timezone’,Make X used by ‘anyuser’
dpkg-reconfigure tzdata
dpkg-reconfigure resolvconf
dpkg-reconfigure x11-common

# modify getty@.service
sed -i 's/^ExecStart=-\/sbin\/agetty.*$/ExecStart=-\/sbin\/agetty --noclear %I $TERM/' /lib/systemd/system/getty@.service

# set lightdm.conf
echo -e "[SeatDefaults]\nautologin-user=root\nautologin-user-timeout=0" > /etc/lightdm/lightdm.conf

# exit chroot environment
exit
```
Now,umount proc, sys, dev, dev/pts 
```
sudo bash ./ch-mount.sh -u rootfs/
```

## 6. Make SD card Image

|Item 			| Description			|
| :---------------------| :-----------------------------|
|opencl.rbf		| FPGA Raw Binary File		|
|preloader-mkpimage.bin | Preloader Image               |
|u-boot.img  		| U-Boot Image 			|
|socfpga.dtb 		| Linux Device Tree Blob 	|
|u-boot.scr  		| U-Boot boot-up script		|
|zImage      		| Compressed Linux kernel Image	|
|rootfs 		| Root filesystem 		|

```
cd ~/sdcard
wget http://releases.rocketboards.org/release/2017.10/gsrd/tools/make_sdimage.py
chmod +x make_sdimage.py
sudo ./make_sdimage.py -f -P preloader-mkpimage.bin,u-boot.img,num=3,format=raw,size=10M,type=A2  -P rootfs/*,num=2,format=ext4,size=1500M  -P zImage,u-boot.scr,opencl.rbf,socfpga.dtb,num=1,format=vfat,size=500M -s 2G -n sdcard_de10_nano.img
```

## 7. Related Links

1. [https://rocketboards.org/foswiki/Documentation/AVGSRDSdCard](https://rocketboards.org/foswiki/Documentation/AVGSRDSdCard)

2. [http://gnu-linux.org/building-ubuntu-rootfs-for-arm.html](http://gnu-linux.org/building-ubuntu-rootfs-for-arm.html)

