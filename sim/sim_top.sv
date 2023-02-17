module sim_top #(
) (
);

logic clk_100;

initial begin
    clk_100 = 1'b0;
    forever begin
        #50ns clk_100 = !clk_100;
    end
end

logic rst;

initial begin
    rst = 1'b1;
    #1us
    rst = 1'b0;
end

logic [8-1:0] byte_in_data;
logic         byte_in_valid = '0;
logic         byte_in_ready;

logic bit_out;

uart_tx #(
    .CLK_FREQ_HZ   (100 * 10 ** 6),
    .BAUD_RATE     (3 * 10 ** 6)
) i_uart_tx (
    .clk           (clk_100),
    .rst           (rst),

    .byte_in_data  (byte_in_data),
    .byte_in_valid (byte_in_valid),
    .byte_in_ready (byte_in_ready),

    .bit_out       (bit_out)
);

logic [8-1:0] byte_out_data;
logic         byte_out_valid;
logic         byte_out_ready = '0;

uart_rx #(
    .CLK_FREQ_HZ    (100 * 10 ** 6),
    .BAUD_RATE      (3 * 10 ** 6)
) i_uart_rx (
    .clk            (clk_100),
    .rst            (rst),

    .bit_in         (bit_out),

    .byte_out_data  (byte_out_data),
    .byte_out_valid (byte_out_valid),
    .byte_out_ready (byte_out_ready)
);

endmodule
