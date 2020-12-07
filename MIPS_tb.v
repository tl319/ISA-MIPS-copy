module mips_tb;
    timeunit 1ns / 10ps;

    parameter RAM_INIT_FILE = "test/binary/countdown.hex.txt";
    parameter TIMEOUT_CYCLES = 10000;

    logic clk;
    logic rst;

    logic active;

    logic[31:0] address;
    logic write;
    logic read;
    logic[31:0] writedata;
    logic[31:0] readdata;
    logic[31:0] register_v0;
    logic[3:0] byte_en;
    logic waterequest;

    // mips_memory #(RAM_INIT_FILE) ramInst(clk, active, address, write, read, byte_en, writedata, readdata);
    
    mips_cpu_bus cpuInst(clk, rst, active, register_v0, address, write, read, waitrequest, writedata, byte_en, readdata);
    
    // Generate clock
    // initial begin
    //     clk=0;
    //     $display("CPU reset");
    //     repeat (TIMEOUT_CYCLES) begin
    //         #10;
    //         clk = !clk;
    //         #10;
    //         clk = !clk;
    //     end

    //     $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    // end

    // initial begin
    //     rst <= 0;

    //     @(posedge clk);
    //     rst <= 1;

    //     @(posedge clk);
    //     rst <= 0;
    //     $display("CPU reset");
    //     @(posedge clk);
    //     assert(active==1)
    //     else $display("TB : CPU did not set running=1 after reset.");

    //     // while (active) begin
    //     //     @(posedge clk);
    //     // end

    //     $display("TB : finished; running=0");

    //     $finish;
        
    // end

    

endmodule