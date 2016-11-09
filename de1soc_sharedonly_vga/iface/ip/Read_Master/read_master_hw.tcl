package require -exact sopc 9.1

# +-----------------------------------
# | module Read_Master
# | 
set_module_property DESCRIPTION "A module responsible for streaming data from memory"
set_module_property NAME dma_read_master
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property GROUP "Modular_DMA"
set_module_property AUTHOR JCJB
set_module_property DISPLAY_NAME "Read Master"
set_module_property TOP_LEVEL_HDL_FILE read_master.v
set_module_property TOP_LEVEL_HDL_MODULE read_master
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property DATASHEET_URL "file:/[get_module_property MODULE_DIRECTORY]Modular_SGDMA_Read_Master_Core_UG.pdf"
set_module_property "simulationModelInVHDL" "true"
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file read_master.v {SYNTHESIS SIMULATION}
add_file MM_to_ST_Adapter.v {SYNTHESIS SIMULATION}
add_file read_burst_control.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------


set_module_property ELABORATION_CALLBACK    elaborate_me
set_module_property VALIDATION_CALLBACK     validate_me



# +-----------------------------------
# | parameters
# |
add_parameter DATA_WIDTH INTEGER 32 "Width of the streaming and memory mapped data path."
set_parameter_property DATA_WIDTH ALLOWED_RANGES {8 16 32 64 128 256 512 1024}
set_parameter_property DATA_WIDTH DISPLAY_NAME "Data Width"
set_parameter_property DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property DATA_WIDTH DERIVED false
set_parameter_property DATA_WIDTH HDL_PARAMETER true
set_parameter_property DATA_WIDTH AFFECTS_ELABORATION true
add_display_item "Transfer Options" DATA_WIDTH parameter

add_parameter LENGTH_WIDTH INTEGER 32 "Width of the length register, reduce this to increase Fmax and the logic footprint."
set_parameter_property LENGTH_WIDTH ALLOWED_RANGES {10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32}
set_parameter_property LENGTH_WIDTH DISPLAY_NAME "Length Width"
set_parameter_property LENGTH_WIDTH AFFECTS_GENERATION false
set_parameter_property LENGTH_WIDTH DERIVED false
set_parameter_property LENGTH_WIDTH HDL_PARAMETER true
set_parameter_property LENGTH_WIDTH AFFECTS_ELABORATION false
add_display_item "Transfer Options" LENGTH_WIDTH parameter

add_parameter FIFO_DEPTH INTEGER 32 "Depth of the internal data FIFO."
set_parameter_property FIFO_DEPTH ALLOWED_RANGES {16 32 64 128 256 512 1024 2048 4096}
set_parameter_property FIFO_DEPTH DISPLAY_NAME "FIFO Depth"
set_parameter_property FIFO_DEPTH DERIVED false
set_parameter_property FIFO_DEPTH AFFECTS_GENERATION false
set_parameter_property FIFO_DEPTH HDL_PARAMETER true
set_parameter_property FIFO_DEPTH AFFECTS_ELABORATION false
add_display_item "Transfer Options" FIFO_DEPTH parameter

add_parameter STRIDE_ENABLE Integer 0 "Enable stride to control the address incrementing, when off the master increments the address sequentially one word at a time.  Stride cannot be used with burst capabilities enabled."
set_parameter_property STRIDE_ENABLE DISPLAY_NAME "Stride Addressing Enable"
set_parameter_property STRIDE_ENABLE DISPLAY_HINT boolean
set_parameter_property STRIDE_ENABLE AFFECTS_GENERATION false
set_parameter_property STRIDE_ENABLE DERIVED false
set_parameter_property STRIDE_ENABLE HDL_PARAMETER true
set_parameter_property STRIDE_ENABLE AFFECTS_ELABORATION false
add_display_item "Transfer Options" STRIDE_ENABLE parameter

add_parameter GUI_STRIDE_WIDTH INTEGER 1  "Set the stride width for whatever maximum address increment you want to use.  A stride of 0 performs fixed accesses, 1 performs sequential, 2 reads from every other word, etc..."
set_parameter_property GUI_STRIDE_WIDTH ALLOWED_RANGES {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16}
set_parameter_property GUI_STRIDE_WIDTH DISPLAY_NAME "Stride Width (words)"
set_parameter_property GUI_STRIDE_WIDTH AFFECTS_GENERATION false
set_parameter_property GUI_STRIDE_WIDTH DERIVED false
set_parameter_property GUI_STRIDE_WIDTH HDL_PARAMETER false
set_parameter_property GUI_STRIDE_WIDTH AFFECTS_ELABORATION false
add_display_item "Transfer Options" GUI_STRIDE_WIDTH parameter

add_parameter BURST_ENABLE INTEGER 0 "Burst enable will turn on the bursting capabilities of the read master.  Bursting must not be enabled when stride is also enabled." 
set_parameter_property BURST_ENABLE DISPLAY_NAME "Burst Enable"
set_parameter_property BURST_ENABLE DISPLAY_HINT boolean
set_parameter_property BURST_ENABLE AFFECTS_GENERATION false
set_parameter_property BURST_ENABLE HDL_PARAMETER true
set_parameter_property BURST_ENABLE DERIVED false
set_parameter_property BURST_ENABLE AFFECTS_ELABORATION true
add_display_item "Transfer Options" BURST_ENABLE parameter

add_parameter GUI_MAX_BURST_COUNT INTEGER 2 "Maximum burst count."
set_parameter_property GUI_MAX_BURST_COUNT ALLOWED_RANGES {2 4 8 16 32 64 128 256 512 1024}
set_parameter_property GUI_MAX_BURST_COUNT DISPLAY_NAME "Maximum Burst Count"
set_parameter_property GUI_MAX_BURST_COUNT AFFECTS_GENERATION false
set_parameter_property GUI_MAX_BURST_COUNT HDL_PARAMETER false
set_parameter_property GUI_MAX_BURST_COUNT DERIVED false
set_parameter_property GUI_MAX_BURST_COUNT AFFECTS_ELABORATION false
add_display_item "Transfer Options" GUI_MAX_BURST_COUNT parameter

add_parameter GUI_PROGRAMMABLE_BURST_ENABLE INTEGER 0 "Enable re-programming of the maximum burst count.  Burst counts can only be reprogrammed between 2-128.  Make sure the maximum burst count is set large enough for the burst counts you want to re-program.  You cannot use this setting and burst alignment support concurrently."
set_parameter_property GUI_PROGRAMMABLE_BURST_ENABLE DISPLAY_NAME "Programmable Burst Enable"
set_parameter_property GUI_PROGRAMMABLE_BURST_ENABLE DISPLAY_HINT boolean
set_parameter_property GUI_PROGRAMMABLE_BURST_ENABLE AFFECTS_GENERATION false
set_parameter_property GUI_PROGRAMMABLE_BURST_ENABLE HDL_PARAMETER false
set_parameter_property GUI_PROGRAMMABLE_BURST_ENABLE DERIVED false
set_parameter_property GUI_PROGRAMMABLE_BURST_ENABLE AFFECTS_ELABORATION false
add_display_item "Transfer Options" GUI_PROGRAMMABLE_BURST_ENABLE parameter

add_parameter GUI_BURST_WRAPPING_SUPPORT INTEGER 1 "Enable to force the read master to align to the next burst boundary.  This setting must be enabled when the read master is connected to burst wrapping slave ports (SDRAM for example).  You cannot use this setting and programmable burst capabilities concurrently."
set_parameter_property GUI_BURST_WRAPPING_SUPPORT DISPLAY_NAME "Force Burst Alignment Enable"
set_parameter_property GUI_BURST_WRAPPING_SUPPORT DISPLAY_HINT boolean
set_parameter_property GUI_BURST_WRAPPING_SUPPORT AFFECTS_GENERATION false
set_parameter_property GUI_BURST_WRAPPING_SUPPORT HDL_PARAMETER false
set_parameter_property GUI_BURST_WRAPPING_SUPPORT DERIVED false
set_parameter_property GUI_BURST_WRAPPING_SUPPORT AFFECTS_ELABORATION false
add_display_item "Transfer Options" GUI_BURST_WRAPPING_SUPPORT parameter





# this parameter will be displayed instead of "UNALIGNED_ACCESS_ENABLE" and "ONLY_FULL_ACCESS_ENABLE".  It will be used to control the unaligned and only full access enable parameters
add_parameter TRANSFER_TYPE STRING "Aligned Accesses" "Setting the access types will allow you to reduce the hardware footprint and increase the fmax when unnecessary features like unaligned accesses are not necessary for your system."
set_parameter_property TRANSFER_TYPE ALLOWED_RANGES { "Full Word Accesses Only" "Aligned Accesses" "Unaligned Accesses" }
set_parameter_property TRANSFER_TYPE DISPLAY_NAME "Transfer Type"
set_parameter_property TRANSFER_TYPE DISPLAY_HINT radio
set_parameter_property TRANSFER_TYPE AFFECTS_GENERATION false
set_parameter_property TRANSFER_TYPE DERIVED false
set_parameter_property TRANSFER_TYPE HDL_PARAMETER false
set_parameter_property TRANSFER_TYPE AFFECTS_ELABORATION false
add_display_item "Memory Access Options" TRANSFER_TYPE parameter





# following parameters are for the data streaming port of the master
add_parameter PACKET_ENABLE INTEGER 0 "Enable packet support to add packetized streaming outputs."
set_parameter_property PACKET_ENABLE DISPLAY_NAME "Packet Support Enable"
set_parameter_property PACKET_ENABLE DISPLAY_HINT boolean
set_parameter_property PACKET_ENABLE AFFECTS_GENERATION false
set_parameter_property PACKET_ENABLE DERIVED false
set_parameter_property PACKET_ENABLE HDL_PARAMETER true
set_parameter_property PACKET_ENABLE AFFECTS_ELABORATION true
add_display_item "Streaming Options" PACKET_ENABLE parameter

add_parameter ERROR_ENABLE Integer 0 "Enable error support to include a streaming error output."
set_parameter_property ERROR_ENABLE DISPLAY_NAME "Error Enable"
set_parameter_property ERROR_ENABLE DISPLAY_HINT boolean
set_parameter_property ERROR_ENABLE AFFECTS_GENERATION false
set_parameter_property ERROR_ENABLE DERIVED false
set_parameter_property ERROR_ENABLE HDL_PARAMETER true
set_parameter_property ERROR_ENABLE AFFECTS_ELABORATION true
add_display_item "Streaming Options" ERROR_ENABLE parameter

add_parameter ERROR_WIDTH INTEGER 8 "Set the error width according to the number of error lines connected to the data source port."
set_parameter_property ERROR_WIDTH ALLOWED_RANGES {1 2 3 4 5 6 7 8}
set_parameter_property ERROR_WIDTH DISPLAY_NAME "Error Width"
set_parameter_property ERROR_WIDTH AFFECTS_GENERATION false
set_parameter_property ERROR_WIDTH DERIVED false
set_parameter_property ERROR_WIDTH HDL_PARAMETER true
set_parameter_property ERROR_WIDTH AFFECTS_ELABORATION true
add_display_item "Streaming Options" ERROR_WIDTH parameter

add_parameter CHANNEL_ENABLE INTEGER 0 "Enable channel support to include a channel output."
set_parameter_property CHANNEL_ENABLE DISPLAY_NAME "Channel Enable"
set_parameter_property CHANNEL_ENABLE DISPLAY_HINT boolean
set_parameter_property CHANNEL_ENABLE AFFECTS_GENERATION false
set_parameter_property CHANNEL_ENABLE DERIVED false
set_parameter_property CHANNEL_ENABLE HDL_PARAMETER true
set_parameter_property CHANNEL_ENABLE AFFECTS_ELABORATION true
add_display_item "Streaming Options" CHANNEL_ENABLE parameter

add_parameter CHANNEL_WIDTH INTEGER 8 "Set the channel width according to the number of channel lines connected to the data source port."
set_parameter_property CHANNEL_WIDTH ALLOWED_RANGES {1 2 3 4 5 6 7 8}
set_parameter_property CHANNEL_WIDTH DISPLAY_NAME "Channel Width"
set_parameter_property CHANNEL_WIDTH AFFECTS_GENERATION false
set_parameter_property CHANNEL_WIDTH DERIVED false
set_parameter_property CHANNEL_WIDTH HDL_PARAMETER true
set_parameter_property CHANNEL_WIDTH AFFECTS_ELABORATION true
add_display_item "Streaming Options" CHANNEL_WIDTH parameter




# The remaining parameters are not displayed in the GUI
add_parameter BYTE_ENABLE_WIDTH INTEGER 4
set_parameter_property BYTE_ENABLE_WIDTH AFFECTS_GENERATION false
set_parameter_property BYTE_ENABLE_WIDTH DERIVED true
set_parameter_property BYTE_ENABLE_WIDTH HDL_PARAMETER true
set_parameter_property BYTE_ENABLE_WIDTH AFFECTS_ELABORATION true
set_parameter_property BYTE_ENABLE_WIDTH VISIBLE false

add_parameter BYTE_ENABLE_WIDTH_LOG2 INTEGER 2
set_parameter_property BYTE_ENABLE_WIDTH_LOG2 AFFECTS_GENERATION false
set_parameter_property BYTE_ENABLE_WIDTH_LOG2 DERIVED true
set_parameter_property BYTE_ENABLE_WIDTH_LOG2 HDL_PARAMETER true
set_parameter_property BYTE_ENABLE_WIDTH_LOG2 AFFECTS_ELABORATION false
set_parameter_property BYTE_ENABLE_WIDTH_LOG2 VISIBLE false

add_parameter ADDRESS_WIDTH INTEGER 32
set_parameter_property ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property ADDRESS_WIDTH DERIVED true
set_parameter_property ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property ADDRESS_WIDTH AFFECTS_ELABORATION true
set_parameter_property ADDRESS_WIDTH VISIBLE false
set_parameter_property ADDRESS_WIDTH SYSTEM_INFO {ADDRESS_WIDTH Data_Read_Master}

add_parameter FIFO_DEPTH_LOG2 INTEGER 5
set_parameter_property FIFO_DEPTH_LOG2 AFFECTS_GENERATION false
set_parameter_property FIFO_DEPTH_LOG2 DERIVED true
set_parameter_property FIFO_DEPTH_LOG2 HDL_PARAMETER true
set_parameter_property FIFO_DEPTH_LOG2 AFFECTS_ELABORATION false
set_parameter_property FIFO_DEPTH_LOG2 VISIBLE false

add_parameter SYMBOL_WIDTH INTEGER 8
set_parameter_property SYMBOL_WIDTH AFFECTS_GENERATION false
set_parameter_property SYMBOL_WIDTH DERIVED true
set_parameter_property SYMBOL_WIDTH HDL_PARAMETER true
set_parameter_property SYMBOL_WIDTH AFFECTS_ELABORATION true
set_parameter_property SYMBOL_WIDTH VISIBLE false

add_parameter NUMBER_OF_SYMBOLS INTEGER 4
set_parameter_property NUMBER_OF_SYMBOLS AFFECTS_GENERATION false
set_parameter_property NUMBER_OF_SYMBOLS DERIVED true
set_parameter_property NUMBER_OF_SYMBOLS HDL_PARAMETER true
set_parameter_property NUMBER_OF_SYMBOLS AFFECTS_ELABORATION true
set_parameter_property NUMBER_OF_SYMBOLS VISIBLE false

add_parameter NUMBER_OF_SYMBOLS_LOG2 INTEGER 2
set_parameter_property NUMBER_OF_SYMBOLS_LOG2 AFFECTS_GENERATION false
set_parameter_property NUMBER_OF_SYMBOLS_LOG2 DERIVED true
set_parameter_property NUMBER_OF_SYMBOLS_LOG2 HDL_PARAMETER true
set_parameter_property NUMBER_OF_SYMBOLS_LOG2 AFFECTS_ELABORATION true
set_parameter_property NUMBER_OF_SYMBOLS_LOG2 VISIBLE false

add_parameter MAX_BURST_COUNT_WIDTH INTEGER 2
set_parameter_property MAX_BURST_COUNT_WIDTH AFFECTS_GENERATION false
set_parameter_property MAX_BURST_COUNT_WIDTH DERIVED true
set_parameter_property MAX_BURST_COUNT_WIDTH HDL_PARAMETER true
set_parameter_property MAX_BURST_COUNT_WIDTH AFFECTS_ELABORATION true
set_parameter_property MAX_BURST_COUNT_WIDTH VISIBLE false

add_parameter UNALIGNED_ACCESSES_ENABLE INTEGER 0
set_parameter_property UNALIGNED_ACCESSES_ENABLE AFFECTS_GENERATION false
set_parameter_property UNALIGNED_ACCESSES_ENABLE DERIVED true
set_parameter_property UNALIGNED_ACCESSES_ENABLE HDL_PARAMETER true
set_parameter_property UNALIGNED_ACCESSES_ENABLE AFFECTS_ELABORATION false
set_parameter_property UNALIGNED_ACCESSES_ENABLE VISIBLE false

add_parameter ONLY_FULL_ACCESS_ENABLE Integer 0
set_parameter_property ONLY_FULL_ACCESS_ENABLE AFFECTS_GENERATION false
set_parameter_property ONLY_FULL_ACCESS_ENABLE DERIVED true
set_parameter_property ONLY_FULL_ACCESS_ENABLE HDL_PARAMETER true
set_parameter_property ONLY_FULL_ACCESS_ENABLE AFFECTS_ELABORATION false
set_parameter_property ONLY_FULL_ACCESS_ENABLE VISIBLE false

add_parameter BURST_WRAPPING_SUPPORT INTEGER 1
set_parameter_property BURST_WRAPPING_SUPPORT AFFECTS_GENERATION false
set_parameter_property BURST_WRAPPING_SUPPORT DERIVED true
set_parameter_property BURST_WRAPPING_SUPPORT HDL_PARAMETER true
set_parameter_property BURST_WRAPPING_SUPPORT AFFECTS_ELABORATION true
set_parameter_property BURST_WRAPPING_SUPPORT VISIBLE false

add_parameter PROGRAMMABLE_BURST_ENABLE INTEGER 0
set_parameter_property PROGRAMMABLE_BURST_ENABLE AFFECTS_GENERATION false
set_parameter_property PROGRAMMABLE_BURST_ENABLE DERIVED true
set_parameter_property PROGRAMMABLE_BURST_ENABLE HDL_PARAMETER true
set_parameter_property PROGRAMMABLE_BURST_ENABLE AFFECTS_ELABORATION false
set_parameter_property PROGRAMMABLE_BURST_ENABLE VISIBLE false

add_parameter MAX_BURST_COUNT INTEGER 2
set_parameter_property MAX_BURST_COUNT AFFECTS_GENERATION false
set_parameter_property MAX_BURST_COUNT DERIVED true
set_parameter_property MAX_BURST_COUNT HDL_PARAMETER true
set_parameter_property MAX_BURST_COUNT AFFECTS_ELABORATION true
set_parameter_property MAX_BURST_COUNT VISIBLE false

add_parameter FIFO_SPEED_OPTIMIZATION Integer 1
set_parameter_property FIFO_SPEED_OPTIMIZATION AFFECTS_GENERATION false
set_parameter_property FIFO_SPEED_OPTIMIZATION DERIVED false
set_parameter_property FIFO_SPEED_OPTIMIZATION HDL_PARAMETER true
set_parameter_property FIFO_SPEED_OPTIMIZATION AFFECTS_ELABORATION false
set_parameter_property FIFO_SPEED_OPTIMIZATION VISIBLE false

add_parameter STRIDE_WIDTH INTEGER 1
set_parameter_property STRIDE_WIDTH AFFECTS_GENERATION false
set_parameter_property STRIDE_WIDTH DERIVED true
set_parameter_property STRIDE_WIDTH HDL_PARAMETER true
set_parameter_property STRIDE_WIDTH AFFECTS_ELABORATION false
set_parameter_property STRIDE_WIDTH VISIBLE false
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point Clock
# | 
add_interface Clock clock end
set_interface_property Clock ptfSchematicName ""

set_interface_property Clock ENABLED true

add_interface_port Clock clk clk Input 1
add_interface_port Clock reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point Data_Read_Master
# | 
add_interface Data_Read_Master avalon start
set_interface_property Data_Read_Master adaptsTo ""
set_interface_property Data_Read_Master doStreamReads false
set_interface_property Data_Read_Master doStreamWrites false
set_interface_property Data_Read_Master linewrapBursts false

set_interface_property Data_Read_Master ASSOCIATED_CLOCK Clock
set_interface_property Data_Read_Master ENABLED true

add_interface_port Data_Read_Master master_address address Output -1
add_interface_port Data_Read_Master master_read read Output 1
add_interface_port Data_Read_Master master_byteenable byteenable Output -1
add_interface_port Data_Read_Master master_readdata readdata Input -1
add_interface_port Data_Read_Master master_waitrequest waitrequest Input 1
add_interface_port Data_Read_Master master_readdatavalid readdatavalid Input 1
add_interface_port Data_Read_Master master_burstcount burstcount Output -1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point Data_Source
# | 
add_interface Data_Source avalon_streaming start
set_interface_property Data_Source dataBitsPerSymbol 8
set_interface_property Data_Source errorDescriptor ""
set_interface_property Data_Source maxChannel 0
set_interface_property Data_Source readyLatency 0
set_interface_property Data_Source symbolsPerBeat 1

set_interface_property Data_Source ASSOCIATED_CLOCK Clock
set_interface_property Data_Source ENABLED true

add_interface_port Data_Source src_data data Output -1
add_interface_port Data_Source src_valid valid Output 1
add_interface_port Data_Source src_ready ready Input 1
add_interface_port Data_Source src_sop startofpacket Output 1
add_interface_port Data_Source src_eop endofpacket Output 1
add_interface_port Data_Source src_empty empty Output -1
add_interface_port Data_Source src_error error Output -1
add_interface_port Data_Source src_channel channel Output -1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point Command_Sink
# | 
add_interface Command_Sink avalon_streaming end
set_interface_property Command_Sink dataBitsPerSymbol 256
set_interface_property Command_Sink errorDescriptor ""
set_interface_property Command_Sink maxChannel 0
set_interface_property Command_Sink readyLatency 0
set_interface_property Command_Sink symbolsPerBeat 1

set_interface_property Command_Sink ASSOCIATED_CLOCK Clock
set_interface_property Command_Sink ENABLED true

add_interface_port Command_Sink snk_command_data data Input 256
add_interface_port Command_Sink snk_command_valid valid Input 1
add_interface_port Command_Sink snk_command_ready ready Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point Response_Source
# | 
add_interface Response_Source avalon_streaming start
set_interface_property Response_Source dataBitsPerSymbol 256
set_interface_property Response_Source errorDescriptor ""
set_interface_property Response_Source maxChannel 0
set_interface_property Response_Source readyLatency 0
set_interface_property Response_Source symbolsPerBeat 1

set_interface_property Response_Source ASSOCIATED_CLOCK Clock
set_interface_property Response_Source ENABLED true

add_interface_port Response_Source src_response_data data Output 256
add_interface_port Response_Source src_response_valid valid Output 1
add_interface_port Response_Source src_response_ready ready Input 1
# | 
# +-----------------------------------


# the elaboration callback will be used to enable/disable the error, empty, eop, sop signals
# based on user input as well as control the width of all the signals that have variable width
proc elaborate_me {}  {

  set_port_property src_data WIDTH [get_parameter_value DATA_WIDTH]
  set_port_property src_error WIDTH [get_parameter_value ERROR_WIDTH]
  set_port_property src_channel WIDTH [get_parameter_value CHANNEL_WIDTH]
  set_port_property master_burstcount WIDTH [get_parameter_value MAX_BURST_COUNT_WIDTH]

  if { [get_parameter_value CHANNEL_ENABLE] == 1 }  {
    set_interface_property Data_Source maxChannel [expr {pow (2, [get_parameter_value CHANNEL_WIDTH]) - 1}]
  } else {
    set_interface_property Data_Source maxChannel 0
  }

  # need to make sure the empty signal isn't using a width of 0 which would be the case if DATA_WIDTH is 8.  This port will be terminated if DATA_WIDTH is 8.
  if { [get_parameter_value DATA_WIDTH] == 8 }  {
    set_port_property src_empty WIDTH 1
  } else {
    set_port_property src_empty WIDTH [get_parameter_value NUMBER_OF_SYMBOLS_LOG2]
  }
  set_port_property master_byteenable WIDTH [get_parameter_value BYTE_ENABLE_WIDTH]
  set_port_property master_address WIDTH [get_parameter_value ADDRESS_WIDTH]
  set_port_property master_readdata WIDTH [get_parameter_value DATA_WIDTH]

  set_interface_property Data_Source symbolsPerBeat [get_parameter_value NUMBER_OF_SYMBOLS]  

  if { [get_parameter_value ERROR_ENABLE] == 1 }  { 
    set_port_property src_error TERMINATION false
  } else {
    set_port_property src_error TERMINATION true
  }

  if { [get_parameter_value CHANNEL_ENABLE] == 1 }  {
    set_port_property src_channel TERMINATION false
  } else {
    set_port_property src_channel TERMINATION true
  }

  # don't need byte enables if the data width is 8
  if { [get_parameter_value DATA_WIDTH] > 8 }  {
    set_port_property master_byteenable TERMINATION false
  } else {
    set_port_property master_byteenable TERMINATION true
  }

  if { [get_parameter_value PACKET_ENABLE] == 1 }  {
    set_port_property src_sop TERMINATION false
    set_port_property src_eop TERMINATION false
  } else {
    set_port_property src_sop TERMINATION true
    set_port_property src_eop TERMINATION true
  }

  if { ([get_parameter_value PACKET_ENABLE] == 1) && ([get_parameter_value DATA_WIDTH] > 8) }  {
    set_port_property src_empty TERMINATION false
  } else {
    set_port_property src_empty TERMINATION true
  }

  if { [get_parameter_value BURST_ENABLE] == 1 }  {
    set_port_property master_burstcount TERMINATION false
  } else {
    set_port_property master_burstcount TERMINATION true
  }

  # when the forced burst alignment is enabled the master will post bursts of 1 until the next burst boundary is reached so this is safe to enable.
  if { [get_parameter_value BURST_WRAPPING_SUPPORT] == 1 }  {
    set_interface_property Data_Read_Master burstOnBurstBoundariesOnly true
  } else {
    set_interface_property Data_Read_Master burstOnBurstBoundariesOnly false
  }

}


# the validation callback will be enabling/disabling GUI controls based on user input
proc validate_me {}  {

  #  need to use full word accesses when data width is 8-bits wide
  if { ([get_parameter_value TRANSFER_TYPE] == "Full Word Accesses Only") || ([get_parameter_value DATA_WIDTH] == 8) }  {
    set_parameter_value UNALIGNED_ACCESSES_ENABLE 0
    set_parameter_value ONLY_FULL_ACCESS_ENABLE 1
  } else {
    if { [get_parameter_value TRANSFER_TYPE] == "Aligned Accesses" }  {
      set_parameter_value UNALIGNED_ACCESSES_ENABLE 0
      set_parameter_value ONLY_FULL_ACCESS_ENABLE 0
    } else {
      set_parameter_value UNALIGNED_ACCESSES_ENABLE 1
      set_parameter_value ONLY_FULL_ACCESS_ENABLE 0
    }
  }


  if { [get_parameter_value BURST_ENABLE] == 1 }  {
    set_parameter_property GUI_MAX_BURST_COUNT ENABLED true
    set_parameter_property GUI_PROGRAMMABLE_BURST_ENABLE ENABLED true
    set_parameter_property GUI_BURST_WRAPPING_SUPPORT ENABLED true
    set_parameter_value MAX_BURST_COUNT [get_parameter_value GUI_MAX_BURST_COUNT]
    set_parameter_value MAX_BURST_COUNT_WIDTH [expr {(log([get_parameter_value GUI_MAX_BURST_COUNT]) / log(2)) + 1}]
    set_parameter_value PROGRAMMABLE_BURST_ENABLE [get_parameter_value GUI_PROGRAMMABLE_BURST_ENABLE]
    set_parameter_value BURST_WRAPPING_SUPPORT [get_parameter_value GUI_BURST_WRAPPING_SUPPORT]
  } else {
    set_parameter_property GUI_MAX_BURST_COUNT ENABLED false
    set_parameter_property GUI_PROGRAMMABLE_BURST_ENABLE ENABLED false
    set_parameter_property GUI_BURST_WRAPPING_SUPPORT ENABLED false
    set_parameter_value MAX_BURST_COUNT 1
    set_parameter_value MAX_BURST_COUNT_WIDTH 1
    set_parameter_value PROGRAMMABLE_BURST_ENABLE 0
    set_parameter_value BURST_WRAPPING_SUPPORT 0
  }


  if { [get_parameter_value STRIDE_ENABLE] == 1 }  {
    set_parameter_property GUI_STRIDE_WIDTH ENABLED true
    set_parameter_value STRIDE_WIDTH [get_parameter_value GUI_STRIDE_WIDTH]
  } else {
    set_parameter_property GUI_STRIDE_WIDTH ENABLED false
    set_parameter_value STRIDE_WIDTH 1
  }

  if { [get_parameter_value CHANNEL_ENABLE] == 1 }  {
    set_parameter_property CHANNEL_WIDTH ENABLED true
  } else {
    set_parameter_property CHANNEL_WIDTH ENABLED false
  }

  if { [get_parameter_value ERROR_ENABLE] == 1 }  {
    set_parameter_property ERROR_WIDTH ENABLED true
  } else {
    set_parameter_property ERROR_WIDTH ENABLED false
  }


  set_parameter_value BYTE_ENABLE_WIDTH [expr {[get_parameter_value DATA_WIDTH] / 8}]
  set_parameter_value NUMBER_OF_SYMBOLS [expr {[get_parameter_value DATA_WIDTH] / 8}]
  set_parameter_value FIFO_DEPTH_LOG2 [expr {(log([get_parameter_value FIFO_DEPTH]) / log(2))}]

  
  # in the case of 8 bit data need to make sure that the log2 values don't result in 0
  if { [get_parameter_value DATA_WIDTH] == 8 }  {
    set_parameter_value BYTE_ENABLE_WIDTH_LOG2 1
    set_parameter_value NUMBER_OF_SYMBOLS_LOG2 1
  } else {
    set_parameter_value BYTE_ENABLE_WIDTH_LOG2 [expr {(log([get_parameter_value DATA_WIDTH] / 8) / log(2))}]
    set_parameter_value NUMBER_OF_SYMBOLS_LOG2 [expr {(log([get_parameter_value DATA_WIDTH] / 8) / log(2))}]
  }


  if { [get_parameter_value ADDRESS_WIDTH] < [get_parameter_value LENGTH_WIDTH] }  {
    send_message Info "You have selected a length width that spans a larger transfer size than is addressable by the master port.  Reducing the length width will improve the Fmax of this component."
  }

  if { ([get_parameter_value BURST_ENABLE] == 1) && ([get_parameter_value BURST_WRAPPING_SUPPORT] == 0) }  {
    send_message Warning "If you connect the read master to a burst wrapping slave like SDRAM your system may experience data corruption without the Forced Burst Alignment setting enabled."
  }

  if { ([get_parameter_value TRANSFER_TYPE] == "Unaligned Accesses") && ([get_parameter_value STRIDE_ENABLE] == 1) }  {
    send_message Error "Unaligned accesses and stride support cannot be enabled concurrently."
  }

  if { ([get_parameter_value STRIDE_ENABLE] == 1) && ([get_parameter_value BURST_ENABLE] == 1) }  {
    send_message Error "Burst and stride support cannot be enabled concurrently."
  }

  if { ([get_parameter_value BURST_ENABLE] == 1) && ([get_parameter_value PROGRAMMABLE_BURST_ENABLE] == 1) && ([get_parameter_value MAX_BURST_COUNT_WIDTH] > 8) }  {
    send_message Warning "You have selected programmable burst support but the maximum programmable burst count size is 128.  If you re-program the burst count you will be limited to bursts of up to 128 beats."
  }

  if { ([get_parameter_value BURST_ENABLE] == 1) && ([get_parameter_value MAX_BURST_COUNT] > [expr [get_parameter_value FIFO_DEPTH] / 4]) }  {
    send_message Error "You must select a FIFO size that is at least four times the maximum burst length."
  }

  if { ([get_parameter_value PROGRAMMABLE_BURST_ENABLE] == 1) && ([get_parameter_value BURST_WRAPPING_SUPPORT] == 1) }  {
    send_message Error "You cannot use programmable bursts and forced burst alignment concurrently." 
  }

}
