module regfile (
    input logic clk, rst, wren,
    input logic [4:0] rr1, rr2, wr,
    input logic [31:0] wd,
    output logic [31:0] rs, rt, 
);

    //register vector and integer read/write values
    logic [31:0] registers [31:0];
    //is this, legal? Also does it make the value immutable
    registers[0] = 32'h0000;
    integer irr1, irr2, iwr;

    //reset registers to 0 during powerup?
  
    //read from
    always_comb (rr1, rr2) begin
        //is this necessary? can it assign negative values? 
        irr1 = rr1;
        irr2 = rr2;

        rs = registers[ irr1 ];
        rt = registers[ irr2 ];  
    end

    //write to
    always_ff @(posedge clk) begin
        if (wren == 1)
            //is this necessary? can it assign negative values?
            irw = rw;
            registers [irw] <= wd;
    end
endmodule