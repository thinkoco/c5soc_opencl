#package require -exact sopc 9.1

# +-----------------------------------
# | module SGDMA_dispatcher
# | 
set_module_property DESCRIPTION "SGDMA scheduling block"
set_module_property NAME modular_sgdma_dispatcher
set_module_property VERSION 1.0
set_module_property GROUP "Modular_DMA"
set_module_property AUTHOR JCJB
set_module_property DISPLAY_NAME "Modular SGDMA Dispatcher"
set_module_property TOP_LEVEL_HDL_FILE dispatcher.v
set_module_property TOP_LEVEL_HDL_MODULE dispatcher
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property DATASHEET_URL "file:/[get_module_property MODULE_DIRECTORY]Modular_SGDMA_Dispatcher_Core_UG.pdf"
set_module_property "simulationModelInVHDL" "true"
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file dispatcher.v {SYNTHESIS SIMULATION}
add_file csr_block.v {SYNTHESIS SIMULATION}
add_file descriptor_buffers.v {SYNTHESIS SIMULATION}
add_file response_block.v {SYNTHESIS SIMULATION}
add_file fifo_with_byteenables.v {SYNTHESIS SIMULATION}
add_file read_signal_breakout.v {SYNTHESIS SIMULATION}
add_file write_signal_breakout.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------


set_module_property ELABORATION_CALLBACK elaborate_me
set_module_property VALIDATION_CALLBACK validate_me



# +-----------------------------------
# | parameters
# | 
add_parameter MODE INTEGER 0
set_parameter_property MODE DISPLAY_NAME "Transfer Mode"
set_parameter_property MODE UNITS None
set_parameter_property MODE AFFECTS_ELABORATION true
set_parameter_property MODE ALLOWED_RANGES { "0:Memory-Mapped to Memory-Mapped" "1:Memory-Mapped to Streaming" "2:Streaming to Memory-Mapped" }


add_parameter GUI_RESPONSE_PORT INTEGER 0
set_parameter_property GUI_RESPONSE_PORT DISPLAY_NAME "Response Port"
set_parameter_property GUI_RESPONSE_PORT UNITS None
set_parameter_property GUI_RESPONSE_PORT AFFECTS_ELABORATION true
set_parameter_property GUI_RESPONSE_PORT ALLOWED_RANGES { "0:Memory-Mapped" "1:Streaming" "2:Disabled" }

# this will just be a copy of the GUI_RESPONSE_PORT setting that will be set in the validation callback
add_parameter RESPONSE_PORT INTEGER 0
set_parameter_property RESPONSE_PORT DISPLAY_NAME RESPONSE_PORT
set_parameter_property RESPONSE_PORT UNITS None
set_parameter_property RESPONSE_PORT AFFECTS_ELABORATION true
set_parameter_property RESPONSE_PORT VISIBLE false
set_parameter_property RESPONSE_PORT DERIVED true

add_parameter DESCRIPTOR_FIFO_DEPTH INTEGER 128
set_parameter_property DESCRIPTOR_FIFO_DEPTH DISPLAY_NAME "Descriptor FIFO Depth"
set_parameter_property DESCRIPTOR_FIFO_DEPTH UNITS None
set_parameter_property DESCRIPTOR_FIFO_DEPTH AFFECTS_ELABORATION true
set_parameter_property DESCRIPTOR_FIFO_DEPTH ALLOWED_RANGES { 8 16 32 64 128 256 512 1024 }

add_parameter ENHANCED_FEATURES INTEGER 1
set_parameter_property ENHANCED_FEATURES DISPLAY_NAME "Enable Extended Feature Support"
set_parameter_property ENHANCED_FEATURES UNITS None
set_parameter_property ENHANCED_FEATURES AFFECTS_ELABORATION true
set_parameter_property ENHANCED_FEATURES DISPLAY_HINT boolean

# this will be set according to either 16 or 32 depending on ENHANCED_FEATURES
add_parameter DESCRIPTOR_WIDTH INTEGER 256
set_parameter_property DESCRIPTOR_WIDTH DISPLAY_NAME DESCRIPTOR_WIDTH
set_parameter_property DESCRIPTOR_WIDTH UNITS None
set_parameter_property DESCRIPTOR_WIDTH AFFECTS_ELABORATION true
set_parameter_property DESCRIPTOR_WIDTH VISIBLE false
set_parameter_property DESCRIPTOR_WIDTH DERIVED true

# this will be set according to either 16 or 32 depending on ENHANCED_FEATURES
add_parameter DESCRIPTOR_BYTEENABLE_WIDTH INTEGER 32
set_parameter_property DESCRIPTOR_BYTEENABLE_WIDTH DISPLAY_NAME DESCRIPTOR_BYTEENABLE_WIDTH
set_parameter_property DESCRIPTOR_BYTEENABLE_WIDTH UNITS None
set_parameter_property DESCRIPTOR_BYTEENABLE_WIDTH AFFECTS_ELABORATION true
set_parameter_property DESCRIPTOR_BYTEENABLE_WIDTH VISIBLE false
set_parameter_property DESCRIPTOR_BYTEENABLE_WIDTH DERIVED true

# keeping this fixed to 3 even when enhanced features are turned off
add_parameter CSR_ADDRESS_WIDTH INTEGER 3
set_parameter_property CSR_ADDRESS_WIDTH DISPLAY_NAME CSR_ADDRESS_WIDTH
set_parameter_property CSR_ADDRESS_WIDTH UNITS None
set_parameter_property CSR_ADDRESS_WIDTH AFFECTS_ELABORATION true
set_parameter_property CSR_ADDRESS_WIDTH VISIBLE false
set_parameter_property CSR_ADDRESS_WIDTH DERIVED false
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock
# | 
add_interface clock clock end
set_interface_property clock ptfSchematicName ""

add_interface_port clock clk clk Input 1
add_interface_port clock reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point csr
# | 
add_interface CSR avalon end
set_interface_property CSR addressAlignment DYNAMIC
set_interface_property CSR addressSpan 4
set_interface_property CSR bridgesToMaster ""
set_interface_property CSR burstOnBurstBoundariesOnly false
set_interface_property CSR holdTime 0
set_interface_property CSR isMemoryDevice false
set_interface_property CSR isNonVolatileStorage false
set_interface_property CSR linewrapBursts false
set_interface_property CSR maximumPendingReadTransactions 0
set_interface_property CSR minimumUninterruptedRunLength 1
set_interface_property CSR printableDevice false
set_interface_property CSR readLatency 1
set_interface_property CSR readWaitTime 1
set_interface_property CSR setupTime 0
set_interface_property CSR timingUnits Cycles
set_interface_property CSR writeWaitTime 0

set_interface_property CSR ASSOCIATED_CLOCK clock

add_interface_port CSR csr_writedata writedata Input 32
add_interface_port CSR csr_write write Input 1
add_interface_port CSR csr_byteenable byteenable Input 4
add_interface_port CSR csr_readdata readdata Output 32
add_interface_port CSR csr_read read Input 1
add_interface_port CSR csr_address address Input 3

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point st_response
# | 
add_interface Response_Source avalon_streaming start
set_interface_property Response_Source dataBitsPerSymbol 256
set_interface_property Response_Source errorDescriptor ""
set_interface_property Response_Source maxChannel 0
set_interface_property Response_Source readyLatency 0
set_interface_property Response_Source symbolsPerBeat 1

set_interface_property Response_Source ASSOCIATED_CLOCK clock

add_interface_port Response_Source src_response_data data Output 256
add_interface_port Response_Source src_response_valid valid Output 1
add_interface_port Response_Source src_response_ready ready Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point descriptor
# | 
add_interface Descriptor_Slave avalon end
set_interface_property Descriptor_Slave addressAlignment DYNAMIC
set_interface_property Descriptor_Slave bridgesToMaster ""
set_interface_property Descriptor_Slave burstOnBurstBoundariesOnly false
set_interface_property Descriptor_Slave holdTime 0
set_interface_property Descriptor_Slave isMemoryDevice false
set_interface_property Descriptor_Slave isNonVolatileStorage false
set_interface_property Descriptor_Slave linewrapBursts false
set_interface_property Descriptor_Slave maximumPendingReadTransactions 0
set_interface_property Descriptor_Slave minimumUninterruptedRunLength 1
set_interface_property Descriptor_Slave printableDevice false
set_interface_property Descriptor_Slave readLatency 0
set_interface_property Descriptor_Slave readWaitTime 1
set_interface_property Descriptor_Slave setupTime 0
set_interface_property Descriptor_Slave timingUnits Cycles
set_interface_property Descriptor_Slave writeWaitTime 0

set_interface_property Descriptor_Slave ASSOCIATED_CLOCK clock


add_interface_port Descriptor_Slave descriptor_write write Input 1
add_interface_port Descriptor_Slave descriptor_waitrequest waitrequest Output 1
add_interface_port Descriptor_Slave descriptor_writedata writedata Input 256
add_interface_port Descriptor_Slave descriptor_byteenable byteenable Input 32
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point mm_response
# | 
add_interface Response_Slave avalon end
set_interface_property Response_Slave addressAlignment DYNAMIC
set_interface_property Response_Slave addressSpan 8
set_interface_property Response_Slave bridgesToMaster ""
set_interface_property Response_Slave burstOnBurstBoundariesOnly false
set_interface_property Response_Slave holdTime 0
set_interface_property Response_Slave isMemoryDevice false
set_interface_property Response_Slave isNonVolatileStorage false
set_interface_property Response_Slave linewrapBursts false
set_interface_property Response_Slave maximumPendingReadTransactions 0
set_interface_property Response_Slave minimumUninterruptedRunLength 1
set_interface_property Response_Slave printableDevice false
set_interface_property Response_Slave readLatency 0
set_interface_property Response_Slave readWaitTime 1
set_interface_property Response_Slave setupTime 0
set_interface_property Response_Slave timingUnits Cycles
set_interface_property Response_Slave writeWaitTime 0

set_interface_property Response_Slave ASSOCIATED_CLOCK clock

add_interface_port Response_Slave mm_response_waitrequest waitrequest Output 1
add_interface_port Response_Slave mm_response_byteenable byteenable Input 4
add_interface_port Response_Slave mm_response_address address Input 1
add_interface_port Response_Slave mm_response_readdata readdata Output 32
add_interface_port Response_Slave mm_response_read read Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point write_master_descriptor
# | 
add_interface Write_Command_Source avalon_streaming start
set_interface_property Write_Command_Source dataBitsPerSymbol 256
set_interface_property Write_Command_Source errorDescriptor ""
set_interface_property Write_Command_Source maxChannel 0
set_interface_property Write_Command_Source readyLatency 0
set_interface_property Write_Command_Source symbolsPerBeat 1

set_interface_property Write_Command_Source ASSOCIATED_CLOCK clock

add_interface_port Write_Command_Source src_write_master_data data Output 256
add_interface_port Write_Command_Source src_write_master_valid valid Output 1
add_interface_port Write_Command_Source src_write_master_ready ready Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point write_master_response
# | 
add_interface Write_Response_Sink avalon_streaming end
set_interface_property Write_Response_Sink dataBitsPerSymbol 256
set_interface_property Write_Response_Sink errorDescriptor ""
set_interface_property Write_Response_Sink maxChannel 0
set_interface_property Write_Response_Sink readyLatency 0
set_interface_property Write_Response_Sink symbolsPerBeat 1

set_interface_property Write_Response_Sink ASSOCIATED_CLOCK clock

add_interface_port Write_Response_Sink snk_write_master_data data Input 256
add_interface_port Write_Response_Sink snk_write_master_valid valid Input 1
add_interface_port Write_Response_Sink snk_write_master_ready ready Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point read_master_descriptor
# | 
add_interface Read_Command_Source avalon_streaming start
set_interface_property Read_Command_Source dataBitsPerSymbol 256
set_interface_property Read_Command_Source errorDescriptor ""
set_interface_property Read_Command_Source maxChannel 0
set_interface_property Read_Command_Source readyLatency 0
set_interface_property Read_Command_Source symbolsPerBeat 1

set_interface_property Read_Command_Source ASSOCIATED_CLOCK clock

add_interface_port Read_Command_Source src_read_master_data data Output 256
add_interface_port Read_Command_Source src_read_master_valid valid Output 1
add_interface_port Read_Command_Source src_read_master_ready ready Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point read_master_response
# | 
add_interface Read_Response_Sink avalon_streaming end
set_interface_property Read_Response_Sink dataBitsPerSymbol 256
set_interface_property Read_Response_Sink errorDescriptor ""
set_interface_property Read_Response_Sink maxChannel 0
set_interface_property Read_Response_Sink readyLatency 0
set_interface_property Read_Response_Sink symbolsPerBeat 1

set_interface_property Read_Response_Sink ASSOCIATED_CLOCK clock

add_interface_port Read_Response_Sink snk_read_master_data data Input 256
add_interface_port Read_Response_Sink snk_read_master_valid valid Input 1
add_interface_port Read_Response_Sink snk_read_master_ready ready Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point csr_irq
# | 
add_interface csr_irq interrupt end
set_interface_property csr_irq associatedAddressablePoint CSR

set_interface_property csr_irq ASSOCIATED_CLOCK clock

add_interface_port csr_irq csr_irq irq Output 1
# | 
# +-----------------------------------


# need to set address and byte enable widths depending on parameterization.  Also need to terminate interfaces depending
# on the parameterization.
proc elaborate_me {}  { 
  set the_MODE [get_parameter_value MODE]
  set the_RESPONSE_PORT [get_parameter_value RESPONSE_PORT]

  switch $the_MODE { 
    0 { 
      ## MM to MM
      set_interface_property Write_Command_Source ENABLED true
      set_interface_property Write_Response_Sink ENABLED true
      set_interface_property Read_Command_Source ENABLED true
      set_interface_property Read_Response_Sink ENABLED true
    } 
    1 { 
      ## MM to ST (remove the write master interfaces and hardcode write port inputs to ground)
      set_interface_property Write_Command_Source ENABLED false
      set_interface_property Write_Response_Sink ENABLED false
      set_interface_property Read_Command_Source ENABLED true
      set_interface_property Read_Response_Sink ENABLED true      
    } 
    default { 
      ## ST to MM (remove the read master interfaces and hardcode read port inputs to ground)
      set_interface_property Write_Command_Source ENABLED true
      set_interface_property Write_Response_Sink ENABLED true
      set_interface_property Read_Command_Source ENABLED false
      set_interface_property Read_Response_Sink ENABLED false
    } 
  }
  
  switch $the_RESPONSE_PORT {
    0 {
      ## MM slave port for response information
      set_interface_property Response_Slave ENABLED true
      set_interface_property Response_Source ENABLED false
      set_interface_property csr_irq ENABLED true    
    }
    1 {
      ## ST source port for response data (note the interrupt port is removed and interrupt info is sent through the response port instead)
      set_interface_property Response_Slave ENABLED false
      set_interface_property Response_Source ENABLED true
      set_interface_property csr_irq ENABLED false   
    }
    default {
      ## No response port
      set_interface_property Response_Slave ENABLED false
      set_interface_property Response_Source ENABLED false
      set_interface_property csr_irq ENABLED true     
    }
  }
  
  set_port_property descriptor_writedata WIDTH [get_parameter_value DESCRIPTOR_WIDTH]
  set_port_property descriptor_byteenable WIDTH [get_parameter_value DESCRIPTOR_BYTEENABLE_WIDTH]
  
  set_module_assignment "embeddedsw.CMacro.DESCRIPTOR_FIFO_DEPTH" [get_parameter_value DESCRIPTOR_FIFO_DEPTH]
  set_module_assignment "embeddedsw.CMacro.RESPONSE_FIFO_DEPTH" [expr 2 * [get_parameter_value DESCRIPTOR_FIFO_DEPTH]]
} 


# issue out messages to the user about the response port
proc validate_me {} { 
  set the_MODE [get_parameter_value MODE]
  set the_GUI_RESPONSE_PORT [get_parameter_value GUI_RESPONSE_PORT]
  set the_ENHANCED_FEATURES [get_parameter_value ENHANCED_FEATURES]
  

  if { $the_ENHANCED_FEATURES == 1 } { 
    set_parameter_value DESCRIPTOR_WIDTH 256
    set_parameter_value DESCRIPTOR_BYTEENABLE_WIDTH 32
  } else { 
    set_parameter_value DESCRIPTOR_WIDTH 128
    set_parameter_value DESCRIPTOR_BYTEENABLE_WIDTH 16
  }

  ## MM to ST so disable the response port and grey out the pull down box
  if { $the_MODE == 1 }  {
    set_parameter_property GUI_RESPONSE_PORT ENABLED false
    set_parameter_value RESPONSE_PORT 2
  } else {
    set_parameter_property GUI_RESPONSE_PORT ENABLED true
    set_parameter_value RESPONSE_PORT $the_GUI_RESPONSE_PORT
  }

  ## outputing warnings and hints (note:  response information will be allowed for MM->MM transfers since users might put some streaming blocks between the masters that have error support)
  if { $the_GUI_RESPONSE_PORT == 0 } {
    if { $the_MODE == 0 } {
      send_message Info "For MM to MM transfers you typically do not need a MM response port"
    }
  } elseif { $the_GUI_RESPONSE_PORT == 1 } {
    send_message Info "Interrupts must be handled by the component connected to the response source port (such as a descriptor pre-fetching block)"
  }
  
}
