module mips_tb;
    timeunit 1ns / 10ps;

    parameter RAM_INIT_FILE = "";
    parameter DATA_INIT_FILE = "";
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
    logic waitrequest;

    mips_memory #(RAM_INIT_FILE) ramInst(clk, active, address, write, read, byte_en, waitrequest, writedata, readdata);

    mips_cpu_bus cpuInst(clk, rst, active, register_v0, address, write, read, waitrequest, writedata, byte_en, readdata);

    //Generate clock
    initial begin
        integer i;
        i=0;
        clk=0;
        waitrequest=0;
        $display("CPU reset");
        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
            i=i+1;
            // $display("%d cycle",i);

            //$display("state: %h", state);
            //$display("MemToReg: %b", MemToReg);
            //$display("final_data: %h", final_data);
            //$display("masked_data: %h", masked_data);
            //$display("WriteRegData : %h",WriteRegData );
            //$display("RegWrite : %h", RegWrite );
            //$display("Dst: %d", Dst);

          //   $display("address: %h",address);

          //   $display("readdata: %h", readdata);
          //   $display("write: %b", write);
          // //  $display("ALUSrcA: %b", ALUSrcA);
          //   //$display("regaout %h", regaout);
          //   //$display("SrcAOut: %h", SrcAOut);
          //   //$display("ALUSrcB: %b", ALUSrcB);
          // //  $display("regbout: %h", regbout);
          // //  $display("SrcBOut: %h", SrcBOut);
          //   $display("writedata: %h", writedata);
          // //  $display("aluresult: %h", aluresult);
          // //  $display("aluout: %h", aluout);
          //   // $display("active: %b",active);
        end

        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end

    initial begin
        rst <= 0;
        $dumpfile("cpu_toplvl_waves.vcd");
        $dumpvars(1,cpuInst);
        @(posedge clk);
        rst <= 1;
        @(posedge clk);
        rst <= 0;
        $display("CPU reset");
        @(posedge clk);
        assert(active==1)
        else $display("TB : CPU did not set active=1 after reset.");

        while (active) begin
            @(posedge clk);
            // $display( "v0 : %h",register_v0);
            if(~waitrequest & (read | write))
            begin
              $display("MEM_ADDRESS: %h", address);
            end
        end
        // $display( "v0 : %h",register_v0);
         //$dumpfile("cpu_all_waves.vcd");
         //$dumpvars(0,mips_tb);
        if(!active)begin
          $display( "v0: %h",register_v0);
        end
        $display("active: %b",active);
        //$dumpfile("cpu_toplvl_waves.vcd");
        //$dumpvars(0,cpuInst);
        $display("TB : finished; running=0");

        $finish;

    end



endmodule
