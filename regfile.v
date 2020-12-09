module regfile (
    input logic clk, rst, wren,
    input logic [4:0] rr1, rr2, wr,
    input logic [31:0] wd,
    output reg [31:0] rs, rt, v0, r0
);
logic a = 5'b00010;
logic b = 0;
//register vector and integer read/write values
reg [31:0] register [31:0];
assign rs = register[rr1];
assign rt = register[rr2];
assign v0 = register [2];
assign r0 = register[0];
integer i;
initial begin
for(i=1; i<32; i=i+1) begin
register[i] <= 32'd0;
 end
end
always @(posedge clk)
begin
register[0] =0;
if(rst) for(i=0; i<32; i = i+1) register[i] = 32'd0;
else if (wren ==1)
if(wr!=0) register[wr] =wd;
end
endmodule
