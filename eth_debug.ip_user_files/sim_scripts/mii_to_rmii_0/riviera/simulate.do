onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+mii_to_rmii_0 -L xpm -L mii_to_rmii_v2_0_21 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.mii_to_rmii_0 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {mii_to_rmii_0.udo}

run -all

endsim

quit -force
