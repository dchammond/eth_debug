vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/mii_to_rmii_v2_0_21
vlib questa_lib/msim/xil_defaultlib

vmap mii_to_rmii_v2_0_21 questa_lib/msim/mii_to_rmii_v2_0_21
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vcom -work mii_to_rmii_v2_0_21 -64 -93 \
"../../../ipstatic/hdl/mii_to_rmii_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../mii_to_rmii_0/sim/mii_to_rmii_0.vhd" \


