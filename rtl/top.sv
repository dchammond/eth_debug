`default_nettype none

module top (
    input  wire  CLK100MHZ,

    input  wire  UART_RXD_IN,
    output wire  UART_TXD_OUT,

    input  wire  UART_RTS_IN,
    output wire  UART_CTS_OUT
);

logic clk_100;

BUFG usr_clk_bufg (
    .I (CLK100MHZ),
    .O (clk_100)
);

localparam int RST_DELAY_CYCLES = 25;
logic [RST_DELAY_CYCLES-1:0] rst_delay = '1;

always_ff @(posedge clk_100) begin
    rst_delay <= rst_delay >> 1;
end

logic board_rst;

assign board_rst = rst_delay[0];

logic uart_rxd_in;
logic uart_rts_in;
(* ASYNC_REG = "true" *) logic [4-1:0] uart_rxd_in_ff;
(* ASYNC_REG = "true" *) logic [4-1:0] uart_rts_in_ff;

IBUF #(
    .IBUF_LOW_PWR ("FALSE")
) uart_rxd_ibuf (
    .I (UART_RXD_IN),
    .O (uart_rxd_in)
);

IBUF #(
    .IBUF_LOW_PWR ("FALSE")
) uart_rts_ibuf (
    .I (UART_RTS_IN),
    .O (uart_rts_in)
);

always_ff @(posedge clk_100) begin
    uart_rxd_in_ff <= {uart_rxd_in_ff[2], uart_rxd_in_ff[1], uart_rxd_in_ff[0], uart_rxd_in};
    uart_rts_in_ff <= {uart_rts_in_ff[2], uart_rts_in_ff[1], uart_rts_in_ff[0], uart_rts_in};
end

logic uart_txd_out;
logic uart_cts_out;

OBUF #(
    .DRIVE (12),
    .SLEW  ("SLOW")
) uart_tdx_obuf (
    .I (uart_txd_out),
    .O (UART_TXD_OUT)
);

OBUF #(
    .DRIVE (12),
    .SLEW  ("SLOW")
) uart_cts_obuf (
    .I (uart_cts_out),
    .O (UART_CTS_OUT)
);

logic [8-1:0] uart_loop_data;
logic         uart_loop_valid;
logic         uart_loop_ready;

uart_tx #(
    .CLK_FREQ_HZ   (100 * 1000 * 1000),
    .BAUD_RATE     (2 * 1000 * 1000)
) uart_tx (
    .clk           (clk_100),
    .rst           (board_rst),

    .byte_in_data  (uart_loop_data),
    .byte_in_valid (uart_loop_valid),
    .byte_in_ready (uart_loop_ready),

    .bit_out       (uart_txd_out)
);

uart_rx #(
    .CLK_FREQ_HZ    (100 * 1000 * 1000),
    .BAUD_RATE      (2 * 1000 * 1000)
) uart_rx (
    .clk            (clk_100),
    .rst            (board_rst),

    .bit_in         (uart_rxd_in_ff[3]),

    .byte_out_data  (uart_loop_data),
    .byte_out_valid (uart_loop_valid),
    .byte_out_ready (uart_loop_ready)
);

ila_uart_rx i_ila (
    .clk    (clk_100),

    .probe0 (uart_loop_ready),
    .probe1 (uart_loop_valid),
    .probe2 (uart_loop_data),
    .probe3 (uart_txd_out)
);

endmodule
