-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
-- Date        : Wed Mar  3 21:06:41 2021
-- Host        : dillon-arch running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub
--               /home/dillon/git/eth_debug/eth_debug.srcs/sources_1/ip/mii_to_rmii_0/mii_to_rmii_0_stub.vhdl
-- Design      : mii_to_rmii_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mii_to_rmii_0 is
  Port ( 
    rst_n : in STD_LOGIC;
    ref_clk : in STD_LOGIC;
    mac2rmii_tx_en : in STD_LOGIC;
    mac2rmii_txd : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mac2rmii_tx_er : in STD_LOGIC;
    rmii2mac_tx_clk : out STD_LOGIC;
    rmii2mac_rx_clk : out STD_LOGIC;
    rmii2mac_col : out STD_LOGIC;
    rmii2mac_crs : out STD_LOGIC;
    rmii2mac_rx_dv : out STD_LOGIC;
    rmii2mac_rx_er : out STD_LOGIC;
    rmii2mac_rxd : out STD_LOGIC_VECTOR ( 3 downto 0 );
    phy2rmii_crs_dv : in STD_LOGIC;
    phy2rmii_rx_er : in STD_LOGIC;
    phy2rmii_rxd : in STD_LOGIC_VECTOR ( 1 downto 0 );
    rmii2phy_txd : out STD_LOGIC_VECTOR ( 1 downto 0 );
    rmii2phy_tx_en : out STD_LOGIC
  );

end mii_to_rmii_0;

architecture stub of mii_to_rmii_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "rst_n,ref_clk,mac2rmii_tx_en,mac2rmii_txd[3:0],mac2rmii_tx_er,rmii2mac_tx_clk,rmii2mac_rx_clk,rmii2mac_col,rmii2mac_crs,rmii2mac_rx_dv,rmii2mac_rx_er,rmii2mac_rxd[3:0],phy2rmii_crs_dv,phy2rmii_rx_er,phy2rmii_rxd[1:0],rmii2phy_txd[1:0],rmii2phy_tx_en";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "mii_to_rmii,Vivado 2020.2";
begin
end;
