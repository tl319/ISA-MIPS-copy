module mips_memory (
    input logic clk,
    input logic active,
    input logic[31:0] address,
    input logic wr_en,
    input logic read_en,
    input logic[3:0] byte_en,
    input logic[31:0] data_in,
    output logic[31:0] data_out
);

    parameter RAM_INIT_FILE = "";
    parameter DATA_INIT_FILE = "./test/data_binary/initial_data.hex.txt";

    reg[7:0] memory [4095:0];

    logic[31:0] simp_address;

    assign simp_address=(address<32'hBCF00000) ? address : address-32'hBFC00000 + 32'h00000400;
    initial begin
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<4096; i++) begin
            memory[i]=0;
        end
        /* Load contents from file if specified */
        // if (RAM_INIT_FILE == "binary/jalr.hex.txt")begin
        //     $readmemh(DATA_INIT_FILE, memory, 4, 1023);
        // end
        /* Load contents from file if specified */
        if (RAM_INIT_FILE != "") begin
            $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(DATA_INIT_FILE, memory, 4, 1023);
            $readmemh(RAM_INIT_FILE, memory,1024,2047);
            $display("RAM : INIT : DISPLAYING INITIALSIED RAM");
            for (i = 4 ; i < 1024; i++) begin
                if(memory[i] != 0 ) begin
                    $display("RAM : INIT : INITIAL DATA : %h: %h", i ,memory[i]);
                end
            end
            for (i = 1024 ; i < 2048; i++) begin
                if(memory[i] != 0 ) begin
                    $display("RAM : INIT : INITIAL DATA : %0h: %h", i+3217031168-1024 , memory[i]);
                end
            end
        end
    end

    always @(posedge clk) begin
        // $display("%h",address);
        if (wr_en) begin
            if (byte_en[0]==1) begin
                memory[simp_address] <= data_in[7:0];
            end
            if (byte_en[1]==1) begin
                memory[simp_address+1] <= data_in[15:8];
            end
            if (byte_en[2]==1) begin
                memory[simp_address+2] <= data_in[23:16];
            end
            if (byte_en[3]===1) begin
                memory[simp_address+3] <= data_in[31:24];
            end
        end
        if (read_en) begin
            // $display("inside ram address %h",simp_address);
            data_out <= {memory[simp_address+3], memory[simp_address+2], memory[simp_address+1], memory[simp_address]};
        end
    end
    always@(!active)begin
            integer i;
            integer j;
            $display("----------");
            for (i = 0 ; i < 1024; i++) begin
                if(memory[i] != 0 ) begin
                    $display("FINAL MEMORY : %h: %h", i ,memory[i]);
                end
            end
            
            for (j = 1024 ; j < 2048; j++) begin
                if(memory[j] != 0 ) begin
                    $display("FINAL MEMORY : %0h: %h", j+3217031168-1024 , memory[j]);
                end
            end
            $display("----------");
           
    end






endmodule
