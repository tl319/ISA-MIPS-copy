//DIV, currently broken

module div(
    input logic [31:0] a, b,
    input logic signdiv, clk, rst,
    output logic [31:0] q, r,
	output logic done
);

	logic rst, nxt;
	//internal operand and result values, as division is unsigned and begins with the divisor shifted to the MSB of quotient (unclear explanation)
	logic [31:0] ua, ub, shiftedb, uq, ur;

	align aligner (
		.clk(clk), .rst(rst), 
		.a(ua), .b(ub), .shiftb(shiftedb),
		.done(nxt)
	);

	divu divider (
		.clk(clk), .rst(nxt),
		.a(ua), .b(shiftedb), .realb(ub),
		.q(uq), .r(ur),
		.done(done)
	);

	//first align b and a, then perform unsigned division
	//always_ff @(posedge clk) begin
		
	//end

	//properly assign operands, quotient and remainder for signed/unsigned division and the signs of each operand 
	always_comb begin
		if(signdiv == 1) begin
			if( a[31] == 1 ) begin
				ua = ~(a - 1);
				r = ~ur + 1;
			end else begin
				ua = a;
				r = ur;
			end

			if( b[31] == 1 ) begin
				ub = ~(b - 1);
			end else begin
				ub = b;
			end

			if( a[31] ^ b[31] ) begin
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