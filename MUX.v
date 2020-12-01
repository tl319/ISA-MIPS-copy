module ALU(
    input [31:0] a, b,
    input [3:0] ctrl,
    output [31:0] out
):
    case(ctrl)
        4'b0000: out = a + b;   //ADD
        4'b0001: out = a - b;   //SUB
        4'b0010: out = a & b;   //AND bitwise
        4'b0011: out = a | b;   //OR bitwise
        4'b0100: out = a ^ b;   //XOR bitwise
        4'b0101: out = ~(a|b);  //NOT bitwise
        4'b0110: out = a<<b; //SLL 
        4'b0111: out = a>>b; //SRL
        4'b1000: out = a>>>b; //SRA
        //not certain how MULT and DIV are implemented, 64 bit out bus containing high and low? 
        //discuss when approching registers
        4'b1001: out = a<<16; //LUI

endmodule