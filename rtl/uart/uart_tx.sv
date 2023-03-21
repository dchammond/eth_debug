`default_nettype none

module uart_tx
#(
    parameter int CLK_FREQ_HZ = 0,
    parameter int BAUD_RATE   = 0
)
(
    input  var logic         clk,
    input  var logic         rst,

    input  var logic [8-1:0] byte_in_data,
    input  var logic         byte_in_valid,
    output var logic         byte_in_ready,

    output var logic         bit_out
);

localparam int TICKS_PER_BIT = $floor(CLK_FREQ_HZ / BAUD_RATE);

typedef enum bit [4-1:0] {
    IDLE,
    START,
    DATA,
    STOP,
    IFG
} state_t;

state_t state_d, state_q = IDLE;

logic [$clog2(TICKS_PER_BIT):0] tick_counter_d, tick_counter_q = '0;

logic [8-1:0] byte_to_send_d, byte_to_send_q;
logic [8-1:0] bit_mask_d, bit_mask_q;

logic bit_out_d, bit_out_q = '0;

assign bit_out = bit_out_q;

always_comb begin
    byte_in_ready  = '0;
    bit_out_d      = '0;
    byte_to_send_d = byte_to_send_q;
    bit_mask_d     = bit_mask_q;
    tick_counter_d = tick_counter_q;
    state_d        = state_q;

    unique case(state_q)
        IDLE: begin
            byte_in_ready = 1'b1;
            if(byte_in_valid) begin
                byte_to_send_d = byte_in_data;
                bit_mask_d     = '1;
                tick_counter_d = '0;
                state_d        = START;
            end
        end
        START: begin
            bit_out_d      = 1'b1;
            tick_counter_d = tick_counter_q + 1'b1;
            if(tick_counter_q == (TICKS_PER_BIT - 1)) begin
                tick_counter_d = '0;
                state_d        = DATA;
            end
        end
        DATA: begin
            bit_out_d      = byte_to_send_q[0];
            tick_counter_d = tick_counter_q + 1'b1;
            if(tick_counter_q == (TICKS_PER_BIT - 1)) begin
                tick_counter_d = '0;
                bit_mask_d     = {1'b0, bit_mask_q[1+:7]};
                byte_to_send_d = {1'bx, byte_to_send_q[1+:7]};
                state_d        = (bit_mask_q == 8'd1) ? STOP : DATA;
            end
        end
        STOP: begin
            bit_out_d      = 1'b1;
            tick_counter_d = tick_counter_q + 1'b1;
            if(tick_counter_q == (TICKS_PER_BIT - 1)) begin
                tick_counter_d = '0;
                state_d        = IFG;
            end
        end
        IFG: begin
            tick_counter_d = tick_counter_q + 1'b1;
            if(tick_counter_q == (TICKS_PER_BIT - 1)) begin
                tick_counter_d = '0;
                state_d        = IDLE;
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    bit_out_q      <= bit_out_d;
    byte_to_send_q <= byte_to_send_d;
    bit_mask_q     <= bit_mask_d;
    tick_counter_q <= tick_counter_d;
    state_q        <= state_d;

    if(rst) begin
        state_q <= IDLE;
    end
end

endmodule

