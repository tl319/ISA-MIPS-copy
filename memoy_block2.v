module mips_memory (
    input logic clk,
    input logic[31:0] address,
    input logic wr_en,
    input logic read_en,
    input logic[3:0] byte_en,
    input logic[31:0] data_in,
    input logic active,
    output logic[31:0] data_out
);

    parameter RAM_INIT_FILE = "";

    reg[7:0] memory [1073741824:0];

    initial begin
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<1073741824; i++) begin
            memory[i]=0;
        end
        /* Load contents from file if specified */
        if (RAM_INIT_FILE != "") begin
            $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(RAM_INIT_FILE, memory);
        end
    end

    always_ff @(posedge clk) begin
        if (wr_en) begin
            if (byte_en[0]) begin
                memory[address] <= data_in[7:0];
            end
            if (byte_en[1]) begin
                memory[address+1] <= data_in[15:8];
            end
            if (byte_en[0]) begin
                memory[address+2] <= data_in[23:16];
            end
            if (byte_en[0]) begin
                memory[address+3] <= data_in[31:23];
            end
        end
        if (read_en) begin
            data_out <= {memory[address], memory[address+1], memory[address+2], memory[address+3]};
        end
    end

    always@(posedge clk)begin
        if ( active == 1'b0  ) begin
            integer i;
            for (i = 0 ; i < 1073741824; i++) begin
                if(memory[i] != 0 ) begin
                    $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
                end
            end
        end
    end


           
 

endmodule