# How to Run x2go

## About x2go

X2Go enables you to access a graphical desktop of a computer over a low bandwidth (or high bandwidth) connection.
In x2go only mode,if using terasic's hardware templates which includes no vedio ip core to build the OpenCL aocx file,you can get more fpga resouce for OpenCL.

![](picture/x2go.png)

## Install x2go server in sd card
To install add-apt-repository on Ubuntu
```
sudo apt-get install software-properties-common
```
Once add-apt-repository is installed, run these commands
```
sudo add-apt-repository ppa:x2go/stable
sudo apt-get update
sudo apt-get install x2goserver x2goserver-xsession
```
LXDE bindings
```
sudo apt-get all x2golxdebindings
```

## Install the x2goclient on PC
For Ubuntu
```
sudo apt-add-repository ppa:x2go/stable
sudo apt-get update
sudo apt-get install x2goclient
```
For Windows
```
https://code.x2go.org/releases/binary-win32/x2goclient/releases/4.1.1.1-2018.03.01/x2goclient-4.1.1.1-2018.03.01-setup.exe
```

## x2go login 
1. check the host IP on board.
2. login user: knat password: knat. 
3. using "sudo su" to get root privileges

![](picture/x2go_login.png)


 
## Differences between VIP Core and X2GO only
In x2go only mode,there is no vip logic in rbf(aocx) and vip driver will not be loading.

| Item                |   VGA or HDMI (VIP Core)                       |      X2GO only (Ethernet)                   |
| :--------            |:--------------------------                    |:-----------------------                     |
| Hardware template    | de10_nano_sharedonly_hdmi                     | de10_nano_sharedonly  (form terasic)        |
| opencl.rbf           | contain VIP core                              | no VIP Core                                 |
| socfpga.dtb          | contain VIP core description                  | no VIP core description                     |
| init_opencl_16.1.sh  | add CL_CONTEXT_COMPILER_MODE_ALTERA=3         | delete CL_CONTEXT_COMPILER_MODE_ALTERA=3    |
| init_opencl_17.1.sh  | add CL_CONTEXT_COMPILER_MODE_INTELFPGA=3      | delete CL_CONTEXT_COMPILER_MODE_INTELFPGA=3 |
| host reprogram fpga  | manual (by aocl program [look here](HowToReconfigureFPGA.md)) | enable                  |

## how to do x2go only

1. get terasic's hardware templates,such as `de10_nano_sharedonly`,which includes no vedio ip core to build the OpenCL aocx file and rbf file. 

2. update the device tree block file with the one which contains no vedio ip core descriptoin,such as `socfpga_cyclone5_de10_nano_x2go.dtb`.

3. delete the CL_CONTEXT_COMPILER_MODE_xxx flag in initial shell file.

4. install x2go server in sd card

5. add '#' as following in rc.local to disable loading the altvipfb driver .(for c5soc_opencl_lxde_fpga_reconfigurable.img)

```
#modprobe altvipfb
#service lightdm start
```

