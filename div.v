//DIV, currently broken

module div(
    input logic [31:0] a, b,
    input logic signdiv,
    output logic [31:0] q, r, lll
);
    integer msbindexa, msbindexb, lsoneb;
    logic [31:0] rega, regb, regbuse, quotient;

    always_ff @(a, b, signdiv) begin
       //take magnitude of negative operands for signed div
		  if (signdiv == 1 & a[31] == 1) begin
				rega <= ~(a-{32'h00000001});
		  end else begin
				rega <= a;
		  end
			
			if( signdiv == 1 & b[31] == 1 ) begin
				 regb <= ~(b-{32'h00000001});
			end else begin            
				regb <= b;
			end	

        //very suboptimal: find the msb of rega and regb
        msbindexa <= 31;
		  for (int i = 0; i<32; i++) begin 
				if(rega[31-i] == 1) begin
					msbindexa <= (31-i);
					// break;
				end		  
        end
        msbindexb <= 31;
		  for (int i = 0; i<32; i++) begin 
				if(regb[31-i] == 1) begin
					msbindexb <= (31-i);
					// break;
				end		  
        end
		  lsoneb <= 0;
		  for (int i = 0; i<32; i++) begin 
				if(regb[i] == 1) begin
					lsoneb <= i;
					// break;
				end		  
        end
		  lll = lsoneb;

        //align a and b
        regb <= ( regb << (msbindexa - msbindexb) ); 

        //implement division
		  
		  quotient <= 32'h00000000;
		  for(int i = 0; i<32; i++) begin
				quotient <= ( quotient << 1 );
            if ( rega > regb ) begin
                rega <= (rega - regb);
                quotient[0] <= 1;
			   end
				if(i > lsoneb) begin
					// break;
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