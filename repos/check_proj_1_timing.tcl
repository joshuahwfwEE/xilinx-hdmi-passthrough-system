set overlay_name "proj_1"
set design_name "mb_system_bd"

set fd [open ./${overlay_name}/${overlay_name}.runs/post_route_timing_summary.rpt r]
set timing_met 0
while { [gets $fd line] >= 0 } {
    if [string match {All user specified timing constraints are met.} $line]  { 
        set timing_met 1
        break
    }
}
if {$timing_met == 0} {
    puts "ERROR: ${overlay_name} bitstream generation does not meet timing."
    exit 1
}
puts "Timing constraints are met."