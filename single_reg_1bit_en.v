module single_reg_1bit_en(
    input logic clk, rst,
    input logic wr_en,
    input logic  p,
    output logic q
);

	always_ff @(posedge clk, posedge rst) begin

		if (rst == 1) begin
			q <= 1'b0;
		end else if(wr_en == 1) begin
			q <= p;
		end else begin
			q <= q;
		end

	end



endmodule
