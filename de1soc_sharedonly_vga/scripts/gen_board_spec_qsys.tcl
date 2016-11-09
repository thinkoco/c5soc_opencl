# qsys-script --script=../scripts/gen_board_spec_qsys.tcl --system-file=acl_iface_system.qsys

package require -exact qsys 12.1

set mem_divider_inst 0
set kernel_if_inst 0
set kernel_clk_inst 0

# Search for required ACL components by class name (not instance name)
set instances [get_instances]
foreach i $instances {
  send_message info "Class name of $i is [get_instance_property $i CLASS_NAME]"
  if { [string equal [get_instance_property $i CLASS_NAME] acl_memory_bank_divider ]} {
    set mem_divider_inst $i
    send_message info "Found acl_memory_bank_divider"
  } elseif { [string equal [get_instance_property $i CLASS_NAME] acl_kernel_interface ]} {
    set kernel_if_inst $i
    send_message info "Found acl_kernel_interface"
  } elseif { [string equal [get_instance_property $i CLASS_NAME] acl_kernel_clk ]} {
    set kernel_clk_inst $i
    send_message info "Found acl_kernel_clk"
  }
}

if { $mem_divider_inst==0 || $kernel_if_inst==0 || $kernel_clk_inst==0} {
  send_message error "Missing key ACL components"
  exit 1
}

###################################################################
##################  Analyze Qsys Interfaces  ######################
###################################################################

set banks [get_instance_parameter_value acl_memory_bank_divider_0 NUM_BANKS]
set data_width [get_instance_parameter_value acl_memory_bank_divider_0 DATA_WIDTH]
set burst_size [get_instance_parameter_value acl_memory_bank_divider_0 BURST_SIZE]
send_message info "mem banks width burst = $banks $data_width $burst_size"

set interleaved_bytes [expr $data_width / 8 * $burst_size]
send_message info "interleaved_bytes = $interleaved_bytes"

set kernel_cra_addr_width [get_instance_interface_port_property kernel_interface kernel_cra kernel_cra_address WIDTH]
send_message info "Kernel cra addr width = $kernel_cra_addr_width"

set snoop_width [get_instance_interface_port_property acl_memory_bank_divider_0 acl_bsp_snoop acl_bsp_snoop_data WIDTH]
send_message info "Snoop width = $snoop_width"

