module single_reg_en(
    input logic clk, rst, wr_en,
    input logic [31:0] p,
    output logic [31:0] q
);

    logic [31:0] single_reg;

	always_ff @(posedge clk, posedge rst) begin	

		if (rst == 1) begin
			q <= 32'h00000000 ;
		end 
        else if (wr_en == 1) begin
            q <= p ;
		end
        //else begin
          //  q <= single_reg ;
        //end
	end
    
endmodule
