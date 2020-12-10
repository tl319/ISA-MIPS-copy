module single_reg_1bit(
    input logic clk, rst,
    input logic  p,
    output logic q
);

	logic single_reg;

	always_ff @(posedge clk, posedge rst) begin

		if (rst == 1) begin
			q <= 1'b0;
		end
		else begin
			q <= p;
		end
	//	q <= single_reg;
	end

endmodule
