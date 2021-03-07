source eth_debug.tcl/eth_debug-opt.tcl

place_design

report_timing_summary -file "outputs/eth_debug_post_place_time.rpt"
report_utilization -file "outputs/eth_debug_post_place_util.rpt"
write_checkpoint -file "outputs/eth_debug_post_place.dcp"

phys_opt_design

report_timing_summary -file "outputs/eth_debug_post_physopt_time.rpt"
report_utilization -file "outputs/eth_debug_post_physopt_util.rpt"
write_checkpoint -file "outputs/eth_debug_post_physopt.dcp"

route_design

report_bus_skew -file "outputs/eth_debug_post_route_skew.rpt"
report_timing_summary -file "outputs/eth_debug_post_route_time.rpt"
report_utilization -hierarchical -file "outputs/eth_debug_post_route_util.rpt"
report_route_status -file "outputs/eth_debug_post_route_status.rpt"
report_io -file "outputs/eth_debug_post_route_io.rpt"
report_power -file "outputs/eth_debug_post_route_power.rpt"
report_design_analysis -logic_level_distribution \
    -of_timing_paths [get_timing_paths -max_paths 10000 -slack_lesser_than 0] \
    -file "outputs/eth_debug_post_route_analysis.rpt"
write_checkpoint -file "outputs/eth_debug_post_route.dcp"

set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
puts "Post Route WNS = $WNS"
