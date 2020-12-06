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
    integer msbindexa, msbindexb, lsoneb;
    logic [31:0] rega, regb, regbuse, quotient;

    always_ff begin
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
		  for (int i = 0; i<32; i++) begin 
				if(rega[31-i] == 1) begin
					msbindexa = 31-i;
					break;
				end		  
        end
        msbindexb = 31;
		  for (int i = 0; i<32; i++) begin 
				if(regb[31-i] == 1) begin
					msbindexb = 31-i;
					break;
				end		  
        end
		  lsoneb = 0;
		  for (int i = 0; i<32; i++) begin 
				if(regb[i] == 1) begin
					lsoneb = i;
					break;
				end		  
        end

        //align a and b
        regb = ( regb << (msbindexa - msbindexb) ); 

        //implement division
		  
		  for(int i = 0; i<(lsoneb+1); i++) begin
				quotient = ( quotient << 1 );
            if ( rega > regb ) begin
                rega = (rega - regb);
                quotient[0] = 1;
			   end
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
    output logic [31:0] out,
    output logic [1:0] comp
);
    //signals and module for division
    logic S;
    logic [31:0] divq, divr;
    div divcirc(.a(a), .b(b), .signdiv(S), .q(divq), .r(divr));

    //carry for multiplication
    logic C;

    always_ff @(a, b) begin
       
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
            4'b1001: out = { { {16{a[31]}}, a[31:16]} * { {16{b[31]}}, b[31:16]} + { {15{1'b0}} , C } }; //MULT TOP
            4'b1000: begin //MULT BOT
               out = { {16{a[15]}}, a[15:0]} * { {16{b[15]}}, b[15:0]};
               C = out[31]; //not sure this is legal    
            end
            4'b1011: out = { {16'h0000, a[31:16]} * {16'h0000, b[31:16]} + { {15{1'b0}}, C } };        //MULTU TOP
            4'b1010: begin //MULTU BOT
                out = {16'h0000, a[15:0]} * {16'h0000, b[15:0]};
                C = out[31]; //not sure this is legal
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