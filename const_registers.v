module const_reg_1(
    input logic clk,
    //input logic [31:0] p,
    output logic [31:0] const_1, const_4, const_31
);

    always_ff @(posedge clk) begin
        const_1 <= 8'h00000001; 
        const_4 <= 8'h00000004;
        const_31 <= 8'h0000001F;
    end
    
endmodule
