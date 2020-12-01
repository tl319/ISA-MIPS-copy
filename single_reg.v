module single_reg(
    input logic clk,
    input logic [31:0] p,
    output logic [31:0] q
);

    always_ff @(posedge clk) begin
        q <= p; 
    end
    
endmodule
