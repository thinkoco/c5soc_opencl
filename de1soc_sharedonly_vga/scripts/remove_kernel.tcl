#  qsys-script --cmd="set instance instance_name" --script=scripts/remove_kernel.tcl --system-file=system.qsys
package require -exact qsys 12.0

if {[expr ! [info exists instance]]} {
    error "Must use --cmd=\"set instance instance_name \""
}

#set qsys [lindex $args 0]
#set instance [lindex $args 0]

remove_instance $instance

save_system
