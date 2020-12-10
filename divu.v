module divu(
    //division algorithm requires a that has been shifted left such that newa<b<2*newa
    input logic [31:0] a, b, realb,
	 input logic clk, rst,
    output logic [31:0] q, r,
	 output logic done
);
    logic [31:0] rega, regb, quotient, finished;

	 //takes many cycles, requires rst to be high during clk posedge
	 
	 always_comb begin
		q = quotient;
		r = rega;
		done = finished;
	 end
	 
	 always_ff@ ( posedge clk, posedge rst ) begin
			if(rst == 1) begin
				quotient <= 32'h00000000;
				rega <= a;
				regb <= b;
				finished <= 0;
			end else begin
			
				if(regb < realb) begin
					//make this happen a cycle earlier
					finished <= 1;
				end else begin
					if (rega >= regb) begin
						rega <= (rega - regb);
						quotient <= ((quotient << 1) + 1); 

					end else begin
						rega <= rega;
						quotient <= (quotient << 1);
						
					end
					regb <= (regb >> 1);
				end
						
			end
						
	 end

endmodule