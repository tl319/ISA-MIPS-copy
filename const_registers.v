module const_reg(
    input logic clk,
    output logic [31:0] out_const_1, out_const_4, out_const_31
);

    logic [31:0] const_1, const_4, const_31;

    assign const_1 = 8'h00000001;
    assign const_4 = 8'h00000004;
    assign const_31 = 8'h0000001F;

    always_ff @(posedge clk) begin
        out_const_1 <= const_1; 
        out_const_4 <= const_4;
        out_const_31 <= const_31;
    end
    
endmodule
