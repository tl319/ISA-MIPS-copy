module brancher(
    input logic [1:0] cond,
    input logic [3:0] state,
    input logic [5:0] opcode,
    input logic [5:0] fn,
    input logic [4:0] info,
    output logic JumpIN,
    output logic Jump_EN
);
    always_comb begin
    if(state == 4'b0010) begin
    Jump_EN = 1;
      if(opcode == 6'b000010) begin
      JumpIN = 1;
      end
      else if(opcode == 6'b000011) begin
      JumpIN = 1;
      end
      else if(opcode == 6'b000000 && fn == 6'b001000) begin
      JumpIN = 1;
      end
      else if(opcode == 6'b000000 && fn == 6'b001001) begin
      JumpIN = 1;
      end
      else if(opcode == 6'b000100 && cond == 2'b00) begin
      JumpIN = 1;
      end
      else if(opcode == 6'b000001 && info == 5'b00001 && (cond == 2'b00 || cond == 2'b10)) begin
      JumpIN = 1;
      end
      else if(opcode == 6'b000111 && info == 5'b00000 && cond == 2'b10) begin
      JumpIN = 1;
      end
      else if(opcode == 6'b000110 && info == 5'b00000 && cond == (2'b00 || 2'b01)) begin
      JumpIN = 1;
      end
      else if(opcode == 6'b000001 && info == 5'b00000 && cond == 2'b01) begin
      JumpIN = 1 ;
      end
      else if(opcode == 6'b000101 && cond == (2'b01 || 2'b10)) begin
      JumpIN = 1;
      end
      else if(opcode == 6'b000001 && info == 5'b10001 && (cond == 2'b00 || cond == 2'b10)) begin
      JumpIN = 1;
      end
      else if(opcode == 6'b000001 && info == 5'b10000 && cond == 2'b01) begin
      JumpIN = 1;
      end
      else begin
      JumpIN = 0;
      end
    end
    else begin
    JumpIN = 0;
    Jump_EN = 0;
    end
    end
endmodule
