package require -exact qsys 13.0

# module properties
set_module_property NAME {acl_memory_bank_divider}
set_module_property DISPLAY_NAME {ACL Memory Bank Divider}

# default module properties
set_module_property VERSION {1.0}
set_module_property GROUP {ACL BSP Components}
set_module_property DESCRIPTION {default description}
set_module_property AUTHOR {author}
set_module_property ANALYZE_HDL false

# Set the name of the procedure to manipulate parameters
set_module_property COMPOSITION_CALLBACK compose

# +-----------------------------------
# | parameters
# | 
add_parameter NUM_BANKS INTEGER 2
set_parameter_property NUM_BANKS DEFAULT_VALUE 2
set_parameter_property NUM_BANKS ALLOWED_RANGES {1 2 4 8}
set_parameter_property NUM_BANKS DISPLAY_NAME "Number of banks"
set_parameter_property NUM_BANKS AFFECTS_ELABORATION true

add_parameter DATA_WIDTH INTEGER 256
set_parameter_property DATA_WIDTH DEFAULT_VALUE 256
set_parameter_property DATA_WIDTH DISPLAY_NAME "Data Width"
set_parameter_property DATA_WIDTH UNITS "bits" 
set_parameter_property DATA_WIDTH AFFECTS_ELABORATION true
#set_parameter_property DATA_WIDTH SYSTEM_INFO {MAX_SLAVE_DATA_WIDTH bank1}

add_parameter ADDRESS_WIDTH INTEGER 31
set_parameter_property ADDRESS_WIDTH DEFAULT_VALUE 31
set_parameter_property ADDRESS_WIDTH DISPLAY_NAME "Address Width (total addressable)"
set_parameter_property ADDRESS_WIDTH UNITS "bits"
set_parameter_property ADDRESS_WIDTH AFFECTS_ELABORATION true
#set_parameter_property ADDRESS_WIDTH SYSTEM_INFO {ADDRESS_WIDTH bank1}

add_parameter BURST_SIZE INTEGER 16
set_parameter_property BURST_SIZE DEFAULT_VALUE 16
set_parameter_property BURST_SIZE DISPLAY_NAME "Burst size (maximum)"
set_parameter_property BURST_SIZE UNITS ""
set_parameter_property BURST_SIZE AFFECTS_ELABORATION true

add_parameter MAX_PENDING_READS INTEGER 64
set_parameter_property MAX_PENDING_READS DEFAULT_VALUE 64
set_parameter_property MAX_PENDING_READS DISPLAY_NAME "Maximum Pending Reads"
set_parameter_property MAX_PENDING_READS UNITS ""
set_parameter_property MAX_PENDING_READS AFFECTS_ELABORATION true
# | 
# +-----------------------------------

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance clk clock_source 13.1
set_instance_parameter_value clk clockFrequency {100000000.0}
set_instance_parameter_value clk clockFrequencyKnown {1}
set_instance_parameter_value clk resetSynchronousEdges {DEASSERT}

add_instance acl_snoop_adapter_0 acl_snoop_adapter 11.0

add_instance kernel_clk clock_source 13.1
set_instance_parameter_value kernel_clk clockFrequency {100000000.0}
set_instance_parameter_value kernel_clk clockFrequencyKnown {1}
set_instance_parameter_value kernel_clk resetSynchronousEdges {NONE}

add_connection kernel_clk.clk acl_snoop_adapter_0.kernel_clk

add_connection kernel_clk.clk_reset acl_snoop_adapter_0.kernel_reset

add_connection clk.clk_reset acl_snoop_adapter_0.clk_reset

add_connection clk.clk acl_snoop_adapter_0.clk

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF clk.clk_in
add_interface reset reset sink
set_interface_property reset EXPORT_OF clk.clk_in_reset
add_interface kernel_clk clock sink
set_interface_property kernel_clk EXPORT_OF kernel_clk.clk_in
add_interface kernel_reset reset sink
set_interface_property kernel_reset EXPORT_OF kernel_clk.clk_in_reset
add_interface s avalon slave
set_interface_property s EXPORT_OF acl_snoop_adapter_0.s1
add_interface acl_bsp_snoop avalon_streaming source
set_interface_property acl_bsp_snoop EXPORT_OF acl_snoop_adapter_0.snoop


proc compose {} {
  # manipulate parameters in here
  set width [get_parameter_value DATA_WIDTH]
  set pending_reads [get_parameter_value MAX_PENDING_READS]
  set num_banks [ get_parameter_value NUM_BANKS]
  set log2_num_banks [ expr log($num_banks) / log(2) ]
  set log2_bank_byte_width [ expr log([get_parameter_value DATA_WIDTH]) / log(2) - 3 ]
  set aggr_awidth [ get_parameter_value ADDRESS_WIDTH ]
  set bank_awidth [expr $aggr_awidth - $log2_num_banks ]
  set burst_size [get_parameter_value BURST_SIZE]
  set burst_width [ expr int(log($burst_size)/log(2)) + 1]

  set_instance_parameter_value acl_snoop_adapter_0 BYTE_ADDRESS_WIDTH $aggr_awidth
  set_instance_parameter_value acl_snoop_adapter_0 BURSTCOUNT_WIDTH $burst_width
  set_instance_parameter_value acl_snoop_adapter_0 NUM_BYTES [expr $width / 8]
  set_instance_parameter_value acl_snoop_adapter_0 PENDING_READS $pending_reads

  if { $num_banks > 1 }  {
    add_instance mem_splitter_0 mem_splitter 10.0
    set_instance_parameter_value mem_splitter_0 NUM_BANKS $num_banks
    set_instance_parameter_value mem_splitter_0 WIDTH_D $width
    set_instance_parameter_value mem_splitter_0 M_WIDTH_A $bank_awidth
    set_instance_parameter_value mem_splitter_0 BURSTCOUNT_WIDTH $burst_width
    set_instance_parameter_value mem_splitter_0 MAX_PENDING_READS $pending_reads

    add_instance pipe_stage_presplitter altera_avalon_mm_bridge 13.1
    set_instance_parameter_value pipe_stage_presplitter SYMBOL_WIDTH {8}
    set_instance_parameter_value pipe_stage_presplitter ADDRESS_UNITS {SYMBOLS}
    set_instance_parameter_value pipe_stage_presplitter LINEWRAPBURSTS {0}
    set_instance_parameter_value pipe_stage_presplitter PIPELINE_COMMAND {1}
    set_instance_parameter_value pipe_stage_presplitter PIPELINE_RESPONSE {1}

    set_instance_parameter_value pipe_stage_presplitter DATA_WIDTH $width
    set_instance_parameter_value pipe_stage_presplitter MAX_BURST_SIZE $burst_size
    set_instance_parameter_value pipe_stage_presplitter ADDRESS_WIDTH $aggr_awidth
    set_instance_parameter_value pipe_stage_presplitter MAX_PENDING_RESPONSES $pending_reads

    # connections and connection parameters
    add_connection acl_snoop_adapter_0.m1 pipe_stage_presplitter.s0
    set_connection_parameter_value acl_snoop_adapter_0.m1/pipe_stage_presplitter.s0 arbitrationPriority {1}
    set_connection_parameter_value acl_snoop_adapter_0.m1/pipe_stage_presplitter.s0 baseAddress {0x0000}

    add_connection pipe_stage_presplitter.m0 mem_splitter_0.s
    set_connection_parameter_value pipe_stage_presplitter.m0/mem_splitter_0.s arbitrationPriority {1}
    set_connection_parameter_value pipe_stage_presplitter.m0/mem_splitter_0.s baseAddress {0x0000}

    add_connection clk.clk pipe_stage_presplitter.clk

    add_connection clk.clk mem_splitter_0.clk

    add_connection clk.clk_reset mem_splitter_0.clk_reset

    add_connection clk.clk_reset pipe_stage_presplitter.reset

    add_interface acl_bsp_memorg_host conduit end
    set_interface_property acl_bsp_memorg_host EXPORT_OF mem_splitter_0.mode
    add_interface bank1 avalon master
    set_interface_property bank1 EXPORT_OF mem_splitter_0.bank1
    
    if { $num_banks >= 2 } {
      add_interface bank2 avalon master
      set_interface_property bank2 EXPORT_OF mem_splitter_0.bank2
    }
    
    if { $num_banks >= 3 } {
      add_interface bank3 avalon master
      set_interface_property bank3 EXPORT_OF mem_splitter_0.bank3
    }
    
    if { $num_banks >= 4 } {
      add_interface bank4 avalon master
      set_interface_property bank4 EXPORT_OF mem_splitter_0.bank4
    }
    
    if { $num_banks >= 5 } {
      add_interface bank5 avalon master
      set_interface_property bank5 EXPORT_OF mem_splitter_0.bank5
    }
    
    if { $num_banks >= 6 } {
      add_interface bank6 avalon master
      set_interface_property bank6 EXPORT_OF mem_splitter_0.bank6
    }
    
    if { $num_banks >= 7 } {
      add_interface bank7 avalon master
      set_interface_property bank7 EXPORT_OF mem_splitter_0.bank7
    }
    
    if { $num_banks >= 8 } {
      add_interface bank8 avalon master
      set_interface_property bank8 EXPORT_OF mem_splitter_0.bank8
    }

  } else { 
    # NUM_BANKS == 1
    add_interface bank1 avalon start
    set_interface_property bank1 EXPORT_OF acl_snoop_adapter_0.m1 
  }

                                                                                }
