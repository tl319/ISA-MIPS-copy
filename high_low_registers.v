module high_low_registers(

    input logic clk,
    input logic ctrl_hi, WrEn,
    input logic [31:0] input_hi, input_lo,
    output logic [31:0] out

);

    logic [31:0] reg_hi, reg_lo;

    always_ff @(posedge clk) begin
        case(WrEn)

        0:  case(ctrl_hi)
            0: out <= input_lo;
            1: out <= input_hi;
            endcase

        1:  case(ctrl_hi)
            0: reg_lo <= input_lo;
            1: reg_hi <= input_hi;
            endcase
        endcase
        
    end
    
endmodule
