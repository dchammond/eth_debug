onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+mii_to_rmii_0 -L mii_to_rmii_v2_0_21 -L xil_defaultlib -L secureip -O5 xil_defaultlib.mii_to_rmii_0

do {wave.do}

view wave
view structure

do {mii_to_rmii_0.udo}

run -all

endsim

quit -force
