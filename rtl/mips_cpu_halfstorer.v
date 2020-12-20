module half_storer (
    input logic [31:0] in,
    input logic half_store_en,
    output logic [31:0] out
);
    logic [15:0] byte1;

    assign byte1 = in[15:0];
      always_comb begin
        if (half_store_en ==1) begin
        out = {byte1,byte1};
        end else begin
        out = in;
        end
    end

endmodule
