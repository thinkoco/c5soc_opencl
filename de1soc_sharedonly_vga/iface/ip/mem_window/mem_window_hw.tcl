package require -exact sopc 10.0

# +-----------------------------------
# | module export_slave
# | 
set_module_property DESCRIPTION "Access a wide memory range through smaller addressable windows."
set_module_property NAME mem_window
set_module_property VERSION 10.0
set_module_property GROUP "ACL Internal Components"
set_module_property AUTHOR "Altera OpenCL"
set_module_property DISPLAY_NAME "ACL Memory Window Bridge"
set_module_property TOP_LEVEL_HDL_FILE mem_window.v
set_module_property TOP_LEVEL_HDL_MODULE mem_window
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file mem_window.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter NUM_BYTES INTEGER 4
set_parameter_property NUM_BYTES DEFAULT_VALUE 4
set_parameter_property NUM_BYTES DISPLAY_NAME "Data Width"
set_parameter_property NUM_BYTES UNITS "bytes"
set_parameter_property NUM_BYTES ALLOWED_RANGES {1 2 4 8 16 32 64 128}
set_parameter_property NUM_BYTES AFFECTS_ELABORATION true
set_parameter_property NUM_BYTES HDL_PARAMETER true

add_parameter DATA_WIDTH INTEGER 32
set_parameter_property DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DATA_WIDTH DISPLAY_NAME "Data Width"
set_parameter_property DATA_WIDTH UNITS "bits"
set_parameter_property DATA_WIDTH HDL_PARAMETER false
set_parameter_property DATA_WIDTH DERIVED true

add_parameter PAGE_ADDRESS_RANGE INTEGER 4
set_parameter_property PAGE_ADDRESS_RANGE DEFAULT_VALUE 4
set_parameter_property PAGE_ADDRESS_RANGE DISPLAY_NAME "Page size"
set_parameter_property PAGE_ADDRESS_RANGE UNITS None
set_parameter_property PAGE_ADDRESS_RANGE ALLOWED_RANGES {1024 512 256 128 64 32 16 8 4 2 1}
set_parameter_property PAGE_ADDRESS_RANGE AFFECTS_ELABORATION true
set_parameter_property PAGE_ADDRESS_RANGE HDL_PARAMETER false

add_parameter PAGE_ADDRESS_RANGE_UNITS string Kbytes
set_parameter_property PAGE_ADDRESS_RANGE_UNITS DEFAULT_VALUE Kbytes
set_parameter_property PAGE_ADDRESS_RANGE_UNITS DISPLAY_NAME "Page size Units"
set_parameter_property PAGE_ADDRESS_RANGE_UNITS UNITS None
set_parameter_property PAGE_ADDRESS_RANGE_UNITS ALLOWED_RANGES {Mbytes Kbytes bytes}
set_parameter_property PAGE_ADDRESS_RANGE_UNITS AFFECTS_ELABORATION true
set_parameter_property PAGE_ADDRESS_RANGE_UNITS HDL_PARAMETER false

add_parameter PAGE_ADDRESS_WIDTH INTEGER 16
set_parameter_property PAGE_ADDRESS_WIDTH DEFAULT_VALUE 16
set_parameter_property PAGE_ADDRESS_WIDTH DISPLAY_NAME "Page (word) address width"
set_parameter_property PAGE_ADDRESS_WIDTH UNITS "bits"
set_parameter_property PAGE_ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property PAGE_ADDRESS_WIDTH DERIVED true

add_parameter PENDING_READS INTEGER 1
set_parameter_property PENDING_READS DEFAULT_VALUE 1
set_parameter_property PENDING_READS DISPLAY_NAME "Max Pending Reads"
set_parameter_property PENDING_READS UNITS None
set_parameter_property PENDING_READS ALLOWED_RANGES 1:256
set_parameter_property PENDING_READS AFFECTS_ELABORATION true
set_parameter_property PENDING_READS HDL_PARAMETER false

add_parameter MEM_ADDRESS_WIDTH INTEGER 32
set_parameter_property MEM_ADDRESS_WIDTH DEFAULT_VALUE 32
set_parameter_property MEM_ADDRESS_WIDTH DISPLAY_NAME "Memory (byte) address width"
set_parameter_property MEM_ADDRESS_WIDTH UNITS "bits"
set_parameter_property MEM_ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property MEM_ADDRESS_WIDTH DERIVED true
set_parameter_property MEM_ADDRESS_WIDTH AFFECTS_ELABORATION true
set_parameter_property MEM_ADDRESS_WIDTH SYSTEM_INFO {ADDRESS_WIDTH m1}

add_parameter NUM_PAGES INTEGER 32
set_parameter_property NUM_PAGES DEFAULT_VALUE 32
set_parameter_property NUM_PAGES DISPLAY_NAME "Number of pages"
set_parameter_property NUM_PAGES UNITS ""
set_parameter_property NUM_PAGES HDL_PARAMETER false
set_parameter_property NUM_PAGES DERIVED true

add_parameter PAGE_ID_WIDTH INTEGER 32
set_parameter_property PAGE_ID_WIDTH DEFAULT_VALUE 32
set_parameter_property PAGE_ID_WIDTH DISPLAY_NAME "Page ID width"
set_parameter_property PAGE_ID_WIDTH UNITS "bits"
set_parameter_property PAGE_ID_WIDTH HDL_PARAMETER false
set_parameter_property PAGE_ID_WIDTH DERIVED true

add_parameter BURSTCOUNT_WIDTH INTEGER 1
set_parameter_property BURSTCOUNT_WIDTH DEFAULT_VALUE 1
set_parameter_property BURSTCOUNT_WIDTH DISPLAY_NAME "Burstcount Width"
set_parameter_property BURSTCOUNT_WIDTH UNITS ""
set_parameter_property BURSTCOUNT_WIDTH ALLOWED_RANGES 1:10
set_parameter_property BURSTCOUNT_WIDTH AFFECTS_ELABORATION true
set_parameter_property BURSTCOUNT_WIDTH HDL_PARAMETER true

add_parameter CRA_BITWIDTH INTEGER 32
set_parameter_property CRA_BITWIDTH DEFAULT_VALUE 32
set_parameter_property CRA_BITWIDTH DISPLAY_NAME "CRA width (bits)"
set_parameter_property CRA_BITWIDTH UNITS "bits"
set_parameter_property CRA_BITWIDTH ALLOWED_RANGES 1:1024
set_parameter_property CRA_BITWIDTH AFFECTS_ELABORATION true
set_parameter_property CRA_BITWIDTH HDL_PARAMETER true

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
# | connection point m1
# | 
add_interface m1 avalon start
set_interface_property m1 associatedClock clk
set_interface_property m1 associatedReset clk_reset
set_interface_property m1 burstOnBurstBoundariesOnly false
set_interface_property m1 doStreamReads false
set_interface_property m1 doStreamWrites false
set_interface_property m1 linewrapBursts false
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point s1
# | 
add_interface s1 avalon end
set_interface_property s1 addressAlignment DYNAMIC
set_interface_property s1 bridgesToMaster ""
set_interface_property s1 associatedClock clk
set_interface_property s1 associatedReset clk_reset
set_interface_property s1 burstOnBurstBoundariesOnly false
set_interface_property s1 explicitAddressSpan 0
set_interface_property s1 holdTime 0
set_interface_property s1 isMemoryDevice false
set_interface_property s1 isNonVolatileStorage false
set_interface_property s1 linewrapBursts false
set_interface_property s1 printableDevice false
set_interface_property s1 readLatency 0
set_interface_property s1 readWaitTime 0
set_interface_property s1 setupTime 0
set_interface_property s1 timingUnits cycles
set_interface_property s1 writeWaitTime 0
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point cra
# | 
add_interface cra avalon end
add_interface_port cra cra_write write input 1
add_interface_port cra cra_writedata writedata input CRA_BITWIDTH
add_interface_port cra cra_byteenable byteenable input CRA_BITWIDTH/8
set_interface_property cra associatedClock clk
set_interface_property cra associatedReset clk_reset
set_interface_property cra readLatency 0
set_interface_property cra timingUnits cycles
set_interface_property cra writeWaitTime 0
set_interface_property cra readWaitTime 0
set_interface_property cra holdTime 0
set_interface_property cra setupTime 0
set_interface_property cra maximumPendingReadTransactions 0
# | 
# +-----------------------------------


proc elaborate {} {
    set num_bytes [ get_parameter_value NUM_BYTES ]
    set pending_reads [ get_parameter_value PENDING_READS ]
    set data_width [ get_parameter_value DATA_WIDTH ]
    set page_address_width [ get_parameter_value PAGE_ADDRESS_WIDTH ]
    set mem_address_width [ get_parameter_value MEM_ADDRESS_WIDTH ]
    set burstcount_width [ get_parameter_value BURSTCOUNT_WIDTH ]

    # +-----------------------------------
    # | connection point m1
    # | 
    add_interface_port m1 m1_read read Output 1
    add_interface_port m1 m1_readdata readdata Input $data_width
    add_interface_port m1 m1_readdatavalid readdatavalid Input 1
    add_interface_port m1 m1_write write Output 1
    add_interface_port m1 m1_writedata writedata Output $data_width
    add_interface_port m1 m1_burstcount burstcount Output $burstcount_width
    add_interface_port m1 m1_byteenable byteenable Output $num_bytes
    add_interface_port m1 m1_address address Output $mem_address_width
    add_interface_port m1 m1_waitrequest waitrequest Input 1
    # | 
    # +-----------------------------------

    # +-----------------------------------
    # | connection point s1
    # | 
    add_interface_port s1 s1_address address Input $page_address_width
    add_interface_port s1 s1_read read Input 1
    add_interface_port s1 s1_readdata readdata Output $data_width
    add_interface_port s1 s1_readdatavalid readdatavalid Output 1
    add_interface_port s1 s1_write write Input 1
    add_interface_port s1 s1_writedata writedata Input $data_width
    add_interface_port s1 s1_burstcount burstcount Input $burstcount_width
    add_interface_port s1 s1_byteenable byteenable Input $num_bytes
    add_interface_port s1 s1_waitrequest waitrequest Output 1

    set_interface_property s1 maximumPendingReadTransactions $pending_reads
    # | 
    # +-----------------------------------
}

proc validate {} {
    set num_bytes [ get_parameter_value NUM_BYTES ]
    set page_address_range [ get_parameter_value PAGE_ADDRESS_RANGE ]
    set page_address_units [ get_parameter_value PAGE_ADDRESS_RANGE_UNITS ]
    set mem_address_width [ get_parameter_value MEM_ADDRESS_WIDTH ]
    set pending_reads [ get_parameter_value PENDING_READS ]

    # Word address vs. byte address
    set byte_address_width [ expr log ($num_bytes) / log(2) ]

    # Page address range
    if { $page_address_units == "Mbytes" } {
        set page_addr_span [ expr $page_address_range * 1048576.0 ]
    } elseif { $page_address_units == "Kbytes" } {
        set page_addr_span [ expr $page_address_range * 1024 ]
    } else {
        set page_addr_span [ expr $page_address_range * 1 ]
    }
    set page_address_width [ expr int (ceil (log ($page_addr_span / $num_bytes) / (log(2)))) ]
    set page_id_width [ expr $mem_address_width - $page_address_width - $byte_address_width ]

    if { ($page_id_width < 0) } {
      send_message error "Memory window must be smaller than global memory size."
    }

    set_parameter_value DATA_WIDTH [ expr $num_bytes * 8 ]
    set_parameter_value PAGE_ADDRESS_WIDTH $page_address_width
    set_parameter_value PAGE_ID_WIDTH $page_id_width
    set_parameter_value NUM_PAGES [ expr pow (2, $page_id_width) ]
}

