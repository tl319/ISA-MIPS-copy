module single_reg(
    input logic clk, rst,
    input logic [31:0] p,
    output logic [31:0] q
);

	logic [31:0] single_reg;

	always_ff @(posedge clk, posedge rst) begin	

		if (rst == 1) begin
			single_reg <= 32'h00000000;
		end
		else begin
			single_reg <= p; 
		end
		q <= single_reg;
	end
	
endmodule