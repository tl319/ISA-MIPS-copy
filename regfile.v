module regfile (
    input logic clk, rst, wren,
    input logic [4:0] rr1, rr2, wr,
    input logic [31:0] wd,
    output logic [31:0] rs, rt, v0, r0
);

	//register vector and integer read/write values
	logic [31:0] [31:0] registers;
	logic [31:0] z, t;	

	initial begin
		z <= 0;
		t <= 32'h00000002; 
	end
  
	always_ff @( posedge clk, posedge rst ) begin
	
		 //reset registers to 0 during powerup
		 if(rst == 1) begin
			  registers <= { 32{32'h00000000} };
		 end else 
		 
		 //write to	 
		 if ( wren == 1) begin
				registers [wr] <= wd;
		 end	

	end
	
	
	//read from
	 always_comb begin
		  rs = registers[ rr1 ];
		  rt = registers[ rr2 ];
		  v0 = registers[ t ];
		  r0 = registers[ z ];  
	 end

    
endmodule
