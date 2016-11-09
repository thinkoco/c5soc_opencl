# Dmitry's QSYS-compliant AND-gate (aka irq_ena)

# +-----------------------------------
# | module sw_reset
# | 
set_module_property DESCRIPTION "Adds enable to an irq line"
set_module_property NAME irq_ena
set_module_property VERSION 13.0
set_module_property GROUP "ACL Internal Components"
set_module_property AUTHOR "Altera OpenCL"
set_module_property DISPLAY_NAME "ACL irq ena"
set_module_property TOP_LEVEL_HDL_FILE irq_ena.v
set_module_property TOP_LEVEL_HDL_MODULE irq_ena
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
#set_module_property VALIDATION_CALLBACK validate
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file irq_ena.v {SYNTHESIS SIMULATION}
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
add_interface_port clk_reset resetn reset_n Input 1
# | 
# +-----------------------------------


# +-----------------------------------
# | connection point s
# | 
add_interface s avalon end
set_interface_property s addressAlignment DYNAMIC
set_interface_property s addressUnits WORDS
set_interface_property s associatedClock clk
set_interface_property s associatedReset clk_reset
set_interface_property s burstOnBurstBoundariesOnly false
set_interface_property s explicitAddressSpan 0
set_interface_property s holdTime 0
set_interface_property s isMemoryDevice false
set_interface_property s isNonVolatileStorage false
set_interface_property s linewrapBursts false
set_interface_property s printableDevice false
set_interface_property s setupTime 0
set_interface_property s timingUnits Cycles
set_interface_property s writeWaitTime 0
set_interface_property s ENABLED true

add_interface_port s slave_write write Input 1
add_interface_port s slave_writedata writedata Input WIDTH_MAX_8
add_interface_port s slave_byteenable byteenable Input 1
add_interface_port s slave_read read Input 1
add_interface_port s slave_readdata readdata Output WIDTH_MAX_8
add_interface_port s slave_waitrequest waitrequest Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point irq
# | 
add_interface my_irq_in interrupt receiver
add_interface_port my_irq_in irq irq Input 1

add_interface my_irq_out interrupt sender
add_interface_port my_irq_out irq_out irq Output 1
# | 
# +-----------------------------------


