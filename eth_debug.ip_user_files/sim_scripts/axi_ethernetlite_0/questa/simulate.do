onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib axi_ethernetlite_0_opt

do {wave.do}

view wave
view structure
view signals

do {axi_ethernetlite_0.udo}

run -all

quit -force
