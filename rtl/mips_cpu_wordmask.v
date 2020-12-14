module wordmask(
    input logic signed [31:0] data,
    input logic [2:0] msk_cnt,
    input logic [1:0] msk_cnt2,
    output logic signed [31:0] masked_data
);
    logic signed [31:0] temp1;
    logic signed [31:0] temp2;
    logic signed [31:0] temp3;
      always_comb begin
      case(msk_cnt)
      3'b000: masked_data = data;
      3'b001: begin
              case(msk_cnt2)
              2'b00: begin
                     temp1 = data<<<16;
                     masked_data = temp1>>>16;
                     end
              2'b01: begin
                     masked_data = data;
                     end
              2'b10: begin
                     temp1 = data>>>16;
                     masked_data = temp1;
                     end
              2'b11: begin
                     masked_data = data;
                     end
              endcase
              end
      3'b010: begin
              case(msk_cnt2)
              2'b00: begin
                     temp1 = data<<16;
                     masked_data = temp1>>16;
                     end
              2'b01: begin
                     masked_data = data;
                     end
              2'b10: begin
                     temp1 = data>>16;
                     masked_data = temp1;
                     end
              2'b11: begin
                     masked_data = data;
                     end
              endcase
              end
      3'b011: begin
              case(msk_cnt2)
              2'b00: begin
                     temp1 = data<<<24;
                     masked_data = temp1>>>24;
                     end
              2'b01: begin
                     temp1 = data<<<16;
                     temp2 = temp1>>>24;
                     masked_data = temp2;
                     end
              2'b10: begin
                     temp1 = data<<<8;
                     masked_data = temp1>>>24;
                     end
              2'b11: begin
                     masked_data = data>>>24;
                     end
              endcase
              end
      3'b100: begin
              case(msk_cnt2)
              2'b00: begin
                     temp1 = data<<24;
                     masked_data = temp1>>24;
                     end
              2'b01: begin
                     temp1 = data<<16;
                     masked_data = temp1>>24;
                     end
              2'b10: begin
                     temp1 = data<<8;
                     masked_data = temp1>>24;
                     end
              2'b11: begin
                     masked_data = data>>24;
                     end
              endcase
              end
      3'b101: begin
              case(msk_cnt2)
              2'b00: begin
                     temp1 = data<<24;
                     masked_data = temp1;
                     end
              2'b01: begin
                     masked_data = data<<16;
                     end
              2'b10: begin
                     temp1 = data<<8;
                     masked_data = temp1;
                     end
              2'b11: begin
                     masked_data = data;
                     end
              endcase
              end
      3'b110: begin
              case(msk_cnt2)
              2'b00: begin
                     temp1 = data;
                     masked_data = temp1;
                     end
              2'b01: begin
                     masked_data = data>>8;
                     end
              2'b10: begin
                     temp1 = data>>16;
                     masked_data = temp1;
                     end
              2'b11: begin
                     masked_data = data>>24;
                     end
              endcase
              end
      3'b111: masked_data = data;
      endcase
      end
endmodule
