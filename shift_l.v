module shift_l(
    input [31:0] in,
    output [31:0] out
);

    always_comb begin
        out = in<<2;
    end

endmodule

