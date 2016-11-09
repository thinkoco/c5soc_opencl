BOARD:=c5soc
BOARD_VARIANT:=c5soc_sharedonly
EXTRA_FILES=quartus.ini
EXTRA_ALL_TARGETS+=ipx

include ../../common/hardware/Makefile.common

SUB_TARGETS=clean distclean all test

.PHONY: $(SUB_TARGETS) ipx

ipx :
	$(MAKE_IPX_COMMAND) --source-directory="iface,iface/ip" --output=iface.ipx

