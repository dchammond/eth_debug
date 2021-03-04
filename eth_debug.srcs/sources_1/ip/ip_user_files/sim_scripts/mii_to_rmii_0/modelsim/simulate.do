onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L mii_to_rmii_v2_0_21 -L xil_defaultlib -L secureip -lib xil_defaultlib xil_defaultlib.mii_to_rmii_0

do {wave.do}

view wave
view structure
view signals

do {mii_to_rmii_0.udo}

run -all

quit -force
