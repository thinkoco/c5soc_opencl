#============================================================
# Export iface partition in qxp format
#
#   E.g.
#     quartus_sh -t scripts/export_iface.tcl 
#============================================================


# Required packages
package require ::quartus::project
package require ::quartus::flow


# Default names of iface region and partition
set iface_partition "acl_iface_partition"

# Dynamically determine the project name by finding the qsf in the directory.
set qsf_files [glob -nocomplain *.qsf]

if {[llength $qsf_files] == 0} {
    error "No QSF detected"
} elseif {[llength $qsf_files] > 1} {
    post_message "Warning: More than one QSF detected. Picking the first one."
}

set qsf_file [lindex $qsf_files 0]
set project_name [string range $qsf_file 0 [expr [string first . $qsf_file] - 1]]

post_message "Project name: $project_name"

project_open $project_name


execute_module -tool cdb -args "--incremental_compilation_export=$iface_partition.qxp --incremental_compilation_export_partition_name=$iface_partition --incremental_compilation_export_post_synth=on --incremental_compilation_export_post_fit=on --incremental_compilation_export_routing=on"

post_message "**********************************************"
post_message "Successfully exported to: $iface_partition.qxp"
post_message "**********************************************"

project_close
