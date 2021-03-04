source eth_debug.tcl/eth_debug-pnr.tcl

set BUILD_DATE [ clock format [ clock seconds ] -format %m%d%Y ]
set BUILD_TIME [ clock format [ clock seconds ] -format %H%M%S ]

write_bitstream -force "eth_debug_${BUILD_DATE}_${BUILD_TIME}_${WNS}.bit"
