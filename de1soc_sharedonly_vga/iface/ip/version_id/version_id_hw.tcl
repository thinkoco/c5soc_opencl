# +-----------------------------------
# | 
# | version_id 
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 11.0
# | 
package require -exact sopc 10.0
# | 
# +-----------------------------------

# +-----------------------------------
# | module version_id
# | 
set_module_property DESCRIPTION "Hardcoded version ID"
set_module_property NAME version_id
set_module_property VERSION 10.0
set_module_property GROUP "ACL Internal Components"
set_module_property AUTHOR "Altera OpenCL"
set_module_property DISPLAY_NAME "ACL Version ID Component"
set_module_property TOP_LEVEL_HDL_FILE version_id.v
set_module_property TOP_LEVEL_HDL_MODULE version_id
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file version_id.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter WIDTH INTEGER 32
set_parameter_property WIDTH DEFAULT_VALUE 32
set_parameter_property WIDTH DISPLAY_NAME "Slave Width"
set_parameter_property WIDTH UNITS "bits" 
set_parameter_property WIDTH AFFECTS_ELABORATION true
set_parameter_property WIDTH HDL_PARAMETER true

add_parameter VERSION_ID INTEGER 0
set_parameter_property VERSION_ID DEFAULT_VALUE 0
set_parameter_property VERSION_ID DISPLAY_NAME "Version ID (integer):"
set_parameter_property VERSION_ID AFFECTS_ELABORATION true
set_parameter_property VERSION_ID HDL_PARAMETER true
#set_parameter_property VERSION_ID DERIVED true
#set_parameter_property VERSION_ID VISIBLE false

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
set_interface_property s ENABLED true

add_interface_port s slave_read read Input 1
add_interface_port s slave_readdata readdata Output WIDTH
# | 
# +-----------------------------------
