module mips_cpu_bus(
  input logic clk,
  input logic reset,
  output logic active,
  output logic [31:0] register_v0,

  output logic[31:0] address,
  output logic write,
  output logic read,
  input logic waitrequest,
  output logic [31:0] writedata,
  output logic [3:0] byteenable,
  input logic [31:0] readdata,
  output logic [3:0] state,
  output logic [31:0] WriteRegData,
  output logic RegWrite,
  output logic [31:0] aluresult,
  output logic [31:0] SrcAOut,
  output logic [31:0] SrcBOut,
  output logic [1:0] ALUSrcA,
  output logic [2:0] ALUSrcB,
  output logic [31:0] regaout,
  output logic [31:0] regbout,
  output logic [4:0] Dst,
  output logic [31:0] aluout,
  output logic [1:0] MemToReg,
  output logic [31:0] final_data,
  output logic [31:0] masked_data

  );
   logic [31:0] constant_1;
    logic [31:0] constant_4;
    logic [31:0] constant_31;
    logic [31:0] constant_0;
    logic [31:0] constant_reset;
    logic reset_mux_cnt;
    logic [31:0] pc_data;
    logic [31:0] final_pc_data;
    //logic [31:0] aluout;
    logic [31:0] pc4_jump2;
    logic [31:0] altpcsrc;
    logic altpcmux_cnt;
    logic [31:0] altpcdata;
    logic alt_pc_write;
  //  logic [31:0] aluresult;
    logic [1:0] pc_src_mux;
    logic pc_write;
    logic [31:0] pc_out;
    logic [1:0] IorD_cnt;
    logic [1:0] alu2out;
    logic [1:0] byte_cnt;
    logic [3:0] byte_EN;
    logic [2:0] msk_cnt;
    //logic [31:0] masked_data;
    logic lr_en;
    logic [1:0] lrmuxLSB;
    logic [31:0] bout;
    //logic [31:0] final_data;
    // logic [3:0] state;
    logic link;
    logic [5:0] ir_opcode;
    logic [5:0] ir_function;
    logic [4:0] ir_info;
    logic [5:0] mem_opcode;
    logic [5:0] mem_function;
    logic [4:0] mem_info;
    logic branch;
    //logic [1:0] MemToReg;
    logic [1:0] RegDst;
    //logic [1:0] ALUSrcA;
    //logic [2:0] ALUSrcB;
    logic ir_write;
    // logic RegWrite;
    logic ABswitch_cnt;
    logic [1:0] extendcont;
    logic hilowrite;
    logic hilosel;
    logic lrmuxMSB;
    logic [3:0] aluop;
    logic link_en;
    logic link_in;
    logic [3:0] prev_state;
    logic jump;
    logic halt;
    //logic [4:0] Dst;
    // logic [31:0] WriteRegData;
    //logic [31:0] regaout;
    //logic [31:0] regbout;
    logic [31:0] hiloout;
    logic [31:0] signimm;
    logic [31:0] shiftimm;
    //logic [31:0] SrcAOut;
    //logic [31:0] SrcBOut;
    logic [1:0] cond;
    logic JumpIN;
    logic Jump_EN;
    logic [31:0] irout;
    logic [31:0] aout;


assign writedata = regbout;
  //    single_reg testreg(
  //    .clk (clk),
  //    .rst (reset),
  //    .p (regbout),
  //    .q (writedata)
  //    );

    const_reg const_register(
    .const_1 (constant_1),
    .const_4 (constant_4),
    .const_31 (constant_31),
    .reset_vector (constant_reset)
    );

    MUX_2 resetmux(
    .a (pc_data),
    .b (constant_reset),
    .select (reset_mux_cnt),
    .out (final_pc_data)
    );

    MUX_2 altpcmux(
    .a (aluout),
    .b (pc4_jump2),
    .select (altpcmux_cnt),
    .out (altpcsrc)
    );

    single_reg_en alt_pc(
    .clk (clk),
    .rst (reset),
    .wr_en (alt_pc_write),
    .p (altpcsrc),
    .q (altpcdata)
    );

    MUX_4 pcsrc_mux(
    .a (aluresult),
    .b (aluout),
    .c (pc4_jump2),
    .d (altpcdata),
    .select (pc_src_mux),
    .out (pc_data)
    );

    single_reg_en_pc pc(
    .clk (clk),
    .rst (reset),
    .wr_en (pc_write),
    .p (final_pc_data),
    .q (pc_out)
    );

    MUX_4 IorD_mux(
    .a (pc_out),
    .b (aluout),
    .c (aluout<<2),
    .d (pc_out),
    .select (IorD_cnt),
    .out (address)
    );

    byte_decoder byte_a(
    .aluout (aluout[1:0]),
    .byte_cnt (byte_cnt),
    .byte_en (byteenable)
    );

    single_reg_en ir(
    .clk (clk),
    .rst (reset),
    .wr_en (ir_write),
    .p (readdata),
    .q (irout)
    );

    wordmask loadword_mask(
    .data (readdata),
    .msk_cnt (msk_cnt),
    .msk_cnt2 (alu2out),
    .masked_data (masked_data)
    );

    lrblock lrblock_a(
    .lr_en (lr_en),
    .lrmux ({lrmuxMSB,lrmuxLSB}),
    .bout (bout),
    .masked_data (masked_data),
    .final_data (final_data)
    );

    decoder decoder_a(
        .clk (clk),
        .state (state),
        .link (link),
        .ir_opcode (irout[31:26]),
        .ir_function (irout[5:0]),
        .ir_info (irout[20:16]),
        .mem_opcode (readdata[31:26]),
        .mem_function (readdata[5:0]),
        .mem_info (readdata[20:16]),
        .wait_request (waitrequest),
        .branch (branch),
        .MemToReg (MemToReg),
        .RegDst (RegDst),
        .PCSrc (pc_src_mux),
        .IorD (IorD_cnt),
        .ALUSrcA (ALUSrcA),
        .ALUSrcB (ALUSrcB),
        .IrWrite (ir_write),
        .MemWrite (write),
        .MemRead (read),
        .PcWrite (pc_write),
        .RegWrite (RegWrite),
        .ABswitch_cnt (ABswitch_cnt),
        .altpcWrite (alt_pc_write),
        .altpcmux (altpcmux_cnt),
        .extendcont (extendcont),
        .resetmux (reset_mux_cnt),
        .hilowrite (hilowrite),
        .hilosel (hilosel),
        .lr_en (lr_en),
        .lrmux (lrmuxMSB),
        .mask_cnt (msk_cnt),
        .byte_cnt (byte_cnt),
        .aluop (aluop),
        .link_en (link_en),
        .link_in (link_in)
      );

      state_machine state_machine_a(
      .clk (clk),
      .prev_state (state),
      .reset (reset),
      .jump (jump),
      .wait_request (waitrequest),
      .halt (halt),
      .state (state),
      .active (active)
      );

      MUX_4_5bit RegDst_mux(
      .a (irout[20:16]),
      .b (irout[15:11]),
      .c (constant_31[4:0]),
      .d (constant_31[4:0]),
      .select (RegDst),
      .out (Dst)
      );

      MUX_4 MemToReg_mux(
      .a (aluout),
      .b (final_data),
      .c (constant_1),
      .d (aluresult),
      .select (MemToReg),
      .out (WriteRegData)
      );

      regfile2 Registers(
      .clk (clk),
      .rst (reset),
      .wren (RegWrite),
      .rr1 (irout[25:21]),
      .rr2 (irout[20:16]),
      .wr (Dst),
      .wd (WriteRegData),
      .rs (regaout),
      .rt (regbout),
      .v0 (register_v0),
      .r0 (constant_0)
      );

      high_low_registers hiloreg_a(
      .clk (clk),
      .reset (reset),
      .ctrl_hi (hilosel),
      .WrEn (hilowrite),
      .input_hi_lo (aluout),
      .out (hiloout)
      );

      sign_extend extender(
      .in (irout[15:0]),
      .select (extendcont),
      .out (signimm)
      );

      shift_l shifter2(
      .in (signimm),
      .out (shiftimm)
      );

      MUX_4 srcamux(
      .a (pc_out),
      .b (aout),
      .c (constant_0),
      .d (hiloout),
      .select (ALUSrcA),
      .out (SrcAOut)
      );

      abswitch switch(
      .RegA (regaout),
      .RegB (regbout),
      .switch (ABswitch_cnt),
      .aout (aout),
      .bout (bout)
      );

      MUX_8 srcbmux(
      .a (bout),
      .b (constant_4),
      .c (signimm),
      .d (shiftimm),
      .e ({constant_0[26:0],irout[10:6]}),
      .f ({constant_0[26:0],bout[4:0]}),
      .g (constant_0),
      .h (constant_0),
      .select (ALUSrcB),
      .out (SrcBOut)
      );

      ALU alu(
      .a (SrcAOut),
      .b (SrcBOut),
      .ctrl (aluop),
      .out (aluresult),
      .comp (cond)
      );
      single_reg alutstore(
      .clk (clk),
      .rst (reset),
      .p (aluresult),
      .q (aluout)
      );

      single_reg_2bit alu2(
      .clk (clk),
      .rst (reset),
      .p (aluout[1:0]),
      .q (alu2out)
      );

      single_reg_1bit_en link_reg(
      .clk (clk),
      .rst (reset),
      .wr_en (link_en),
      .p (link_in),
      .q (link)
      );

      brancher brancher(
      .cond (cond),
      .state (state),
      .opcode (irout[31:26]),
      .fn (irout[5:0]),
      .info (irout[20:16]),
      .JumpIN (JumpIN),
      .Jump_EN (Jump_EN)
      );

      single_reg_1bit_en jump_reg(
      .clk (clk),
      .rst (reset),
      .wr_en (Jump_EN),
      .p (JumpIN),
      .q (jump)
      );

      jump_shift jumpshifter(
      .irout (irout),
      .pcout (pc_out),
      .pc4jump2 (pc4_jump2)
      );

      halter halter_a(
        .pcout (pc_out),
        .state (state),
        .clk (clk),
        .rst (reset),
        .halt (halt)
      );
endmodule
