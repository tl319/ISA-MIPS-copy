module ALU_div_tb;

    logic clk, rst, signdiv, done;
    logic [31:0] dividend [0:1];
    logic [31:0] divisor [0:1]; 
    logic [31:0] a, b, result;
    logic [3:0] ctrl;
    logic [1:0] comp;
    integer wrq, wrr, i;

    //parameter dividend = "dividend.txt";
    //parameter divisor = "divisor.txt";

    ALU ALU_div(
        .a(a), .b(b),
        .ctrl(ctrl),
        .clk(clk), .divrst(rst),
        .out(result), .comp(comp)
    );

    initial begin
        clk = 0;
        repeat (106) begin
            #10
            clk = !clk;
            #10
            clk = !clk;
        end
    end

    initial begin
        $dumpfile("ALU_div_waves.vcd");
        $dumpvars(0,ALU_div);
        $readmemh( "dividend.txt", dividend );
        $readmemh( "divisor.txt", divisor );
        wrq = $fopen("quotient_out.txt");
        wrr = $fopen("remainder_out.txt");
        //for(i = 0; i<2; i++) begin
            a = dividend[1];
            b = divisor[1];
            $display("-0-");
            $display(a);
            $display(b);
            rst = 0;
            //dividend <= 32'h00000005;
            //divisor <= 32'h00000002;
            ctrl = 4'b1100;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            $fwrite(wrq, "%h\n", result);
            //$display(result);
            @(posedge clk);
            ctrl = 4'b1101;
            @(posedge clk);
            $fwrite(wrr, "%h\n", result);
            //$display(result);
        //end
        
            a = dividend[1];
            b = divisor[1];
            $display("-1-");
            $display(a);
            $display(b);
            rst = 0;
            //dividend <= 32'h00000005;
            //divisor <= 32'h00000002;
            ctrl = 4'b1110;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            
            $fwrite(wrq, "%h\n", result);
            //$display(result);
            @(posedge clk);
            ctrl = 4'b1111;
            @(posedge clk);
            $fwrite(wrr, "%h\n", result);
            //$display(result);
            
    end

endmodule 