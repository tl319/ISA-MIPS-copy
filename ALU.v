
module ALU(
    input logic [31:0] a, b,
    input logic [3:0] ctrl,
    output logic [31:0] out,
    output logic [1:0] comp
);
    //signals and module for division
    logic S;
    logic [31:0] divq, divr;
    //div divcirc(.a(a), .b(b), .signdiv(S), .q(divq), .r(divr));

    //carry for multiplication
    logic C;
    logic [32:0] multbot;

    always_comb begin
       
			if ($signed(a) == $signed(b)) begin
				comp = 2'b00;
			end else if 
			($signed(a) < $signed(b)) begin
				comp = 2'b01;
			end else if	
			($signed(a) > $signed(b)) begin
				comp = 2'b10;
			end

        case(ctrl)
            4'b0000: out = a + b;   //ADD
            4'b0001: out = a - b;   //SUB
            4'b0010: out = a & b;   //AND bitwise
            4'b0011: out = a | b;   //OR bitwise
            4'b0100: out = a ^ b;   //XOR bitwise
            4'b0101: out = a<<b;  //SLL 
            4'b0110: out = a>>b;  //SRL
            4'b0111: out = a>>>b; //SRA 
            4'b1001: out = 0;         //MULT TOP
            4'b1000: out = 0; //MULT BOT
            4'b1011: out = (a * b)>>32;       //MULTU TOP
            4'b1010: out = (a * b); //MULTU BOT
                     
            /*4'b1100: begin //DIV
                S = 1;
                out = divq;
            end     
            4'b1101: begin //MOD
                S = 1;
                out = divr;
            end     
            4'b1110: begin //DIVU
                S = 0;
                out = divq;
            end      
            4'b1111: begin //MODU
                S = 0;
                out = divr;
            end*/
            //placeholder for DIV and MOD operations
            4'b1100: out = 32'h00000000; 
            4'b1101: out = 32'h00000000; 
            4'b1110: out = 32'h00000000; 
            4'b1111: out = 32'h00000000;       
        endcase
    end
endmodule