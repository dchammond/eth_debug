`default_nettype none

module uart_rx
#(
    parameter int CLK_FREQ_HZ = 0,
    parameter int BAUD_RATE   = 0
)
(
    input  var logic         clk,
    input  var logic         rst,

    input  var logic         bit_in,

    output var logic [8-1:0] byte_out_data,
    output var logic         byte_out_valid,
    input  var logic         byte_out_ready
);

localparam int TICKS_PER_BIT = $floor(CLK_FREQ_HZ / BAUD_RATE);

typedef enum bit [2-1:0] {
    IDLE,
    START,
    DATA,
    STOP
} state_t;

logic fifo_wr_ack;

logic [$clog2(TICKS_PER_BIT):0] tick_counter_d, tick_counter_q = '0;

state_t state_d, state_q = IDLE;

logic uart_rxd_q = '0;

logic [8-1:0] byte_rx_d, byte_rx_q;
logic [8-1:0] bit_mask_d, bit_mask_q = '0;

always_comb begin
    state_d        = state_q;
    bit_mask_d     = bit_mask_q;
    tick_counter_d = tick_counter_q;
    byte_rx_d      = byte_rx_q;

    if(bit_mask_q == '1 && fifo_wr_ack) begin
        bit_mask_d = '0;
    end

    unique case(state_q)
    IDLE: begin
        tick_counter_d = '0;
        if(uart_rxd_q == 1'b1) begin
            state_d = START;
        end
    end
    START: begin
        tick_counter_d = tick_counter_q + 1'b1;
        if(tick_counter_q == $rtoi($floor((TICKS_PER_BIT-1)/2))) begin
            if(uart_rxd_q == 1'b1) begin
                tick_counter_d = '0;
                bit_mask_d     = '0;
                state_d        = DATA;
            end else begin
                state_d = IDLE;
            end
        end
    end
    DATA: begin
        tick_counter_d = tick_counter_q + 1'b1;
        if(tick_counter_q == (TICKS_PER_BIT - 1)) begin
            tick_counter_d = '0;
            byte_rx_d      = {uart_rxd_q, byte_rx_q[1+:7]};
            bit_mask_d     = {1'b1, bit_mask_q[1+:7]};
            if(bit_mask_q[1+:7] == '1) begin
                state_d = STOP;
            end
        end
    end
    STOP: begin
        tick_counter_d = tick_counter_q + 1'b1;
        if(tick_counter_q == (TICKS_PER_BIT - 1)) begin
            state_d = IDLE;
        end
    end
    endcase
end

always_ff @(posedge clk) begin
    state_q        <= state_d;
    bit_mask_q     <= bit_mask_d;
    tick_counter_q <= tick_counter_d;
    byte_rx_q      <= byte_rx_d;

    uart_rxd_q     <= bit_in;

    if(rst) begin
        bit_mask_q <= '0;
        state_q    <= IDLE;
    end
end

localparam int FIFO_DEPTH = 16;

xpm_fifo_sync #(
    .CASCADE_HEIGHT      (0),
    .DOUT_RESET_VALUE    ("0"),
    .ECC_MODE            ("no_ecc"),
    .FIFO_MEMORY_TYPE    ("auto"),
    .FIFO_READ_LATENCY   (1),
    .FIFO_WRITE_DEPTH    (FIFO_DEPTH),
    .FULL_RESET_VALUE    (1),
    .RD_DATA_COUNT_WIDTH ($clog2(FIFO_DEPTH)+1),
    .READ_DATA_WIDTH     ($bits(byte_out_data)),
    .READ_MODE           ("std"),
    .SIM_ASSERT_CHK      (0),
    .USE_ADV_FEATURES    ("1010"), // 12'b1000000010000
    .WAKEUP_TIME         (0),
    .WR_DATA_COUNT_WIDTH ($clog2(FIFO_DEPTH)+1),
    .WRITE_DATA_WIDTH    ($bits(byte_out_data))
) uart_rx_fifo (
    .almost_empty        (),
    .almost_full         (),
    .data_valid          (byte_out_valid),
    .dbiterr             (),
    .din                 (byte_rx_q),
    .dout                (byte_out_data),
    .empty               (),
    .full                (),
    .injectdbiterr       ('0),
    .injectsbiterr       ('0),
    .overflow            (),
    .prog_empty          (),
    .prog_full           (),
    .rd_data_count       (),
    .rd_en               (byte_out_ready),
    .rd_rst_busy         (),
    .rst                 (rst),
    .sbiterr             (),
    .sleep               ('0),
    .underflow           (),
    .wr_ack              (fifo_wr_ack),
    .wr_clk              (clk),
    .wr_data_count       (),
    .wr_en               (bit_mask_q == '1 && !fifo_wr_ack),
    .wr_rst_busy         ()
);

endmodule
