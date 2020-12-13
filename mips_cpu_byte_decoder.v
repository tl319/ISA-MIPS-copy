module byte_decoder(
    input logic [1:0] aluout, byte_cnt,
    output logic [3:0] byte_en
);

    always_comb begin
      case(byte_cnt)
      2'b00 : byte_en = 4'b1111;
      2'b01 : case(aluout)
              2'b00 : byte_en = 4'b0001;
              2'b01 : byte_en = 4'b0010;
              2'b10 : byte_en = 4'b0100;
              2'b11 : byte_en = 4'b1000;
        endcase
      2'b10 : case(aluout)
        2'b00 : byte_en = 4'b0011;
        2'b01 : byte_en = 4'b0000;
        2'b10 : byte_en = 4'b1100;
        2'b11 : byte_en = 4'b0000;
        endcase
      2'b11 : byte_en = 4'b1111;
      endcase
    end
endmodule
