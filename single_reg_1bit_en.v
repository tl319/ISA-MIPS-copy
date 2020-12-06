module single_reg_1bit_en(
    input logic clk, rst,
    input logic wr_en,
    input logic  p,
    output logic q
);
	logic single_reg;

	always_ff @(posedge clk, posedge rst) begin

		if (rst == 1) begin
			single_reg <= 1'b0;
		end 
		else if (wr_en == 1) begin
			single_reg <= p;
		end 
		else begin
			q <= single_reg;
		end

	end

endmodule
