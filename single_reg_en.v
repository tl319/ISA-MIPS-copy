module single_reg_en(
    input logic clk, rst, WrEn,
    input logic [31:0] p,
    output logic [31:0] q
);

	always_ff @(posedge clk, posedge rst) begin	
		if (rst == 1) begin
			q <= 32'h00000000;
		end 
        else begin
            if (WrEn) begin
                q <= p; 
            end
		end
	end
    
endmodule