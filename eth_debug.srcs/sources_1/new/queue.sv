// ECE411 Final Project: OOPs
// Caleb Gerth cdgerth2
// Dillon Hammond dillonh2
// Jonathan Paulson paulson5

/**
* Generic Queue
* Supports Valid/Ready Logic
* DEPTH will be rounded up to a power of 2
*/

module queue
#(
    WIDTH = 32,
    DEPTH = 15
)
(
    input                    clk,
    input                    rst,

    input  logic             vld_i,
    output logic             rdy_i,
    input  logic [WIDTH-1:0] data_i,

    output logic             vld_o,
    input  logic             rdy_o,
    output logic [WIDTH-1:0] data_o
);

localparam DEPTH2 = 2 ** ($clog2(DEPTH));

logic [ WIDTH-1:0] data_d [DEPTH2];
logic [ WIDTH-1:0] data_q [DEPTH2];
logic [DEPTH2-1:0] used_mask_d, used_mask_q;

logic [$clog2(DEPTH2)-1:0] read_addr_d,  read_addr_q;
logic [$clog2(DEPTH2)-1:0] write_addr_d, write_addr_q;

logic almost_empty, empty;
logic almost_full, full;

logic read, write;

logic rdy_d, vld_d;

assign almost_empty = (read_addr_q  + 1'b1 == write_addr_q) && (used_mask_q[write_addr_q] == 1'b0);
assign almost_full  = (write_addr_q + 1'b1 == read_addr_q ) && (used_mask_q[ read_addr_q] == 1'b1);

assign empty = (write_addr_q == read_addr_q) && (used_mask_q[read_addr_q] == 1'b0);
assign full  = (write_addr_q == read_addr_q) && (used_mask_q[read_addr_q] == 1'b1);

assign read  = !empty && rdy_o && vld_o;
assign write = !full  && vld_i && rdy_i;

assign rdy_d = !( (almost_full  && write && !read)  || (full  && !read) );  // We cannot accept  data after this cycle
assign vld_d = !( (almost_empty && read  && !write) || (empty && !write) ); // We cannot provide data after this cycle

assign data_o = data_q[read_addr_q];

always_comb begin
    data_d       = data_q;
    used_mask_d  = used_mask_q;
    read_addr_d  = read_addr_q;
    write_addr_d = write_addr_q;

    if(read) begin
        read_addr_d = read_addr_q + 1'b1;
        // Mark this element as free
        used_mask_d[read_addr_q] = 1'b0;
    end

    if(write) begin
        write_addr_d = write_addr_q + 1'b1;
        // Read in the data and mark the spot as full
        data_d[write_addr_q]      = data_i;
        used_mask_d[write_addr_q] = 1'b1;
    end
end

always_ff @(posedge clk) begin
    data_q       <= data_d;
    used_mask_q  <= used_mask_d;
    read_addr_q  <= read_addr_d;
    write_addr_q <= write_addr_d;
    rdy_i        <= rdy_d;
    vld_o        <= vld_d;
    if(rst) begin
        used_mask_q  <= '0;
        read_addr_q  <= '0;
        write_addr_q <= '0;
        rdy_i        <= '0;
        vld_o        <= '0;
    end
end

endmodule : queue
