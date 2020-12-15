module div(
    input logic [31:0] a, b,
    input logic signdiv, clk, divrst,
    output logic [31:0] q, r, alb,
	output logic divdone
);

	logic nxt;
	//internal operand and result values, as division is unsigned and begins with the divisor shifted to the MSB of quotient (unclear explanation)
	logic [31:0] ua, ub, shiftedb, uq, ur;

	logic [4:0] constind;
	logic [5:0] aligncnt;

	align aligner (
		.clk(clk), .alrst(divrst),
		.ala(ua), .alb(ub), .shiftb(shiftedb)
	);

	divu divider (
		.clk(clk), .divurst(nxt),
		.divua(ua), .divub(shiftedb), .realb(ub),
		.divuq(uq), .divur(ur)
	);

	initial begin
		constind <= 5'b11111;
		aligncnt <= 0;
		nxt <= 0;
		divdone <= 1;
	end

	//on the 18th half cycle b has been aligned for division, on the 51st the division is complete (worst case values):
	//in 26 clock cycles the division is finished
	always_ff @(posedge clk, negedge clk) begin

		if(divrst == 1) begin
			aligncnt <= 6'b000000;
			divdone <= 0;
		end

		if(aligncnt < 6'h33 ) begin
			aligncnt <= (aligncnt + 1);
		end

		if(aligncnt == 6'h12) begin
			nxt <= 1;
		end else begin
			nxt <= 0;
		end

		if(aligncnt == 6'h33) begin
			divdone <= 1;
		end
	end

	//properly assign operands, quotient and remainder for signed/unsigned division and the signs of each operand
	always_comb begin
		alb = shiftedb;

		if(signdiv == 1) begin
			if( a[constind] == 1 ) begin
				ua = ~(a - 1);
				r = ~ur + 1;
			end else begin
				ua = a;
				r = ur;
			end

			if( b[constind] == 1 ) begin
				ub = ~(b - 1);
			end else begin
				ub = b;
			end

			if( a[constind] ^ b[constind] ) begin
				q = ~uq + 1;
			end else begin
				q = uq;
			end

		end else begin
			ua = a;
			ub = b;
			q = uq;
			r = ur;
		end
	end

endmodule
