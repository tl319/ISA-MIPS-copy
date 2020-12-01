module sign_extend (
    input logic [15:0] in
    input logic [31:0] out
);

    always_comb begin
        //might not work
        out = $signed(in);
    end

endmodule