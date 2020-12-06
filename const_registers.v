module const_reg(
    output logic [31:0] const_1, const_4, const_31, reset_vector
);

    assign const_1 = 32'h00000001;
    assign const_4 = 32'h00000004;
    assign const_31 = 32'h0000001F;
    assign reset_vector = 32'hBFC00000;
    
endmodule