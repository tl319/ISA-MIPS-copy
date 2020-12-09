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

    reg[7:0] memory [2047:0];

    logic[31:0] simp_address;

    assign simp_address=(address<32'hBCF00000) ? address : address-32'hBFC00000 + 32'h00000400;
    initial begin
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<2048; i++) begin
            memory[i]=0;
        end
        /* Load contents from file if specified */
        if (RAM_INIT_FILE != "") begin
            $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(RAM_INIT_FILE, memory,1024,2047);
        end
    end

    always @(posedge clk) begin
        // $display("%h",address);
        if (wr_en) begin
            if (byte_en[3]) begin
                memory[simp_address] <= data_in[31:23];
            end
            if (byte_en[2]) begin
                memory[simp_address+1] <= data_in[23:15];
            end
            if (byte_en[1]) begin
                memory[simp_address+2] <= data_in[15:7];
            end
            if (byte_en[0]) begin
                memory[simp_address+3] <= data_in[7:0];
            end
        end 
        if (read_en) begin
            $display("inside ram address %h",simp_address);
            data_out <= {memory[simp_address], memory[simp_address+1], memory[simp_address+2], memory[simp_address+3]};
        end
    end

    always @(!active)begin
        // if ( !active ) begin
            integer i;
           
            $display("Displaying Memory contents : ");
            // $display("address(hex): memory_content(hex) ");
            for (i = 0 ; i < 1024; i++) begin
                if(memory[i] != 0 ) begin
                    $display("%h: %h", i ,memory[i]);
                end
            end
           
            for (i = 1024 ; i < 2048; i++) begin
                if(memory[i] != 0 ) begin
                    $display("%h: %h", (i-1024+3169845248) , memory[i]);
                end
            end
    end
endmodule

module mips_memory_tb;
    logic clk;
    logic active;
    logic wr_en;
    logic read_en;
    logic[31:0] address;
    logic[3:0] byte_en;
    logic[31:0] data_in;
    logic[31:0] data_out;

    initial begin
        clk = 0;
        wr_en = 1;
        read_en = 0;
        address = 8;
        byte_en = 4'b1111;
        data_in = 79;

        #10
        clk = 1;

        #10
        clk = 0;
        wr_en = 0;
        read_en = 1;
        data_in = 0;

        #10
        clk = 1;

        #10
        $display("data_out: %h", data_out);
    end

    mips_memory memInst(clk, active, address, wr_en, read_en, byte_en, data_in, data_out);
endmodule