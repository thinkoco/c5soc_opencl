# load required packages
load_package flow

#Get args
set module [lindex $quartus(args) 0]
set top [lindex $quartus(args) 1]

post_message "Running post_module.tcl script"

if [string match "quartus_map" $module] {
  if { ![file exists acl_iface_partition.qxp] }  {
    post_message "Skipping import since acl_iface_partition.qxp not found"
  } else {
    load_package incremental_compilation
    load_package project

    post_message "Running QXP import on project $top"

    # open project
    project_open $top

    # command to execute import
    execute_flow -incremental_compilation_import
  }
}
