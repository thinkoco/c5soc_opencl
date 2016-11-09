#============================================================
# Modify settings for iface import
#   Assumes partition name "acl_iface_partition" and existence
#   of a region acl_iface_region.  Any other regions used with
#   the acl_iface_system should be specified by name as 
#   arguments to this script.
#
#   E.g.
#     quartus_sh -t scripts/enable_import.tcl ddr3a_region
#============================================================
# Args: region2_name ...

# Required packages
package require ::quartus::project


# Default names of iface region and partition
set iface_partition "acl_iface_partition"
set iface_region "acl_iface_region"

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

post_message "Configuring partition $iface_partition for import"
set_global_assignment -name PARTITION_NETLIST_TYPE POST_FIT -section_id "$iface_partition"
set_global_assignment -name PARTITION_IGNORE_SOURCE_FILE_CHANGES ON -section_id "$iface_partition"
set_global_assignment -name PARTITION_IMPORT_FILE "$iface_partition.qxp" -section_id "$iface_partition"
set_global_assignment -name POST_MODULE_SCRIPT_FILE "quartus_cdb:scripts/post_module.tcl"

post_message "Disabled LogicLock Region $iface_region"
set_global_assignment -name LL_ENABLED OFF -section_id "$iface_region"

for {set i 0} {$i < $argc} {incr i} {
   set r [lindex $argv $i]

   post_message "Disabled LogicLock Region $r"
   set_global_assignment -name LL_ENABLED OFF -section_id "$r"

}

post_message "Removing FORM_DDR_CLUSTERING_CLIQUE assignments"
remove_all_instance_assignments -name FORM_DDR_CLUSTERING_CLIQUE

post_message "Removing AUTO_EXPORT_INCREMENTAL_COMPILATION assignments"
remove_all_global_assignments -name AUTO_EXPORT_INCREMENTAL_COMPILATION

project_close
