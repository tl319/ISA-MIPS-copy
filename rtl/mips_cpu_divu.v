module divu(
    //division algorithm requires a that has been shifted left such that newa<b<2*newa
    input logic [31:0] divua, divub, realb,
	input logic clk, divurst,
    output logic [31:0] divuq, divur
);
    logic [31:0] rega, regb, quotient;

	//keep output signals updates
	always_comb begin
		divuq = quotient;
		divur = rega;
	end

	//while the shifted b is greater or equal to real b, subtract from a and shift right as per
	//the binary division algorithm
	always_ff@ ( posedge clk, negedge clk ) begin
		if(divurst == 1) begin
			quotient <= 32'h00000000;
			rega <= divua;
			regb <= divub;
		end else begin

			if(regb < realb) begin

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
