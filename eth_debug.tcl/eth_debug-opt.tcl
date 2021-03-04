source eth_debug.tcl/eth_debug-synth.tcl

opt_design

report_timing_summary -file "outputs/eth_debug_post_opt_time.rpt"
report_utilization -file "outputs/eth_debug_post_opt_util.rpt"
write_checkpoint -file "outputs/eth_debug_post_opt.dcp"
