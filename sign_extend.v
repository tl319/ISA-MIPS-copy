module sign_extend (
    input logic [15:0] in,
    input logic [1:0] select,
    output logic [31:0] out
);

    always_comb begin
        case (select)
        2'b00: out = { 16'h0000, in };
        2'b01: out = { 16'hFFFF, in };
        2'b10: out = $signed(in);
        //shift in 16b left (LUI) to remove a select bit from the ALU
        2'b11: out = in<<16;
        endcase
    end

endmodule