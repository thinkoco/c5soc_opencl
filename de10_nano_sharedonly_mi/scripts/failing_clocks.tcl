# (C) 1992-2018 Intel Corporation.                            
# Intel, the Intel logo, Intel, MegaCore, NIOS II, Quartus and TalkBack words    
# and logos are trademarks of Intel Corporation or its subsidiaries in the U.S.  
# and/or other countries. Other marks and brands may be claimed as the property  
# of others. See Trademarks on intel.com for full list of Intel trademarks or    
# the Trademarks & Brands Names Database (if Intel) or See www.Intel.com/legal (if Altera) 
# Your use of Intel Corporation's design tools, logic functions and other        
# software and tools, and its AMPP partner logic functions, and any output       
# files any of the foregoing (including device programming or simulation         
# files), and any associated documentation or information are expressly subject  
# to the terms and conditions of the Altera Program License Subscription         
# Agreement, Intel MegaCore Function License Agreement, or other applicable      
# license agreement, including, without limitation, that your use is for the     
# sole purpose of programming logic devices manufactured by Intel and sold by    
# Intel or its authorized distributors.  Please refer to the applicable          
# agreement for further details.                                                 

# Report whether a design has clock domains with negative slack.
# If there are clock domains with negative slack, put that information into
# a table and write it out to a file.

# Change the filename here if appropriate
set output_file_name [get_current_project].failing_clocks.rpt

package require struct::matrix
package require report

# Create a matrix to hold information about the failing paths
set failing_paths_matrix [::struct::matrix];
$failing_paths_matrix add columns 5

# Analysis has to be performed for all operating conditions
set all_operating_conditions_col [get_available_operating_conditions]

# Perform these types of analysis for each clock domain
set analysis_list [list "setup" "hold" "recovery" "removal"]
   
# Walk through all operating conditions
foreach_in_collection operating_conditions_obj $all_operating_conditions_col {

    # Set the operating condition, update the timing netlist
    set_operating_conditions $operating_conditions_obj
    update_timing_netlist
   
    # Get the English-text name of the operating conditions
    set operating_conditions_display_name \
        [get_operating_conditions_info -display_name $operating_conditions_obj]
       
    # Do every type of analysis
    foreach analysis_type $analysis_list {
   
        # Get the name of the analysis type if we have to print it
        set analysis_display_name [string totitle $analysis_type]
       
        # Get information about all the clock domains
        set clock_domain_info_list [get_clock_domain_info -${analysis_type}]
       
        # Walk through all the clock domains and pull out any that have
        # negative slack
        foreach domain_info $clock_domain_info_list {
       
            # The domain_info has the clock name, its slack, and its TNS.
            # Extract those.
            foreach { clock_name slack endpoint_tns edge_tns } $domain_info \
                { break }
               
            # If the slack is negative, put together a row of information to
            # report in the table
            if { 0 > $slack } {
           
                $failing_paths_matrix add row \
                    [list $slack $endpoint_tns $clock_name \
                    $operating_conditions_display_name $analysis_display_name]

                report_timing -to_clock "$clock_name" -${analysis_type} -npaths 5 -detail full_path -panel_name {$clock_name $analysis_display_name $operating_conditions_display_name} -file "[get_current_project].failing_paths.rpt" -append
            }
        }
        # Finished going through all the clock domains for a particular
        # timing analysis (setup, hold, etc.)
    }
    # Finished going through all the analysis types for a particular operating
    # condition
}
# Finished going through all the operating conditions

# Prepare to write out a file with the results summary
   
# If there are any rows in the matrix, there are paths that are failing timing.
# We have to print out the table with that information. If there are no
# rows in the table, no paths fail timing, so write out a success message
if { 0 == [$failing_paths_matrix  rows] } {

        # Print out a quick message
        post_message "There are no clock domains failing timing"

    } else {
        # Sort the matrix rows so the worst slack is first
        $failing_paths_matrix sort rows -increasing 0
        
        # Put in a header row
        $failing_paths_matrix  insert row 0 \
               [list   "Slack" "End Point TNS" "Clock" \
               "Operating conditions" "Timing analysis" ]
        #   We need a style defined to print out the table of results
        catch { ::report::rmstyle basicrpt }
        ::report::defstyle  basicrpt {{cap_rows 1}} {
        data                set        [split "[string repeat "; " [columns]];"]
        top                  set         [split "[string repeat "+ - " [columns]]+"]
        bottom           set         [top get] 
        topcapsep    set         [top get]
        topdata          set         [data get]
        top enable         
        topcapsep enable   
        bottom   enable      
        tcaption $cap_rows    }
    # Create the report, set the columns to have one space of padding, and
        # print out the matrix with the specified format
        catch { r destroy }
        ::report::report r 5 style basicrpt
        for    { set col 0 } { $col <  [r columns]} { incr col } {
        r pad $col both " "
    }
    post_message "Clock domains failing timing\n[r printmatrix $failing_paths_matrix]"
   
    # Save the report to a file
    if { [catch { open $output_file_name w } fh] } {
        post_message -type error "Couldn't open file: $fh"
    } else {
        puts $fh "Clock domains failing timing"
        r printmatrix2channel $failing_paths_matrix $fh
        catch { close $fh }
    }
}
