module sim_top #(
) (
);

logic clk;

initial begin
    clk = 1'b0;
    forever begin
        #50ns clk = !clk;
    end
end

endmodule
