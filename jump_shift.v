module jump_shift(
    input logic [31:0] irout,
    input logic [31:0] pcout,
    output logic [31:0] pc4jump2
);
    logic [3:0] half1 ;
    logic [25:0] half2;
    always_comb begin
    pc4jump2 = {half1, half2, 2'b00};
    end
endmodule
