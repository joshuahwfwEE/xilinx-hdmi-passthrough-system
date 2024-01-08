###############################################################################
 #  Copyright (c) 2020, Xilinx
 #  All rights reserved.
 # 
 # This program is free software; distributed under the terms of BSD 3-clause 
 # license ("Revised BSD License", "New BSD License", or "Modified BSD License")
 #
 # Redistribution and use in source and binary forms, with or without
 # modification, are permitted provided that the following conditions are met:
 #
 # * Redistributions of source code must retain the above copyright notice, this
 #   list of conditions and the following disclaimer.
 #
 # * Redistributions in binary form must reproduce the above copyright notice,
 #   this list of conditions and the following disclaimer in the documentation
 #   and/or other materials provided with the distribution.
 #
 # * Neither the name of the copyright holder nor the names of its
 #   contributors may be used to endorse or promote products derived from
 #   this software without specific prior written permission.
 #
 #  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 #  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 #  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 #  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 #  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 #  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 #  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 #  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 #  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 #  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 #
###############################################################################
 # @file create_proj.tcl
 #  Author: Florent Werbrouck
 #	Tcl script for re-creating project Video Series 4
 # 
 #
###############################################################################
################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version "2018.1 2018.2 2018.3 2019.1 2019.2 2020.1 2021.1 2022.2"
set current_vivado_version [version -short]
 
if { [string first $current_vivado_version $scripts_vivado_version] == -1 } {
   puts "The version $current_vivado_version is not supported"
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}
 
   return 1
}

# Configuration - Can be modified by the user
set project_name 				hdmi_passthrough_vdma_aud
set BD_name 					exdes

# Create a new project
create_project $project_name ./$project_name -part xcvu19p-fsva3824-2-e
set_property target_language Verilog [current_project]

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
# Add hdl files
read_verilog [ glob ./src/hdl/*.v ]
read_verilog -sv [ glob ./src/hdl/*.sv ]
read_vhdl [ glob ./src/hdl/*.vhd ]

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset -quiet constrs_1
}
# Add constraint files
read_xdc ./src/constr/hdmi_mgb2.xdc

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}
# Add simulation files
add_files -fileset sim_1 -norecurse -scan_for_includes ./src/sim
import_files -fileset sim_1 -norecurse ./src/sim


# Add ip repository
#set_property  ip_repo_paths  ./src/ip_repo [current_project]
#update_ip_catalog

set design_name 	$BD_name


#  Build the Block Design
#  Build the Block Design
  if { [string first $current_vivado_version "2018.1 2018.2"] != -1 } {
    source ./src/tcl/bd.tcl
  } elseif { [string first $current_vivado_version "2018.3 2019.1 2019.2 2020.1 2022.2"] != -1 } {
    source ./src/tcl/exdes.tcl
  } else {
   source ./src/tcl/exdes.tcl
  }

# Validate the BD
regenerate_bd_layout
validate_bd_design 
save_bd_design

#Generate the wrapper
make_wrapper -files [get_files ${BD_name}.bd] -top

# Add the wrapper to the fileset
set obj [get_filesets sources_1]
if { [string first $current_vivado_version "2022.2"] != -1 } {
	set files [list "[file normalize [glob "./$project_name/$project_name.gen/sources_1/bd/$BD_name/hdl/${BD_name}_wrapper.v"]]"]
} else {
	set files [list "[file normalize [glob "./$project_name/$project_name.srcs/sources_1/bd/$BD_name/hdl/${BD_name}_wrapper.v"]]"]
}
add_files -norecurse -fileset $obj $files

# Generate the output products
generate_target all [get_files ./$project_name/$project_name.srcs/sources_1/bd/$BD_name/${BD_name}.bd]
create_ip_run [get_files -of_objects [get_fileset sources_1] ./$project_name/$project_name.srcs/sources_1/bd/$BD_name/${BD_name}.bd]
launch_runs -jobs 8 [get_runs $BD_name*synth_1]

update_compile_order -fileset sources_1