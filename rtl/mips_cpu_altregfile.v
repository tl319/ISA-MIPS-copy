module regfile2 (
    input logic clk, rst, wren,
    input logic [4:0] rr1, rr2, wr,
    input logic [31:0] wd,
    output logic [31:0] rs, rt, v0, r0
);

	//register vector and integer read/write values
	logic [31:0] [31:0] registers;
  logic [4:0] x, y;

  initial begin
  x <= 0;
  y <= 5'b00010;
  end

	always_ff @( posedge clk) begin

		 //reset registers to 0 during powerup
		 if(rst == 1) begin
			  registers <= { 32{32'h00000000} };
		 end else

		 //write to
		 if ( wren == 1) begin
				registers [wr] <= wd;
        registers [0] <= 0;
		 end

	end


	//read from
	 always_comb begin
		  rs = registers[ rr1 ];
		  rt = registers[ rr2 ];
		  v0 = registers[ y ];
		  r0 = registers[ x ];
	 end


endmodule
