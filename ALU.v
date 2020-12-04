//MIPS ALU operations: 
//ADD, SUB, AND, NOR, OR, XOR, MULT, DIV, Shifts
//a/b are rs/rt, rs/imm, etc. assumed to have been appropriately routed to the ALU 
//convention: a is the value operated on (shifts) or the rs/only source register for other instructions
//b is the other value, regardless of origin
//ctrl is a signal from the control path, rather than a field of the instructon

module div(
    input logic [31:0] a, b,
    input logic signdiv,
    output logic [31:0] q, r
);
    integer msbindexa, msbindexb;
    logic [31:0] rega, regb, regbuse, quotient;

    always_comb begin
       //take magnitude of negative operands for signed div
		  if (signdiv == 1 & a[31] == 1) begin
				rega = ~(a-{32'h00000001});
		  end else begin
				rega = a;
		  end
			
		if( signdiv == 1 & b[31] == 1 ) begin
			 regb = ~(b-{32'h00000001});
		end else begin            
			regb = b;
		end	

        //very suboptimal: find the msb of rega and regb
        msbindexa = 31;
        while ( rega[msbindexa] == 0 ) begin
            msbindexa = msbindexa - 1; //is this legal? found example of it
        end
        msbindexb = 31;
        while ( regb[msbindexb] == 0 ) begin
            msbindexb = msbindexb - 1; //is this legal? found example of it
        end

        //align a and b
        rebg <= ( regb << (msbindexa - msbindexb) ); 

        //implement division
        while( regb[0] == 0 ) begin
            quotient <= ( quotient << 1 );
            if ( rega > regb ) begin
                rega <= (rega - regb);
                quotient[0] = 1;
			   end
        end
        quotient <= ( quotient << 1 );
            if ( rega > regb ) begin
                rega <= (rega - regb);
                quotient[0] = 1;
			   end
        
        //negate output if div is signed and signs of operands dissagree
        if ( signdiv ) begin
            if ( a[31] ^ b[31] ) begin
                q = ~quotient + 1;
            end else begin
                q = quotient;
				end

            if ( a[31] == 1 ) begin
                r = ~rega + 1;
            end else begin
                r = rega;
				end

        end else begin
            q = quotient;
            r = rega; 
		  end
		  
    end

endmodule




module ALU(
    input logic [31:0] a, b,
    input logic [3:0] ctrl,
    output logic [31:0] out
);
    //signals and module for division
    logic S;
    logic [31:0] divq, divr;
    div divcirc(.a(a), .b(b), .signdiv(S), .q(divq), .r(divr));

    //carry for multiplication
    logic C;

    always_comb begin
        case(ctrl)
            4'b0000: out = a + b;   //ADD
            4'b0001: out = a - b;   //SUB
            4'b0010: out = a & b;   //AND bitwise
            4'b0011: out = a | b;   //OR bitwise
            4'b0100: out = a ^ b;   //XOR bitwise
            4'b0101: out = a<<b;  //SLL 
            4'b0110: out = a>>b;  //SRL
            4'b0111: out = a>>>b; //SRA 
            4'b1000: out = { { {16{a[31]}}, a[31:16]} * { {16{b[31]}}, b[31:16]} + { {15{1'b0}} , C } }; //MULT TOP
            4'b1001: begin //MULT BOT
               out = { {16{a[15]}}, a[15:0]} * { {16{b[15]}}, b[15:0]};
               C = out[31] //not sure this is legal    
            end
            4'b1010: out = { {16'h0000, a[31:16]} * {16'h0000, b[31:16]} + { {15{1'b0}}, C } };        //MULTU TOP
            4'b1011: begin //MULTU BOT
                out = {16'h0000, a[15:0]} * {16'h0000, b[15:0]};
                C = out[31] //not sure this is legal
            end
                     
            4'b1100: begin //DIV
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
            end      
        endcase
    end
endmodule