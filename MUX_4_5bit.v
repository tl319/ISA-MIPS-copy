module MUX_4_5bit(
    input logic [4:0] a, b, c, d,
    input logic [1:0] select,
    output logic [4:0] out
);

    always_comb begin
        case(select)
        2'b00:  out = a;
        2'b01:  out = b;
        2'b10:  out = c;
        2'b11:  out = d;
        endcase
    end

endmodule
