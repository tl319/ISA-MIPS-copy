module single_reg(
    input logic clk, rst,
    input logic [31:0] p,
    output logic [31:0] q
);

	logic [31:0] z = 32'h0000;
	
	always_ff @(posedge clk, posedge rst) begin	

		if (rst == 1) begin
			q <= z;
		end else begin
			q <= p; 
		end
			
	end


    
endmodule