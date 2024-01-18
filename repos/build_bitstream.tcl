set overlay_name "hdmi_vdma_passthrough"
set design_name "exdes"
#set outputDir "./output"


#
# STEP#0: define output directory area & open block design
#
set outputDir "./${overlay_name}/${overlay_name}.runs"       
#file mkdir $outputDir

#open_project ./${overlay_name}/${overlay_name}.xpr
#open_bd_design ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd

# STEP#1: run synthesis, report utilization and timing estimates, write checkpoint design

synth_design -top ${design_name}_wrapper -part xcvu19p-fsva3824-2-e -flatten rebuilt  
write_checkpoint -force $outputDir/post_synth
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_power -file $outputDir/post_synth_power.rpt

#
# STEP#2: run placement and logic optimzation, check against the UltraFast methodology checks, report utilization and timing estimates, write checkpoint design
#

opt_design
report_methodology -file $outputDir/post_opt_methodology.rpt
place_design
phys_opt_design
write_checkpoint -force $outputDir/post_place
report_timing_summary -file $outputDir/post_place_timing_summary.rpt

#
# STEP#3: run router, report actual utilization and timing, write checkpoint design, run drc, write verilog and xdc out
#
route_design
write_checkpoint -force $outputDir/post_route
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file $outputDir/post_route_timing.rpt
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -routable_nets -name timing_1
report_clock_utilization -file $outputDir/clock_util.rpt
report_utilization -file $outputDir/post_route_util.rpt
report_power -file $outputDir/post_route_power.rpt
report_drc -file $outputDir/post_imp_drc.rpt
write_verilog -force $outputDir/${design_name}_impl_netlist.v
write_xdc -no_fixed_only -force $outputDir/${design_name}_impl.xdc

#
# STEP#4: generate a bitstream with a prebuilt elf file
# 
import_files -norecurse ./src/sw/uart_bram_test.elf
set_property used_in_simulation 0 [get_files -all ${overlay_name}/${overlay_name}.srcs/sources_1/imports/sw/uart_bram_test.elf]
set_property SCOPED_TO_REF mb_system_bd [get_files -all -of_objects [get_fileset sources_1] {proj_1/proj_1.srcs/sources_1/imports/sw/uart_bram_test.elf}]
set_property SCOPED_TO_CELLS { microblaze_0 } [get_files -all -of_objects [get_fileset sources_1] {proj_1/proj_1.srcs/sources_1/imports/sw/uart_bram_test.elf}]

write_bitstream -force $outputDir/${overlay_name}.bit



