package require -exact sopc 10.0

# +-----------------------------------
# | module dma_pcie_bridge
# | 
set_module_property DESCRIPTION "Bridge the width and burst mismatch between PCIe and the DMA"
set_module_property NAME dma_pcie_bridge
set_module_property VERSION 11.0
set_module_property GROUP "ACL Internal Components"
set_module_property AUTHOR "Altera OpenCL"
set_module_property DISPLAY_NAME "ACL DMA to PCIe Bridge"
set_module_property TOP_LEVEL_HDL_FILE dma_pcie_bridge.v
set_module_property TOP_LEVEL_HDL_MODULE dma_pcie_bridge
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file dma_pcie_bridge.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter DMA_WIDTH_BYTES INTEGER 32
set_parameter_property DMA_WIDTH_BYTES DEFAULT_VALUE 32
set_parameter_property DMA_WIDTH_BYTES DISPLAY_NAME "DMA Data Width"
set_parameter_property DMA_WIDTH_BYTES UNITS "bytes"
set_parameter_property DMA_WIDTH_BYTES ALLOWED_RANGES {2 4 8 16 32 64 128}
set_parameter_property DMA_WIDTH_BYTES AFFECTS_ELABORATION true
set_parameter_property DMA_WIDTH_BYTES HDL_PARAMETER false

add_parameter DMA_WIDTH INTEGER 256
set_parameter_property DMA_WIDTH DEFAULT_VALUE 256
set_parameter_property DMA_WIDTH DISPLAY_NAME "DMA Data Width"
set_parameter_property DMA_WIDTH UNITS "bits"
set_parameter_property DMA_WIDTH AFFECTS_ELABORATION true
set_parameter_property DMA_WIDTH HDL_PARAMETER true
set_parameter_property DMA_WIDTH DERIVED true

add_parameter DMA_BURSTCOUNT INTEGER 6
set_parameter_property DMA_BURSTCOUNT DEFAULT_VALUE 6
set_parameter_property DMA_BURSTCOUNT DISPLAY_NAME "DMA Burstcount Width"
set_parameter_property DMA_BURSTCOUNT UNITS None
set_parameter_property DMA_BURSTCOUNT ALLOWED_RANGES 1:16
set_parameter_property DMA_BURSTCOUNT AFFECTS_ELABORATION true
set_parameter_property DMA_BURSTCOUNT HDL_PARAMETER true

add_parameter PCIE_WIDTH_BYTES INTEGER 8
set_parameter_property PCIE_WIDTH_BYTES DEFAULT_VALUE 8
set_parameter_property PCIE_WIDTH_BYTES DISPLAY_NAME "PCIe Data Width"
set_parameter_property PCIE_WIDTH_BYTES UNITS "bytes"
set_parameter_property PCIE_WIDTH_BYTES ALLOWED_RANGES {1 2 4 8 16 32 64 128 256}
set_parameter_property PCIE_WIDTH_BYTES AFFECTS_ELABORATION true
set_parameter_property PCIE_WIDTH_BYTES HDL_PARAMETER false

add_parameter PCIE_WIDTH INTEGER 64
set_parameter_property PCIE_WIDTH DEFAULT_VALUE 64
set_parameter_property PCIE_WIDTH DISPLAY_NAME "PCIe Data Width"
set_parameter_property PCIE_WIDTH UNITS "bits"
set_parameter_property PCIE_WIDTH HDL_PARAMETER true
set_parameter_property PCIE_WIDTH AFFECTS_ELABORATION true
set_parameter_property PCIE_WIDTH DERIVED true

add_parameter PCIE_BURSTCOUNT INTEGER 10
set_parameter_property PCIE_BURSTCOUNT DEFAULT_VALUE 10
set_parameter_property PCIE_BURSTCOUNT DISPLAY_NAME "PCIe Burstcount Width"
set_parameter_property PCIE_BURSTCOUNT UNITS None
set_parameter_property PCIE_BURSTCOUNT ALLOWED_RANGES 1:16
set_parameter_property PCIE_BURSTCOUNT AFFECTS_ELABORATION true
set_parameter_property PCIE_BURSTCOUNT HDL_PARAMETER true

add_parameter PCIE_ADDRESS_RANGE INTEGER 4
set_parameter_property PCIE_ADDRESS_RANGE DEFAULT_VALUE 4
set_parameter_property PCIE_ADDRESS_RANGE DISPLAY_NAME "PCIe Addressable Range"
set_parameter_property PCIE_ADDRESS_RANGE UNITS None
set_parameter_property PCIE_ADDRESS_RANGE ALLOWED_RANGES {1024 512 256 128 64 32 16 8 4 2 1}
set_parameter_property PCIE_ADDRESS_RANGE AFFECTS_ELABORATION true
set_parameter_property PCIE_ADDRESS_RANGE HDL_PARAMETER false

add_parameter PCIE_ADDRESS_RANGE_UNITS string Kbytes
set_parameter_property PCIE_ADDRESS_RANGE_UNITS DEFAULT_VALUE Kbytes
set_parameter_property PCIE_ADDRESS_RANGE_UNITS DISPLAY_NAME "PCIe Addressable Range Units"
set_parameter_property PCIE_ADDRESS_RANGE_UNITS UNITS None
set_parameter_property PCIE_ADDRESS_RANGE_UNITS ALLOWED_RANGES {Mbytes Kbytes bytes}
set_parameter_property PCIE_ADDRESS_RANGE_UNITS AFFECTS_ELABORATION true
set_parameter_property PCIE_ADDRESS_RANGE_UNITS HDL_PARAMETER false

add_parameter PCIE_ADDR_WIDTH INTEGER 32
set_parameter_property PCIE_ADDR_WIDTH DEFAULT_VALUE 32
set_parameter_property PCIE_ADDR_WIDTH DISPLAY_NAME "Memory (byte) address width"
set_parameter_property PCIE_ADDR_WIDTH UNITS "bits"
set_parameter_property PCIE_ADDR_WIDTH HDL_PARAMETER true
set_parameter_property PCIE_ADDR_WIDTH AFFECTS_ELABORATION true
set_parameter_property PCIE_ADDR_WIDTH DERIVED true

add_parameter PENDING_READS INTEGER 64
set_parameter_property PENDING_READS DEFAULT_VALUE 64
set_parameter_property PENDING_READS DISPLAY_NAME "Max Pending Reads"
set_parameter_property PENDING_READS UNITS None
set_parameter_property PENDING_READS ALLOWED_RANGES 1:256
set_parameter_property PENDING_READS AFFECTS_ELABORATION true
set_parameter_property PENDING_READS HDL_PARAMETER false

add_parameter ADDR_OFFSET INTEGER 0
set_parameter_property ADDR_OFFSET DEFAULT_VALUE 0
set_parameter_property ADDR_OFFSET VISIBLE false
set_parameter_property ADDR_OFFSET AFFECTS_ELABORATION true
set_parameter_property ADDR_OFFSET HDL_PARAMETER true
set_parameter_property ADDR_OFFSET DERIVED true

add_parameter PCIE_ADDR_MAP STRING
set_parameter_property PCIE_ADDR_MAP VISIBLE false
set_parameter_property PCIE_ADDR_MAP AFFECTS_ELABORATION true
set_parameter_property PCIE_ADDR_MAP SYSTEM_INFO {ADDRESS_MAP pcie}
set_parameter_property PCIE_ADDR_MAP HDL_PARAMETER false
# | 
# +-----------------------------------

# +-----------------------------------
# | display items
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk
# | 
add_interface clk clock end
set_interface_property clk ENABLED true
add_interface_port clk clk clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk_reset
# | 
add_interface clk_reset reset end
set_interface_property clk_reset associatedClock clk
set_interface_property clk_reset synchronousEdges DEASSERT
set_interface_property clk_reset ENABLED true
add_interface_port clk_reset reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point pcie
# | 
add_interface pcie avalon start
set_interface_property pcie associatedClock clk
set_interface_property pcie associatedReset clk_reset
set_interface_property pcie burstOnBurstBoundariesOnly false
set_interface_property pcie doStreamReads false
set_interface_property pcie doStreamWrites false
set_interface_property pcie linewrapBursts false
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point dma
# | 
add_interface dma avalon end
set_interface_property dma addressAlignment DYNAMIC
set_interface_property dma associatedClock clk
set_interface_property dma associatedReset clk_reset
set_interface_property dma burstOnBurstBoundariesOnly false
set_interface_property dma explicitAddressSpan 0
set_interface_property dma holdTime 0
set_interface_property dma isMemoryDevice false
set_interface_property dma isNonVolatileStorage false
set_interface_property dma linewrapBursts false
set_interface_property dma printableDevice false
set_interface_property dma readLatency 0
set_interface_property dma readWaitTime 0
set_interface_property dma setupTime 0
set_interface_property dma timingUnits cycles
set_interface_property dma writeWaitTime 0
# | 
# +-----------------------------------

proc elaborate {} {
    set dma_bytes [ get_parameter_value DMA_WIDTH_BYTES ]
    set dma_width [ get_parameter_value DMA_WIDTH ]
    set dma_burstcount [ get_parameter_value DMA_BURSTCOUNT ]
    set pcie_bytes [ get_parameter_value PCIE_WIDTH_BYTES ]
    set pcie_width [ get_parameter_value PCIE_WIDTH ]
    set pcie_burstcount [ get_parameter_value PCIE_BURSTCOUNT ]
    set pcie_address_range [ get_parameter_value PCIE_ADDRESS_RANGE ]
    set pcie_address_range_units [ get_parameter_value PCIE_ADDRESS_RANGE_UNITS ]
    set pcie_address_width [ get_parameter_value PCIE_ADDR_WIDTH ]
    set pending_reads [ get_parameter_value PENDING_READS ]

    set word_shift [ expr int ( log ($dma_bytes) / log(2) ) ]
    set dma_address_width [ expr $pcie_address_width - $word_shift ]

    # +-----------------------------------
    # | connection point pcie
    # | 
    add_interface_port pcie pcie_read read Output 1
    add_interface_port pcie pcie_readdata readdata Input $pcie_width
    add_interface_port pcie pcie_readdatavalid readdatavalid Input 1
    add_interface_port pcie pcie_write write Output 1
    add_interface_port pcie pcie_writedata writedata Output $pcie_width
    add_interface_port pcie pcie_burstcount burstcount Output $pcie_burstcount
    add_interface_port pcie pcie_byteenable byteenable Output $pcie_bytes
    add_interface_port pcie pcie_address address Output 32
    add_interface_port pcie pcie_waitrequest waitrequest Input 1
    # | 
    # +-----------------------------------

    # +-----------------------------------
    # | connection point dma
    # | 
    add_interface_port dma dma_address address Input $dma_address_width
    add_interface_port dma dma_read read Input 1
    add_interface_port dma dma_readdata readdata Output $dma_width
    add_interface_port dma dma_readdatavalid readdatavalid Output 1
    add_interface_port dma dma_write write Input 1
    add_interface_port dma dma_writedata writedata Input $dma_width
    add_interface_port dma dma_burstcount burstcount Input $dma_burstcount
    add_interface_port dma dma_byteenable byteenable Input $dma_bytes
    add_interface_port dma dma_waitrequest waitrequest Output 1

    set_interface_property dma maximumPendingReadTransactions $pending_reads
    # | 
    # +-----------------------------------
}

proc validate {} {
    set dma_bytes [ get_parameter_value DMA_WIDTH_BYTES ]
    set dma_burstcount [ get_parameter_value DMA_BURSTCOUNT ]
    set pcie_bytes [ get_parameter_value PCIE_WIDTH_BYTES ]
    set pcie_burstcount [ get_parameter_value PCIE_BURSTCOUNT ]
    set pcie_address_range [ get_parameter_value PCIE_ADDRESS_RANGE ]
    set pcie_address_range_units [ get_parameter_value PCIE_ADDRESS_RANGE_UNITS ]

    set dma_width [ expr 8 * $dma_bytes ]
    set pcie_width [ expr 8 * $pcie_bytes ]
    set width_ratio [ expr $dma_width / $pcie_width ]
    set addr_shift [ expr int ( log ($width_ratio) / log(2) ) ]

    # Memory address range
    if { $pcie_address_range_units == "Mbytes" } {
        set pcie_addr_span [ expr $pcie_address_range * 1048576 ]
    } elseif { $pcie_address_range_units == "Kbytes" } {
        set pcie_addr_span [ expr $pcie_address_range * 1024 ]
    } else {
        set pcie_addr_span [ expr $pcie_address_range * 1 ]
    }
    set pcie_address_width [ expr int (ceil (log ($pcie_addr_span) / (log(2)))) ]

    if { ($dma_width <= $pcie_width) } {
      send_message error "DMA width must be less than PCIe width"
    }
    if { ($dma_burstcount + $addr_shift > $pcie_burstcount) } {
      send_message error "PCIe burstcount must be able to handle a full DMA burst."
    }

    # Compute the offset to downstream slave components
    set amap_xml [ get_parameter_value PCIE_ADDR_MAP ]
    set amap_dec [ decode_address_map $amap_xml ]
    set offset 0
    set first 1
    foreach i $amap_dec {
      array set info $i
      if { ([ expr $info(start) ] < $offset) || ($first == 1) } {
         set offset [ expr $info(start) ]
         set first 0
      }
    }
    set hex_offset [format %x $offset]
    send_message info "DMA-PCIe Bridge Offset: 0x$hex_offset"

    set_parameter_value ADDR_OFFSET $offset
    set_parameter_value DMA_WIDTH $dma_width
    set_parameter_value PCIE_WIDTH $pcie_width
    set_parameter_value PCIE_ADDR_WIDTH $pcie_address_width
}

