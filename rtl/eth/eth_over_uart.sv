module eth_over_uart
#(
    parameter CLK_FREQ_HZ = 1,
    parameter BAUD_RATE   = 1
)
(
    input               clk_i,
    input               rst_i,
    input  logic [31:0] eth_chunk_i,
    input  logic        eth_chunk_vld_i,
    input  wire         uart_rxd_i,
    output wire         uart_txd_o
);

logic [31:0] uart_chunk_q;
logic        uart_chunk_vld_q;
logic        uart_chunk_rdy_d, uart_chunk_rdy_q;

queue
#(
    .WIDTH (32),
    .DEPTH ($rtoi($ceil(1522/32)))
)
eth_queue
(
    .clk    (clk_i),
    .rst    (rst_i),
    .vld_i  (eth_chunk_vld_i),
    .rdy_i  (), // Assume always rdy
    .data_i (eth_chunk_i),
    .vld_o  (uart_chunk_vld_q),
    .rdy_o  (uart_chunk_rdy_q),
    .data_o (uart_chunk_q)
);

typedef enum bit [2:0] {
    RESET,
    GET_CHUNK,
    TX_BYTE1,
    TX_BYTE2,
    TX_BYTE3,
    TX_BYTE4
} state_t;

state_t state_d, state_q;

logic [ 7:0] uart_byte_d, uart_byte_q;
logic        uart_byte_vld_d, uart_byte_vld_q;
logic        uart_byte_tx_d, uart_byte_tx_q;
logic        uart_byte_tx_done_q;

always_comb begin
    uart_chunk_rdy_d = 1'b0;
    uart_byte_d      = uart_byte_q;
    uart_byte_vld_d  = 1'b0;
    uart_byte_tx_d   = 1'b0;
    state_d          = state_q;
    unique case(state_q)
    RESET : begin
        state_d = GET_CHUNK;
    end
    GET_CHUNK : begin
        uart_chunk_rdy_d = 1'b1;
        if(uart_chunk_vld_q) begin
            uart_chunk_rdy_d = 1'b0;
            state_d          = TX_BYTE1;
        end
    end
    TX_BYTE1 : begin
        uart_byte_d     = uart_chunk_q[ 0+:8];
        uart_byte_vld_d = 1'b1;
        if(!uart_byte_tx_q) begin
            uart_byte_tx_d = 1'b1;
        end
        if(uart_byte_tx_done_q) begin
            uart_byte_vld_d = 1'b0;
            state_d         = TX_BYTE2;
        end
    end
    TX_BYTE2 : begin
        uart_byte_d     = uart_chunk_q[ 8+:8];
        uart_byte_vld_d = 1'b1;
        if(!uart_byte_tx_q) begin
            uart_byte_tx_d = 1'b1;
        end
        if(uart_byte_tx_done_q) begin
            uart_byte_vld_d = 1'b0;
            state_d         = TX_BYTE3;
        end
    end
    TX_BYTE3 : begin
        uart_byte_d     = uart_chunk_q[16+:8];
        uart_byte_vld_d = 1'b1;
        if(!uart_byte_tx_q) begin
            uart_byte_tx_d = 1'b1;
        end
        if(uart_byte_tx_done_q) begin
            uart_byte_vld_d = 1'b0;
            state_d         = TX_BYTE4;
        end
    end
    TX_BYTE4 : begin
        uart_byte_d     = uart_chunk_q[24+:8];
        uart_byte_vld_d = 1'b1;
        if(!uart_byte_tx_q) begin
            uart_byte_tx_d = 1'b1;
        end
        if(uart_byte_tx_done_q) begin
            uart_byte_vld_d = 1'b0;
            state_d         = GET_CHUNK;
        end
    end
    endcase
end

always_ff @(posedge clk_i) begin
    uart_chunk_rdy_q <= uart_chunk_rdy_d;
    uart_byte_q      <= uart_byte_d;
    uart_byte_vld_q  <= uart_byte_vld_d;
    uart_byte_tx_q   <= uart_byte_tx_d;
    state_q          <= state_d;
    if(rst_i) begin
        state_q <= RESET;
    end
end

uart
#(
    .CLK_FREQ_HZ (CLK_FREQ_HZ),
    .BAUD_RATE   (BAUD_RATE)
)
u
(
    .clk_i         (clk_i),
    .rst_i         (rst_i),
    .uart_rxd_i    (uart_rxd_i),
    .uart_txd_o    (uart_txd_o),
    .byte_tx_i     (uart_byte_q),
    .byte_tx_vld_i (uart_byte_vld_q),
    .do_tx_i       (uart_byte_tx_q),
    .done_tx_o     (uart_byte_tx_done_q),
    .byte_rx_o     (),
    .byte_rx_vld_o ()
);

endmodule
