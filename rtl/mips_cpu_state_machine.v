module state_machine(
    input logic clk,
    input logic [3:0] prev_state,
    input logic reset,
    input logic jump,
    input logic wait_request,
    input logic halt,
    output logic [3:0] state,
    output logic active,
    input logic divdone,
    output logic divrst_en
);

    always_ff @(posedge clk) begin
      if(reset) begin
      state <= 4'b1111;
      active = 1'b1;
      end else if(wait_request) begin
      state <= prev_state;
      end else
      case(prev_state)
      4'b0000:if(jump)
              state <= 4'b1001;
              else
              state <= 4'b0001;
      4'b0001:begin
                state <= 4'b0010;
                divrst_en <= 1;  //set to 1 to allow divrst to be asserted in state 0010 of the same instruction
                end
      4'b0010:if(divdone ==0) begin
              state <= 4'b0010;
              divrst_en <= 0; 
        end else begin 
              state <= 4'b0011;
              divrst_en <= 0;
        end
      4'b0011:state <= 4'b0100;
      4'b0100:if(halt)
              state <= 4'b0101;
              else
              state <= 4'b0000;
      4'b0101:begin
 state <= 4'b0101;
 active <= 1'b0;
 end
      4'b1111:state <= 4'b1110;
      4'b1110:state <= 4'b0000;
4'b1001:state <= 4'b0010;
      endcase
      end
endmodule
