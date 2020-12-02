//MIPS ALU operations: 
//ADD, SUB, AND, NOR, OR, XOR, MULT, DIV, Shifts
//a/b are rs/rt, rs/imm, etc. assumed to have been appropriately routed to the ALU 
//convention: a is the value operated on (shifts) or the rs/only source register for other instructions
//b is the other value, regardless of origin
//ctrl is a signal from the control path, rather than a field of the instructon

module ALU(
    input [31:0] a, b,
    input [3:0] ctrl,
    output [31:0] out
);
    always_comb begin
        case(ctrl)
            4'b0000: out = a + b;   //ADD
            4'b0001: out = a - b;   //SUB
            4'b0010: out = a & b;   //AND bitwise
            4'b0011: out = a | b;   //OR bitwise
            4'b0100: out = a ^ b;   //XOR bitwise
            4'b0101: out = a<<b; //SLL 
            4'b0110: out = a>>b; //SRL
            4'b0111: out = a>>>b; //SRA
            //not certain how MULT and DIV are implemented, 64 bit out bus containing high and low? 
            //discuss when approching registers
            //4'b1000: out = //MULT TOP
            //4'b1001        //MULT BOT
            //4'b1010       //MULTU TOP
            //4'b1011       //MULTU BOT
            //4'b1100       //DIV
            //4'b1101       //MOD
            //4'b1110       //DIVU
            //4'b1111       //MODU
        endcase
    end
endmodule