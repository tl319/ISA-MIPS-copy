module ALU_mult_tb;
    logic clk;
    logic [31:0] a, b;
    logic [3:0] ctrl;
    logic [31:0] result;
    //logic [63:0] total;
    logic [1:0] comp;

    ALU ALU_DUT(
        .a(a), .b(b),
        .ctrl(ctrl),
        .out(result),
        .clk(clk)
        //.total(total)
    );

    initial begin
        clk = 0;
        repeat(18) begin
            #1
            clk = !clk;
            #1
            clk = !clk;
        end
    end

    initial begin
        $dumpfile("ALU_mult_waves.vcd");
        $dumpvars(0,ALU_DUT);

        a <= 5;
        b <= 4;
        ctrl <= 4'b1010;
        @(posedge clk);
        ctrl <= 4'b1011;
        @(posedge clk);
        a <= 4;
        b <= 3;
        ctrl <= 4'b1010;
        @(posedge clk);
        ctrl <= 4'b1011;
        @(posedge clk);
        a <= 2111222333;
        b <= 2;
        ctrl <= 4'b1010;
        @(posedge clk);
        ctrl <= 4'b1011;
        @(posedge clk);
        a <= 2111222333;
        b <= 2111222333;
        ctrl <= 4'b1010;
        @(posedge clk);
        ctrl <= 4'b1011;
        @(posedge clk);

        a <= 5;
        b <= 4;
        ctrl <= 4'b1000;
        @(posedge clk);
        ctrl <= 4'b1001;
        @(posedge clk);
        a <= -4;
        b <= -3;
        ctrl <= 4'b1000;
        @(posedge clk);
        ctrl <= 4'b1001;
        @(posedge clk);
        a <= -2113;
        b <= 2;
        ctrl <= 4'b1000;
        @(posedge clk);
        ctrl <= 4'b1001;
        @(posedge clk);
        a <= 32'hFFFFFFFF;
        b <= 2111222333;
        ctrl <= 4'b1000;
        @(posedge clk);
        ctrl <= 4'b1001;
        @(posedge clk);
    end
endmodule