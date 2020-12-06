/*  Implements a 32-bit x 4GB Memory
2^2 across, 2^30 down
print 2^0 down
2^0across, 2^32 down
print 2^2 down
- do byte_enable
*/

module memory_32x4GB(
    input logic clk,
    input logic[31:0] address,
    input logic write,
    input logic [3:0] byte_en,
    input logic[31:0] writedata,
    output logic[31:0] readdata
);
    parameter RAM_INIT_FILE = "";

	 //2^32 bytes  
    reg [7:0] memory [4294967295:0];

    initial begin
        /* Initialise to zero by default */
		  
		  //memory <= { 4294967296{ 8'hFF } };
		  
        for (integer i=0; i<4294967296; i++) begin
            memory[i]=8'h00;
        end
        /* Load contents from file if specified */
        if (RAM_INIT_FILE != "") begin
            $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(RAM_INIT_FILE, memory);
        end
    end

    /* Combinatorial read path. */
	 always_comb begin
			readdata = {memory[address+3], memory[address+2], memory[address+1], memory[address]};
	end

    /* Synchronous write path */
    always_ff @(posedge clk) begin
        //$display("RAM : INFO : read=%h, addr = %h, mem=%h", read, address, memory[address]);
        if (write) begin
				if(byte_en[0] == 1) begin
					memory[address] <= writedata[7:0];
				end
					
				if(byte_en[1] == 1) begin
					memory[address+1] <= writedata[15:8];
				end
				
				if(byte_en[2] == 1) begin
					memory[address+2] <= writedata[23:16];
				end
				
				if(byte_en[3] == 1) begin
					memory[address+3] <= writedata[31:24];
				end
        end
    end
endmodule