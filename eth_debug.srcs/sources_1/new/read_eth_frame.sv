`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2021 11:09:12 PM
// Design Name: 
// Module Name: read_eth_frame
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


module read_eth_frame(
    input               s_axi_aclk_i,
    input               s_axi_aresetn_i,
    output logic [12:0] s_axi_awaddr_o,
    output logic        s_axi_awvalid_o,
    input  logic        s_axi_awready_i,
    output logic [31:0] s_axi_wdata_o,
    output logic [ 3:0] s_axi_wstrb_o,
    output logic        s_axi_wvalid_o,
    input  logic        s_axi_wready_i,
    input  logic [ 1:0] s_axi_bresp_i,
    input  logic        s_axi_bvalid_i,
    output logic        s_axi_bready_o,
    output logic [12:0] s_axi_araddr_o,
    output logic        s_axi_arvalid_o,
    input  logic        s_axi_arready_i,
    input  logic [31:0] s_axi_rdata_i,
    input  logic [ 1:0] s_axi_rresp_i,
    input  logic        s_axi_rvalid_i,
    output logic        s_axi_rready_o,
    output logic [31:0] eth_frame_data_o,
    output logic        eth_frame_vld_o
);
    
localparam [12:0] RX_PING_CTRL_ADDR = 13'h17FC;
localparam [12:0] RX_PONG_CTRL_ADDR = 13'h1FFC;
localparam [12:0] RX_PING_DATA_ADDR = 13'h1000;
localparam [12:0] RX_PONG_DATA_ADDR = 13'h1800;

logic [10:0] data_addr_offset_q;

typedef enum {
    RESET,
    WAIT_ON_PING,
    READ_FROM_PING,
    CLEAR_PING,
    WAIT_ON_PONG,
    READ_FROM_PONG,
    CLEAR_PONG
} state_t;

typedef enum {
    SET_READ_ADDR,
    DO_READ,
    SET_WRITE_ADDR,
    DO_WRITE,
    FINISH_WRITE
} axi_state_t;

state_t state_q;
axi_state_t axi_state_q;

always_ff @(posedge s_axi_aclk_i) begin
    s_axi_awvalid_o  <= '0;
    s_axi_wvalid_o   <= '0;
    s_axi_bready_o   <= '0;
    s_axi_arvalid_o  <= '0;
    s_axi_rready_o   <= '0;
    eth_frame_vld_o  <= '0;
    eth_frame_data_o <= s_axi_rdata_i;
    case(state_q)
    RESET : begin
        state_q     <= WAIT_ON_PING;
        axi_state_q <= SET_READ_ADDR;
    end 
    WAIT_ON_PING, WAIT_ON_PONG : begin
        unique case(axi_state_q)
        SET_READ_ADDR : begin
            s_axi_araddr_o  <= (state_q == WAIT_ON_PING) ? RX_PING_CTRL_ADDR : RX_PONG_CTRL_ADDR;
            s_axi_arvalid_o <= 1'b1;
            if(s_axi_arready_i) begin
                s_axi_arvalid_o <= 1'b0;
                s_axi_rready_o  <= 1'b1;
                axi_state_q     <= DO_READ;
            end
        end
        DO_READ : begin
            s_axi_rready_o <= 1'b1;
            if(s_axi_rvalid_i) begin
                s_axi_rready_o <= 1'b0;
                if(s_axi_rdata_i[0]) begin
                    data_addr_offset_q <= '0;
                    state_q <= (state_q == WAIT_ON_PING) ? READ_FROM_PING : READ_FROM_PONG;
                end
                axi_state_q <= SET_READ_ADDR;
            end
        end
        endcase
    end
    READ_FROM_PING, READ_FROM_PONG : begin
        unique case(axi_state_q)
        SET_READ_ADDR : begin
            s_axi_araddr_o  <= ((state_q == READ_FROM_PING) ? RX_PING_DATA_ADDR : RX_PONG_DATA_ADDR) + data_addr_offset_q;
            s_axi_arvalid_o <= 1'b1;
            if(s_axi_arready_i) begin
                s_axi_arvalid_o <= 1'b0;
                s_axi_rready_o  <= 1'b1;
                axi_state_q     <= DO_READ;
            end
        end
        DO_READ : begin
            s_axi_rready_o <= 1'b1;
            if(s_axi_rvalid_i) begin
                s_axi_rready_o     <= 1'b0;
                eth_frame_vld_o    <= 1'b1;
                data_addr_offset_q <= data_addr_offset_q + 4;
                axi_state_q <= SET_READ_ADDR;
                if(data_addr_offset_q + 4 == 1518) begin
                    state_q     <= (state_q == READ_FROM_PING) ? CLEAR_PING : CLEAR_PONG;
                    axi_state_q <= DO_WRITE;
                end
            end
        end
        endcase
    end
    CLEAR_PING, CLEAR_PONG : begin
        unique case(axi_state_q)
        SET_WRITE_ADDR : begin
            s_axi_awaddr_o  <= (state_q == CLEAR_PING) ? RX_PING_CTRL_ADDR : RX_PONG_CTRL_ADDR;
            s_axi_awvalid_o <= 1'b1;
            if(s_axi_awready_i) begin
                s_axi_awvalid_o <= 1'b0;
                axi_state_q     <= DO_WRITE;
            end
        end
        DO_WRITE : begin
            s_axi_wdata_o   <= '0;
            s_axi_wstrb_o   <= 4'b1;
            s_axi_wvalid_o  <= 1'b1;
            if(s_axi_wready_i) begin
                s_axi_wvalid_o <= 1'b0;
                s_axi_bready_o <= 1'b1;
                axi_state_q    <= FINISH_WRITE;
            end
        end
        FINISH_WRITE : begin
            s_axi_bready_o  <= 1'b1;
            if(s_axi_bvalid_i) begin
                s_axi_bready_o <= 1'b0;
                state_q        <= (state_q == CLEAR_PING) ? WAIT_ON_PONG : WAIT_ON_PING;
                axi_state_q    <= SET_READ_ADDR;
            end
        end
        endcase
    end
    endcase
    if(!s_axi_aresetn_i) begin
        state_q <= RESET;
    end
end
endmodule
