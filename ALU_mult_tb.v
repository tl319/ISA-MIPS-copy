module ALU_mult_tb;
    logic clk;
    logic [31:0] a, b;
    logic [3:0] ctrl;
    logic [31:0] result;
    logic [1:0] comp;

    ALU ALU_DUT(
        .a(a), .b(b),
        .ctrl(ctrl),
        .out(result)
    );

    initial begin
        clk = 0;
        repeat(0) begin
            #1
            clk = !clk;
            #1
            clk = !clk;
        end
    end

    initial begin
        a = 5;
        b = 4;
        ctrl = 4'b1010;
        @(posedge clk);
        ctrl = 4'b1011;
        @(posedge clk);
        a = 4;
        b = 3;
        ctrl = 4'b1010;
        @(posedge clk);
        ctrl = 4'b1011;
        @(posedge clk);
        a = 2111222333;
        b = 2;
        ctrl = 4'b1010;
        @(posedge clk);
        ctrl = 4'b1011;
        @(posedge clk);
        a = 2111222333;
        b = 2111222333;
        ctrl = 4'b1010;
        @(posedge clk);
        ctrl = 4'b1011;
        @(posedge clk);
    end
endmodule