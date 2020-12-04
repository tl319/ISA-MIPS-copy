/*
register to store the 2 LSB's of ALU out
*/

module two_bit_registers(

    input logic clk,
    input logic WrEn,
    input logic [1:0] two_bit_input,
    output logic [1:0] out
    );

    logic [1:0] two_bit_reg;

    always_ff @(posedge clk) begin
        
        case(WrEn)

        0: out <= two_bit_reg ;
        1: out <= two_bit_reg ;
            two_bit_reg <= two_bit_input ;

        endcase
        
    end
    
endmodule