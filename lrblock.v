module lrblock(
    input logic lr_en,
    input logic [2:0] lrmux,
    input logic [31:0] bout,
    input logic [31:0] masked_data,
    output logic [31:0] final_data
);
    assign final_data = masked_data;

    // logic [23:0] quarter1;
    // logic [15:0] quarter2;
    // logic [7:0] quarter3;
    // logic [7:0] quarter4;
    // logic [15:0] quarter5;
    // logic [23:0] quarter6;
    // logic [23:0] quarter7;
    // logic [15:0] quarter8;
    // logic [7:0] quarter9;
    // logic [7:0] quarter10;
    // logic [15:0] quarter11;
    // logic [23:0] quarter12;
    // always_comb begin
    // quarter1 = bout[23:0];
    // quarter2 = bout[15:0];
    // quarter3 = bout[7:0];
    // quarter4 = masked_data[31:24];
    // quarter5 = masked_data[31:16];
    // quarter6 = masked_data[31:8];
    // quarter7 = masked_data[23:0];
    // quarter8 = masked_data[15:0];
    // quarter9 = masked_data[7:0];
    // quarter10 = bout[31:24];
    // quarter11 = bout[31:16];
    // quarter12 = bout[31:8];
    //   case(lr_en)
    //   0: final_data = masked_data;
    //   1: case(lrmux)
    //     3'b000: final_data = {quarter4, quarter1};
    //     3'b001: final_data = {quarter5, quarter2};
    //     3'b010: final_data = {quarter6, quarter3};
    //     3'b011: final_data = masked_data[31:0];
    //     3'b100: final_data = masked_data[31:0];
    //     3'b101: final_data ={quarter10, quarter7};
    //     3'b110: final_data ={quarter11, quarter8};
    //     3'b111: final_data ={quarter12, quarter9};
    //     endcase
    // endcase
    // end
    
endmodule
