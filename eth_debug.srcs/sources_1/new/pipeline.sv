`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2021 01:48:48 AM
// Design Name: 
// Module Name: pipeline
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


module pipeline
#(
    DATA_WIDTH = 32,
    DEPTH      = 1
)
(
    input                         clk_i,
    input                         rst_i,

    input  logic [DATA_WIDTH-1:0] data_i,

    output logic [DATA_WIDTH-1:0] data_o
);

generate
if(DEPTH == 0) begin
    assign data_o = data_i;
end else begin
    logic [DATA_WIDTH-1:0] data_q [DEPTH];

    assign data_o = data_q[DEPTH-1];

    always_ff @(posedge clk_i) begin
        data_q[0] <= data_i;
        for(int i = 1; i < DEPTH; i++) begin
            data_q[i] <= data_q[i-1];
        end
        if(rst_i) begin
            for(int i = 0; i < DEPTH; i++) begin
                data_q[i] <= '0;
            end
        end
    end
end
endgenerate

endmodule : pipeline
