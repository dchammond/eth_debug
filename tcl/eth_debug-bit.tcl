source tcl/eth_debug-pnr.tcl

set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
set BUILD_DATE [ clock format [ clock seconds ] -format %m%d%Y ]
set BUILD_TIME [ clock format [ clock seconds ] -format %H%M%S ]

write_bitstream -force "eth_debug_${BUILD_DATE}_${BUILD_TIME}_${WNS}.bit"
write_debug_probes -quiet -force "eth_debug_${BUILD_DATE}_${BUILD_TIME}_${WNS}.ltx"
