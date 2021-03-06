set code 1

if { [file exists "outputs/eth_debug_post_opt.dcp"] == 1 } {
    set code [catch {
        open_checkpoint "outputs/eth_debug_post_opt.dcp"
    } ]
}

if {$code != 0} {
    source eth_debug.tcl/eth_debug-synth.tcl

    opt_design

    report_timing_summary -file "outputs/eth_debug_post_opt_time.rpt"
    report_utilization -file "outputs/eth_debug_post_opt_util.rpt"
    write_checkpoint -file "outputs/eth_debug_post_opt.dcp"
}
