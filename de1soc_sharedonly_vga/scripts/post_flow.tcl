
package require ::quartus::flow
package require ::quartus::project

post_message "Running post-flow script"

# Dynamically determine the project name by finding the qpf in the directory.
set qpf_files [glob -nocomplain *.qpf]

if {[llength $qpf_files] == 0} {
    error "No QSF detected"
} elseif {[llength $qpf_files] > 1} {
    post_message "Warning: More than one QSF detected. Picking the first one."
}

set qpf_file [lindex $qpf_files 0]
set project_name [string range $qpf_file 0 [expr [string first . $qpf_file] - 1]]

post_message "Project name: $project_name"

# Run PLL adjust script
post_message "Running PLL adjustment script"
if {[catch {qexec "quartus_cdb -t iface/ip/bsp/adjust_plls.tcl"} res]} {
  post_message -type error "Error in adjust_plls.tcl! $res"
  exit 2
}

# Generate fpga.bin used for reprogramming
post_message "Generating fpga.bin from top.rbf"
set argv [list top.rbf]
if {[catch {source scripts/create_fpga_bin.tcl} res]} {
  post_message -type error "Error in create_fpga_bin.tcl! $res"
  exit 2
}

