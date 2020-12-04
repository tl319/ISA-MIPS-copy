//high low register block, with clocked input
//If WriteEnable is HIGH, write data from 32 bit input bus into the high/low register
//Data is read from register every clock cycle
//If Control_High is HIGH, read/write to HIGH register,
//if Control_High is LOW, read/write to LOW register

//sidenote: check if case inside case loop is legal in verilog

module high_low_registers(

    input logic clk,
    input logic ctrl_hi, WrEn,
    input logic [31:0] input_hi_lo,
    output logic [31:0] out

);

    logic [31:0] reg_hi, reg_lo;

    always_ff @(posedge clk) begin
        case(WrEn)

        0:  case(ctrl_hi)
            0: out <= { 16'h0000 , input_hi_lo[15:0] };
            1: out <= { input_hi_lo[31:16] , 16'h0000 };
            endcase

        1:  case(ctrl_hi)
            0: reg_lo <= { 16'h0000 , input_hi_lo[15:0] };
            1: reg_hi <= { input_hi_lo[31:16] , 16'h0000 };
            endcase
        endcase
        
    end
    
endmodule
