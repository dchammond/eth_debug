vlib work
vlib activehdl

vlib activehdl/mii_to_rmii_v2_0_21
vlib activehdl/xil_defaultlib

vmap mii_to_rmii_v2_0_21 activehdl/mii_to_rmii_v2_0_21
vmap xil_defaultlib activehdl/xil_defaultlib

vcom -work mii_to_rmii_v2_0_21 -93 \
"../../../ipstatic/hdl/mii_to_rmii_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../mii_to_rmii_0/sim/mii_to_rmii_0.vhd" \


