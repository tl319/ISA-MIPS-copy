module abswitch(
    input logic [31:0] RegA,
    input logic [31:0] RegB,
    input logic switch,
    output logic [31:0] aout,
    output logic [31:0] bout
);
    always_comb begin
    case(switch)
      0: aout = RegA;
      1: aout = RegB;
    endcase
    case(switch)
    0: bout = RegB;
    1: bout = RegA;
    endcase
    end 
endmodule
