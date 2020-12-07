module divu(
    input logic [31:0] a, b, 
	 input logic clk, rst,
    output logic [31:0] q, r
);
    logic [31:0] rega, regb, quotient;
	 
	 //takes many cycles, requires rst to be high during clk posedge
	 always_ff@ ( posedge clk ) begin
			if(rst == 1) begin
				quotient <= 32'h00000000;
				rega <= a;
				regb <= b;
			end
	 
	 
			if (rega > regb) begin
				rega <= (rega - regb);
				quotient <= (quotient + 1);
			end	 
			
			q = quotient;
			r = rega;
	 end

endmodule