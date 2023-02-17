set code 1

if { [file exists "outputs/eth_debug_post_opt.dcp"] == 1 } {
    set code [catch {
        open_checkpoint "outputs/eth_debug_post_opt.dcp"
    } ]
}

if {$code != 0} {
    source tcl/eth_debug-synth.tcl

    source tcl/pathcutter.sdc
    source tcl/synchronizer.sdc

    opt_design

    report_timing_summary -file "outputs/eth_debug_post_opt_time.rpt"
    report_utilization -file "outputs/eth_debug_post_opt_util.rpt"
    write_checkpoint -file "outputs/eth_debug_post_opt.dcp"
}
