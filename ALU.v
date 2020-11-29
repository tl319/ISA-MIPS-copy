//MIPS ALU operations: 
//ADD, SUB, AND, NOR, OR, XOR, MULT, DIV, Shifts
//a/b are rs/rt, rs/imm, etc. assumed to have been appropriately routed to the ALU 
//convention: rs is kept as a and rt/imm as b when only one of the three is used, eg SLL
//ctrl is a signal from the control path, rather than a field of the instructon

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
        4'b0110: out = b<<a; //SLL 
        4'b0111: out = b>>a; //SRL
        4'b1000: out = b>>>a; //SRA
        //not certain how MULT and DIV are implemented, 64 bit out bus containing high and low? 
        //discuss when approching registers
        4'b1001: out = b<<16; //LUI

endmodule