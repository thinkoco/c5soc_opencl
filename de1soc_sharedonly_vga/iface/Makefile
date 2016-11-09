ACL_SRC_ROOT=../../../../..
include $(ACL_SRC_ROOT)/bcommon/environ.mk
include $(ACL_SRC_ROOT)/bcommon/common.mk


.PRECIOUS : %.v %.sopc %.sdc %.qip %.qsys

# These files do not get removed when we clean
SOURCE_FILES=Makefile ip \
             acl_bsp_bridge.qsys \
             acl_dma.qsys \
             acl_dma_core.qsys \
             acl_hostmem_splitter.qsys \
             acl_iface_system.qsys \
             acl_kernel_clk.qsys \
             acl_kernel_interface.qsys \
             acl_iface_system_1600.qsys

# Install files
IFACE_IP_WILDCARDS += *.vo *.v *.qip *.sdc *_hw.tcl
IFACE_IP_DIRS += acl_iface_system ip
IFACE_IP_EXTRA_FILES +=
IFACE_IP_FILES += $(foreach W,$(IFACE_IP_WILDCARDS),$(wildcard $W))
IFACE_IP_FILES += $(foreach D,$(IFACE_IP_DIRS),$(shell $(FIND) $D -type f))


# Targets
.PHONY: test all clean distclean install

test : all
distclean :

all : 
	$(MAKE) install

%/.dir :
	mkdir -p $(dir $@)
	touch $@

clean : distclean
	#rm -rf $(filter-out $(SOURCE_FILES),$(wildcard *))
