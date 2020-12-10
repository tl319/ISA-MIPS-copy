module align (
	input logic clk, rst,
	input logic [31:0] a, b,
	output logic [31:0] shiftb, 
	output logic [15:0] bhigh, blow,
	output logic [3:0] cnt,
	output logic done
);
	logic [31:0] shifted;
	logic [15:0] ahi, alo, bhi, blo;
	logic [3:0] i, ahi_cnt, blo_cnt;
	logic finished, end_lo;
	
	always_comb begin
		cnt = i;
		shiftb = shifted;
		bhigh = bhi;
		blow = blo;
		done = finished;
	end

	always_ff @(posedge clk) begin
		if(rst == 1) begin
			ahi <= a[31:16];
			alo <= a[15:0];
			bhi <= b[31:16];
			blo <= b[15:0];
			i <= 4'h0;
			blo_cnt <= 4'h0;
			ahi_cnt <= 4'h0;
			finished <= 0; 
		end else begin
				
			if (bhi > ahi) begin
				shifted <= (b<<(i-1));
				finished <= 1;
			end else begin
				if(i == 4'hF) begin
					shifted <= (b<<blo_cnt);
					finished <= 1;
				end else begin
					i <= (i + 1);
					bhi <= (bhi << 1);
				end
			end
	
			
			if(blo > alo & end_lo == 0) begin
				blo_cnt <= (i-1);
				end_lo <= 1;
			end else begin
				blo <= (blo << 1);
			end
			
		end
		
	end
	
endmodule