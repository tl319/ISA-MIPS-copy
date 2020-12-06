module MUX_2(
    input logic [31:0] a, b,
    input logic select,
    output logic [31:0] out
);
    
    always_comb begin
        case(select)
        0:  out = a;
        1:  out = b;
        endcase
    end

endmodule