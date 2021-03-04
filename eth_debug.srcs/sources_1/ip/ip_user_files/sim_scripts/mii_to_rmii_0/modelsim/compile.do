vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/mii_to_rmii_v2_0_21
vlib modelsim_lib/msim/xil_defaultlib

vmap mii_to_rmii_v2_0_21 modelsim_lib/msim/mii_to_rmii_v2_0_21
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vcom -work mii_to_rmii_v2_0_21 -64 -93 \
"../../../ipstatic/hdl/mii_to_rmii_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../mii_to_rmii_0/sim/mii_to_rmii_0.vhd" \


