BOARD:=de1soc
BOARD_VARIANT:=de1soc_sharedonly
EXTRA_FILES=quartus.ini
EXTRA_ALL_TARGETS+=ipx

include ../../common/hardware/Makefile.common

SUB_TARGETS=clean distclean all test

.PHONY: $(SUB_TARGETS) ipx

ipx :
	$(MAKE_IPX_COMMAND) --source-directory="iface,iface/ip" --output=c5iface.ipx
	$(MAKE_IPX_COMMAND) --source-directory="$(ALTERAOCLSDKROOT)/ip/board" --output=iface.ipx  --relative-vars=ALTERAOCLSDKROOT

