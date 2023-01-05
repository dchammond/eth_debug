set code 1

if { [file exists "outputs/eth_debug_post_synth.dcp"] == 1 } {
    set code [catch {
        open_checkpoint "outputs/eth_debug_post_synth.dcp"
    } ]
}

if { ${code} != 0 } {
    source tcl/eth_debug-proj.tcl

    synth_ip [get_ips]

    synth_design -name "eth_debug" -top top -retiming

    report_timing_summary -file "outputs/eth_debug_post_synth_time.rpt"
    report_utilization -file "outputs/eth_debug_post_synth_util.rpt"
    write_checkpoint -file "outputs/eth_debug_post_synth.dcp"
}
