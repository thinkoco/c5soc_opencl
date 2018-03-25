#set source and target for host
TARGET_DIR := bin
HOST_EXE  = camera_sobel.run
HOST_DIRS = host/src ../common/src/AOCLUtils
HOST_SRCS := $(wildcard  $(foreach D, $(HOST_DIRS), $D/*.cpp))
HOST_OBJS = $(HOST_SRCS:%.cpp=%.o)
HOST_INCS = host/inc ../common/inc /usr/include/SDL2
HOST_LIBS := SDL2
HOST_DEBUG =

#if you are loading images from OpenCV interfaces please set to 1
USE_OPENCV = 0

#set source and target for device
#supported vendors are altera
VENDOR = altera
#select the host archecture  x86|arm32
PLATFORM = arm32
#optinal flows are hw|sw_emu
FLOW        = hw
# Boards de1soc_sharedonly_vga | de10_nano_sharedonly_hdmi 
KERNEL_BOARD := de10_nano_sharedonly_hdmi
KERNEL_SRCS = ./device/camera_sobel.cl
KERNEL_NAME = camera_sobel
KERNEL_DEFS =
KERNEL_INCS =
KERNEL_PROFILE = 0
KERNEL_DEBUG = 1
DEV_EXE = $(KERNEL_NAME).aocx


#host compiler options
CROSS-COMPILE = arm-linux-gnueabihf-

ifeq ($(PLATFORM),x86)
CXX := g++
ifeq ($(USE_OPENCV),1)
#add your OpenCV PATH here
OCV_INCLUDES = -I/usr/local/include/
OCV_LIBDIRS = -L/usr/local/lib 
OCV_LIBS =  -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_ml
endif
else ifeq ($(PLATFORM),arm32)
CXX := $(CROSS-COMPILE)g++
ifeq ($(USE_OPENCV),1)
#add your cross compile OpenCV PATH here
OCV_INCLUDES = -I/usr/local/opencv-arm/include/
OCV_LIBDIRS = -L/usr/local/opencv-arm/lib 
OCV_LIBS =  -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_ml
endif
endif

#select whether use OpenCV or not
ifeq ($(USE_OPENCV),1)
CXXFLAGS = -Wall -std=c++11 -DUSE_OPENCV
else
CXXFLAGS = -Wall -std=c++11
endif

# Compilation flags
ifeq ($(HOST_DEBUG),1)
CXXFLAGS += -g
else
CXXFLAGS += -O2
endif


#select whether manually launch free-run kernels
ifeq ($(FLOW),sw_emu)
CXXFLAGS += -DSW_EMU
endif

ifeq ($(VENDOR),altera)
ifeq ($(PLATFORM),x86)
COMP_CONFIG = $(shell aocl compile-config)   $(foreach D, $(HOST_INCS), -I$D) -DFPGA_DEVICE
LINK_CONFIG = $(shell aocl link-config)  $(foreach L, $(HOST_LIBS), -l$L)
else ifeq ($(PLATFORM),arm32)
COMP_CONFIG = $(shell aocl compile-config --arm) $(foreach D, $(HOST_INCS), -I$(D))  -DFPGA_DEVICE
LINK_CONFIG = $(shell aocl link-config --arm) $(foreach L, $(HOST_LIBS), -l$L)
endif
endif

#opencl compiler options
#altera
ifeq ($(VENDOR),altera)
OCC = aoc
ifeq ($(FLOW),sw_emu)
OCCFLAGS = $(foreach K, $(KERNEL_BOARD), --board $K) -v --report -march=emulator   
else ifeq ($(FLOW),hw)
OCCFLAGS = $(foreach K, $(KERNEL_BOARD), --board $K) -v --report
endif
endif

#debug option
ifeq ($(KERNEL_DEBUG),1)
	OCCFLAGS += -g
endif

#profile option
ifeq ($(KERNEL_PROFILE),1)
	OCCFLAGS += --profile
endif


.PHONY: host
host: $(TARGET_DIR) $(HOST_EXE)

.PHONY: fpga
fpga: $(TARGET_DIR) $(DEV_EXE)

$(TARGET_DIR) :
	$(ECHO)mkdir $(TARGET_DIR)

$(HOST_EXE): $(HOST_OBJS)
	$(CXX) $(OCV_LIBDIRS) $(OCV_INCLUDES) $(HOST_OBJS) -o $(TARGET_DIR)/$@ $(LINK_CONFIG) $(OCV_LIBS)
	
%.o: %.cpp
	$(CXX) $(OCV_LIBDIRS) $(OCV_INCLUDES) $(CXXFLAGS) -c $< -o $@ $(COMP_CONFIG) $(OCV_LIBS)

$(DEV_EXE): $(KERNEL_SRCS)
	$(OCC) $(OCCFLAGS) $< -o $(TARGET_DIR)/$@

.PHONY: clean
clean:
	rm -rf $(foreach D,$(HOST_DIRS),$D/*.o)
