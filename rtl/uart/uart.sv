`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2021 12:18:23 AM
// Design Name: 
// Module Name: uart
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


module uart_tx
#(
    parameter int TICKS_PER_BIT = 2
)
(
    input               clk_i,
    input               rst_i,
    output logic        uart_txd_o,
    input  logic [ 7:0] byte_tx_i,
    input  logic        byte_tx_vld_i,
    input  logic        do_tx_i,
    output logic        done_tx_o
);

typedef enum bit [1:0] {
    IDLE,
    START,
    DATA,
    STOP
} state_t;

state_t state_d, state_q;

logic [ 7:0] byte_tx_d, byte_tx_q;
logic        uart_txd_d, uart_txd_q;
logic        done_tx_d, done_tx_q;

logic [$ceil($clog2(TICKS_PER_BIT))-1:0] tick_counter_d, tick_counter_q;
logic [ 7:0] bit_mask_d, bit_mask_q;

assign uart_txd_o = uart_txd_q;
assign done_tx_o  = done_tx_q;

always_comb begin
    uart_txd_d     = 1'b1; // IDLE is high
    tick_counter_d = tick_counter_q;
    done_tx_d      = 1'b0;
    bit_mask_d     = bit_mask_q;
    byte_tx_d      = byte_tx_q;
    state_d        = state_q;
    unique case(state_q)
    IDLE : begin
        if(byte_tx_vld_i) begin
            byte_tx_d = byte_tx_i;
        end
        if(do_tx_i) begin
            tick_counter_d = '0;
            bit_mask_d     = 8'hFF;
            state_d        = START;
        end
    end
    START : begin
        uart_txd_d      = 1'b0;
        tick_counter_d += 1;
        if(tick_counter_q == TICKS_PER_BIT - 1) begin
            tick_counter_d = '0;
            state_d        = DATA;
        end
    end
    DATA : begin
        uart_txd_d      = byte_tx_q[0];
        tick_counter_d += 1;
        if(tick_counter_q == TICKS_PER_BIT - 1) begin
            tick_counter_d = '0;
            bit_mask_d     = bit_mask_q >> 1;
            byte_tx_d      = byte_tx_q >> 1;
            if(bit_mask_q == 8'b1) begin
                state_d = STOP;
            end
        end
    end
    STOP : begin
        tick_counter_d += 1;
        if(tick_counter_q == TICKS_PER_BIT - 1) begin
            done_tx_d = 1'b1;
            state_d   = IDLE;
        end
    end
    endcase
end

always_ff @(posedge clk_i) begin
    state_q        <= state_d;
    byte_tx_q      <= byte_tx_d;
    uart_txd_q     <= uart_txd_d;
    bit_mask_q     <= bit_mask_d;
    tick_counter_q <= tick_counter_d;
    done_tx_q      <= done_tx_d;
    if(rst_i) begin
        state_q <= IDLE;
    end
end

endmodule

module uart_rx
#(
    parameter int TICKS_PER_BIT = 2
)
(
    input               clk_i,
    input               rst_i,
    input  wire         uart_rxd_i,
    output logic [ 7:0] byte_rx_o,
    output logic        byte_rx_vld_o
);

typedef enum bit [1:0] {
    IDLE,
    START,
    DATA,
    STOP
} state_t;

state_t state_d, state_q;

logic [$ceil($clog2(TICKS_PER_BIT))-1:0] tick_counter_d, tick_counter_q;
logic [ 7:0] bit_mask_d, bit_mask_q;

logic [ 7:0] byte_rx_d, byte_rx_q;
logic        byte_rx_vld_d, byte_rx_vld_q;

logic uart_rxd_q;

assign byte_rx_o     = byte_rx_q;
assign byte_rx_vld_o = byte_rx_vld_q;

always_comb begin
    state_d        = state_q;
    bit_mask_d     = bit_mask_q;
    tick_counter_d = tick_counter_q;
    byte_rx_vld_d  = 1'b0;
    byte_rx_d      = byte_rx_q;
    unique case(state_q)
    IDLE : begin
        tick_counter_d = '0;
        if(uart_rxd_q == 1'b0) begin
            state_d = START;
        end
    end
    START : begin
        tick_counter_d += 1;
        if(tick_counter_q == $rtoi($floor((TICKS_PER_BIT-1)/2))) begin
            if(uart_rxd_q == 1'b0) begin
                tick_counter_d = '0;
                bit_mask_d     = 8'hFF;
                state_d        = DATA;
            end else begin
                state_d = IDLE;
            end
        end
    end
    DATA : begin
        tick_counter_d += 1;
        if(tick_counter_q == TICKS_PER_BIT - 1) begin
            byte_rx_d = {uart_rxd_q, byte_rx_q[7:1]};
            bit_mask_d = {1'b0, bit_mask_q[7:1]};
            if(bit_mask_q == 8'b1) begin
                tick_counter_d = '0;
                state_d        = STOP;
            end
        end
    end
    STOP : begin
        tick_counter_d += 1;
        if(tick_counter_q == TICKS_PER_BIT - 1) begin
            byte_rx_vld_d = 1'b1;
            state_d       = IDLE;
        end
    end
    endcase
end

always_ff @(posedge clk_i) begin
    state_q        <= state_d;
    bit_mask_q     <= bit_mask_d;
    tick_counter_q <= tick_counter_d;
    byte_rx_vld_q  <= byte_rx_vld_d;
    byte_rx_q      <= byte_rx_d;
    if(rst_i) begin
        state_q <= IDLE;
    end
end

pipeline
#(
    .DATA_WIDTH (1),
    .DEPTH      (2)  // Stabilize IO rxd
)
rxd_pipe
(
    .clk_i  (clk_i),
    .rst_i  (rst_i),
    .data_i (uart_rxd_i),
    .data_o (uart_rxd_q)
);

endmodule

module uart
#(
    parameter CLK_FREQ_HZ = 100000000,
    parameter BAUD_RATE   = 9600
)
(
    input               clk_i,
    input               rst_i,
    input  wire         uart_rxd_i,
    output wire         uart_txd_o,
    input  logic [ 7:0] byte_tx_i,
    input  logic        byte_tx_vld_i,
    input  logic        do_tx_i,
    output logic        done_tx_o,
    output logic [ 7:0] byte_rx_o,
    output logic        byte_rx_vld_o
);

localparam TICKS_PER_BIT = $floor(CLK_FREQ_HZ / BAUD_RATE);

uart_tx
#(
    .TICKS_PER_BIT (TICKS_PER_BIT)
)
tx
(
    .clk_i         (clk_i),
    .rst_i         (rst_i),
    .uart_txd_o    (uart_txd_o),
    .byte_tx_i     (byte_tx_i),
    .byte_tx_vld_i (byte_tx_vld_i),
    .do_tx_i       (do_tx_i),
    .done_tx_o     (done_tx_o)
);

uart_rx
#(
    .TICKS_PER_BIT (TICKS_PER_BIT)
)
rx
(
    .clk_i         (clk_i),
    .rst_i         (rst_i),
    .uart_rxd_i    (uart_rxd_i),
    .byte_rx_o     (byte_rx_o),
    .byte_rx_vld_o (byte_rx_vld_o)
);

endmodule
