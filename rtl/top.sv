`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2021 12:41:47 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input        clk_i,
    input  [1:0] sw,
    output [3:0] led,
    output       PhyRstn,
    input        PhyCrs,
    input        PhyRxErr,
    input  [1:0] PhyRxd,
    output       PhyTxEn,
    output [1:0] PhyTxd,
    input        PhyClk50Mhz,
    input        UartRxdDebug,
    output       UartTxdDebug,
    input        UartRxdEth,
    output       UartTxdEth
);

logic rst = sw[0];

assign led[0] = 1'b1;
assign led[1] = 1'b0;
assign led[2] = rst;

logic [$bits(10000000)-1:0] cnt_q;
logic led3_q;

assign led[3] = led3_q;

always_ff @(posedge clk_i) begin
    cnt_q <= cnt_q + 1;
    if(cnt_q == 10000000) begin
        cnt_q <= '0;
    end
    if(rst) begin
        cnt_q <= '0;
        led3_q <= 1'b0;
    end
    if(!cnt_q) begin
        led3_q <= ~led3_q;
    end
end

logic [3:0] rmii2mac_rxd;
logic [3:0] mac2rmii_txd;
logic mac2rmii_tx_er, mac2rmii_tx_en;
logic rmii2mac_rx_er, rmii2mac_rx_dv, rmii2mac_crs, rmii2mac_col, rmii2mac_rx_clk, rmii2mac_tx_clk;
logic mac2rmii_rst_n;

assign PhyRstn = mac2rmii_rst_n;

assign mac2rmii_tx_er = 1'b0;

mii_to_rmii_0 mii_to_rmii(
    .rst_n           (mac2rmii_rst_n),
    .ref_clk         (PhyClk50Mhz),
    .mac2rmii_tx_en  (mac2rmii_tx_en),
    .mac2rmii_txd    (mac2rmii_txd),
    .mac2rmii_tx_er  (mac2rmii_tx_er),
    .rmii2mac_tx_clk (rmii2mac_tx_clk),
    .rmii2mac_rx_clk (rmii2mac_rx_clk),
    .rmii2mac_col    (rmii2mac_col),
    .rmii2mac_crs    (rmii2mac_crs),
    .rmii2mac_rx_dv  (rmii2mac_rx_dv),
    .rmii2mac_rx_er  (rmii2mac_rx_er),
    .rmii2mac_rxd    (rmii2mac_rxd),
    .phy2rmii_crs_dv (PhyCrs),
    .phy2rmii_rx_er  (PhyRxErr),
    .phy2rmii_rxd    (PhyRxd),
    .rmii2phy_txd    (PhyTxd),
    .rmii2phy_tx_en  (PhyTxEn)
);

logic [31:0] eth_frame_q;
logic        eth_frame_vld_q;

eth_over_uart
#(
    .CLK_FREQ_HZ (100000000),
    .BAUD_RATE   (460800)
)
uart_eth
(
    .clk_i            (clk_i),
    .rst_i            (rst),
    .eth_chunk_i      (eth_frame_q),
    .eth_chunk_vld_i  (eth_frame_vld_q),
    .uart_rxd_i       (UartRxdEth),
    .uart_txd_o       (UartTxdEth)
);

logic [ 7:0] uart_byte_q;
logic        uart_byte_vld_q;
logic        done_tx_q;

uart
#(
    .CLK_FREQ_HZ (100000000),
    .BAUD_RATE   (460800)
)
uart_debug
(
    .clk_i          (clk_i),
    .rst_i          (rst),
    .uart_rxd_i     (UartRxdDebug),
    .uart_txd_o     (UartTxdDebug),
    .byte_tx_i      (uart_byte_q),
    .byte_tx_vld_i  (uart_byte_vld_q),
    .do_tx_i        (uart_byte_vld_q),
    .done_tx_o      (done_tx_q),
    .byte_rx_o      (uart_byte_q),
    .byte_rx_vld_o  (uart_byte_vld_q)
);

logic [12:0] s_axi_awaddr;
logic s_axi_awvalid;
logic s_axi_awready;
logic [31:0] s_axi_wdata;
logic [ 3:0] s_axi_wstrb;
logic s_axi_wvalid;
logic s_axi_wready;
logic [ 1:0] s_axi_bresp;
logic s_axi_bvalid;
logic s_axi_bready;
logic [12:0] s_axi_araddr;
logic s_axi_arvalid;
logic s_axi_arready;
logic [31:0] s_axi_rdata;
logic [ 1:0] s_axi_rresp;
logic s_axi_rvalid;
logic s_axi_rready;

read_eth_frame ping_pong(
    .s_axi_aclk_i     (clk_i),
    .s_axi_aresetn_i  (~rst),
    .s_axi_awaddr_o   (s_axi_awaddr),
    .s_axi_awvalid_o  (s_axi_awvalid),
    .s_axi_awready_i  (s_axi_awready),
    .s_axi_wdata_o    (s_axi_wdata),
    .s_axi_wstrb_o    (s_axi_wstrb),
    .s_axi_wvalid_o   (s_axi_wvalid),
    .s_axi_wready_i   (s_axi_wready),
    .s_axi_bresp_i    (s_axi_bresp),
    .s_axi_bvalid_i   (s_axi_bvalid),
    .s_axi_bready_o   (s_axi_bready),
    .s_axi_araddr_o   (s_axi_araddr),
    .s_axi_arvalid_o  (s_axi_arvalid),
    .s_axi_arready_i  (s_axi_arready),
    .s_axi_rdata_i    (s_axi_rdata),
    .s_axi_rresp_i    (s_axi_rresp),
    .s_axi_rvalid_i   (s_axi_rvalid),
    .s_axi_rready_o   (s_axi_rready),
    .eth_frame_data_o (eth_frame_q),
    .eth_frame_vld_o  (eth_frame_vld_q)
);

axi_ethernetlite_0 eth(
    .s_axi_aclk    (clk_i),
    .s_axi_aresetn (~rst),
    .ip2intc_irpt  (/* ? */),
    .s_axi_awaddr  (s_axi_awaddr),
    .s_axi_awvalid (s_axi_awvalid),
    .s_axi_awready (s_axi_awready),
    .s_axi_wdata   (s_axi_wdata),
    .s_axi_wstrb   (s_axi_wstrb),
    .s_axi_wvalid  (s_axi_wvalid),
    .s_axi_wready  (s_axi_wready),
    .s_axi_bresp   (s_axi_bresp),
    .s_axi_bvalid  (s_axi_bvalid),
    .s_axi_bready  (s_axi_bready),
    .s_axi_araddr  (s_axi_araddr),
    .s_axi_arvalid (s_axi_arvalid),
    .s_axi_arready (s_axi_arready),
    .s_axi_rdata   (s_axi_rdata),
    .s_axi_rresp   (s_axi_rresp),
    .s_axi_rvalid  (s_axi_rvalid),
    .s_axi_rready  (s_axi_rready),
    .phy_tx_clk    (rmii2mac_tx_clk),
    .phy_rx_clk    (rmii2mac_rx_clk),
    .phy_crs       (rmii2mac_crs),
    .phy_dv        (rmii2mac_rx_dv),
    .phy_rx_data   (rmii2mac_rxd),
    .phy_col       (rmii2mac_col),
    .phy_rx_er     (rmii2mac_rx_er),
    .phy_rst_n     (mac2rmii_rst_n),
    .phy_tx_en     (mac2rmii_tx_en),
    .phy_tx_data   (mac2rmii_txd)
);

endmodule
