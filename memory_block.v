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
    input logic read,
    input logic [3:0] byte_en,
    input logic[31:0] writedata,
    output logic[31:0] readdata
);
    parameter RAM_INIT_FILE = "";

    reg [31:0] memory [32'hFFFFFFFF:0];

    initial begin
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<32'hFFFFFFFF; i++) begin
            memory[i]=0;
        end
        /* Load contents from file if specified */
        if (RAM_INIT_FILE != "") begin
            $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(RAM_INIT_FILE, memory);
        end
    end

    /* Combinatorial read path. */
    assign readdata = read ? memory[address] : 32'hxxxxxxxx;

    /* Synchronous write path */
    always_ff @(posedge clk) begin
        $display("RAM : INFO : read=%h, addr = %h, mem=%h", read, address, memory[address]);
        if (write) begin
            memory[address] <= writedata;
        end
    end
endmodule