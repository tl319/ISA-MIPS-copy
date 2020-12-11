module div_tb;

    logic clk, rst, signdiv, done;
    logic [31:0] dividend, divisor, quotient, remainder;

    div division(
        .a(dividend), .b(divisor),
        .clk(clk), .divrst(rst), .signdiv(signdiv),
        .q(quotient), .r(remainder)
        //.done(done)
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
        dividend <= 32'h00000009;
        divisor <= 32'h00000002;
        @(posedge clk);
        rst <= 1;
        @(posedge clk);
        rst <= 0;

        $dumpfile("div_waves.vcd");
        $dumpvars(0,division);
    end

endmodule 