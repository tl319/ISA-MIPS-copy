module single_reg_5bit_en(
    input logic clk, rst,
    input logic wr_en,
    input logic [4:0]  p,
    output logic [4:0] q
);
	logic single_reg;

	always_ff @(posedge clk, posedge rst) begin

		if (rst == 1) begin
			q <= 5'b00000;
		end
		else if (wr_en == 1) begin
			q <= p;
		end
		//else begin
			//q <= single_reg;
	//	end

	end

endmodule
