onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+axi_ethernetlite_0 -L xpm -L axi_lite_ipif_v3_0_4 -L lib_cdc_v1_0_2 -L blk_mem_gen_v8_4_4 -L lib_bmg_v1_0_13 -L fifo_generator_v13_2_5 -L lib_fifo_v1_0_14 -L axi_ethernetlite_v3_0_20 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.axi_ethernetlite_0 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {axi_ethernetlite_0.udo}

run -all

endsim

quit -force
