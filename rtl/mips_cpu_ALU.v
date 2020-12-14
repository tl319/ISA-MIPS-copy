module ALU(
    input logic [31:0] a, b,
    input logic [3:0] ctrl,
    input logic clk, divrst,
    output logic signed [31:0] out,
    output logic [1:0] comp,
    output logic divdone
);
    logic signed [31:0] sraa;
    logic signed [31:0] srab;
    assign sraa = a;
    assign srab = b;
    //signals and module for division
    logic S;
    logic [31:0] divq, divr;

    //hi, lo and internal values for multiplication
    logic [31:0] hi, lo, shi, slo;
    logic [4:0] constto;
    logic [31:0] amag, bmag; //magnitude of a and b

    //used a constant decimal 31 as Icarus doesn't support constant indexing
    initial begin
        constto <= 5'b11111;
    end

    always_comb begin
        //always computing both MULT and MULTU instead of using an if reduces the critical path at the expense of circuit compactness,
        //though it is likely that the time gain is far less significant than the area increase.

        //unsigned product, total is just for testing
        {hi, lo} = a*b;
        //total = a*b;

        //signed product, stotal is just for testing
        amag = a[constto] ? (~a + 1) : a;
        bmag = b[constto] ? (~b + 1) : b;
        {shi, slo} = (a[constto] ^ b[constto]) ? ( ~(amag * bmag) + 1 ) : (amag*bmag);
        //stotal = (a[constto] ^ b[constto]) ? ( ~(amag * bmag) + 1 ) : (amag*bmag);

    end

    div division(
        .a(a), .b(b),
        .clk(clk), .divrst(divrst), .signdiv(S),
        .q(divq), .r(divr),
        .divdone(divdone)
    );

    always_comb begin

			if ($signed(a) == $signed(b)) begin
				comp = 2'b00;
			end else if
			($signed(a) < $signed(b)) begin
				comp = 2'b01;
			end else if
			($signed(a) > $signed(b)) begin
				comp = 2'b10;
			end

        case(ctrl)
            4'b0000: out = a + b;   //ADD
            4'b0001: out = a - b;   //SUB
            4'b0010: out = a & b;   //AND bitwise
            4'b0011: out = a | b;   //OR bitwise
            4'b0100: out = a ^ b;   //XOR bitwise
            4'b0101: out = a<<b;  //SLL
            4'b0110: out = a>>b;  //SRL
            4'b0111: out = sraa>>>srab; //SRA

            4'b1001: out = shi;         //MULT TOP
            4'b1000: out = slo; //MULT BOT
            4'b1011: out = hi;       //MULTU TOP
            4'b1010: out = lo; //MULTU BOT

            4'b1100: begin //DIV
                S = 1;
                out = divq;
            end
            4'b1101: begin //MOD
                //S = 1;
                out = divr;
            end
            4'b1110: begin //DIVU
                S = 0;
                out = divq;
            end
            4'b1111: begin //MODU
                //S = 0;
                out = divr;
            end

            /*
            //placeholder for DIV and MOD operations
            4'b1100: out = 32'h00000000;
            4'b1101: out = 32'h00000000;
            4'b1110: out = 32'h00000000;
            4'b1111: out = 32'h00000000;  */
        endcase
    end
endmodule
