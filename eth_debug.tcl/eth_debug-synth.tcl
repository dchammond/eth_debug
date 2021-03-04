source eth_debug.tcl/eth_debug-proj.tcl

synth_ip [get_ips]

synth_design -top top

report_timing_summary -file "outputs/eth_debug_post_synth_time.rpt"
report_utilization -file "outputs/eth_debug_post_synth_util.rpt"
write_checkpoint -file "outputs/eth_debug_post_synth.dcp"
