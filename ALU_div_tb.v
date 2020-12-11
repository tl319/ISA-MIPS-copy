module ALU_div_tb;

    logic clk, rst, signdiv, done;
    logic [31:0] dividend, divisor, result;
    logic [3:0] ctrl;
    logic [1:0] comp;

    ALU ALU_div(
        .a(dividend), .b(divisor),
        .ctrl(ctrl),
        .clk(clk), .divrst(rst),
        .out(result), .comp(comp)
    );

    initial begin
        clk = 0;
        repeat (70) begin
            #10
            clk = !clk;
            #10
            clk = !clk;
        end
    end

    initial begin
        rst <= 0;
        dividend <= 32'hF0000000;
        divisor <= 32'h00000002;
        ctrl <= 4'b1100;
        @(posedge clk);
        rst <= 1;
        @(posedge clk);
        rst <= 0;

        $dumpfile("ALU_div_waves.vcd");
        $dumpvars(0,ALU_div);
    end

endmodule 