source tcl/eth_debug-proj.tcl

; #synth_ip [get_ips]

start_gui

synth_design -name "eth_debug" -top top -rtl -rtl_skip_mlo -keep_equivalent_registers
