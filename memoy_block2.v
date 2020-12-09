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

    parameter RAM_INIT_FILE = "./test/binary/basics.hex.txt";

    reg[7:0] memory [2047:0];

    logic[31:0] simp_address;

    assign simp_address=(address<32'b10111100111100000000000000000000) ? address : address-32'b10111100111100000000000000000000 + 32'b00000000000000000000010000000000;
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
        // /* displays content at the start*/
        // for (i=0; i<2048; i++) begin
        //     if(memory[i]!=0)begin
        //         $display("%h: %h", i , memory[i]);
        //     end
        // end
    end

    always_ff @(posedge clk) begin
        if (wr_en) begin
            if (byte_en[0]) begin
                memory[simp_address] <= data_in[7:0];
            end
            if (byte_en[1]) begin
                memory[simp_address+1] <= data_in[15:8];
            end
            if (byte_en[0]) begin
                memory[simp_address+2] <= data_in[23:16];
            end
            if (byte_en[0]) begin
                memory[simp_address+3] <= data_in[31:23];
            end
        end
        if (read_en) begin
            data_out <= {memory[address], memory[address+1], memory[address+2], memory[address+3]};
        end
    end

    always @(!active)begin
        // if ( !active ) begin
            integer i;
           
            // $display("Displaying Memory contents : ");
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