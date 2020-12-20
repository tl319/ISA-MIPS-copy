module decoder(
    input logic clk,
    input logic [3:0] state,
    input logic link,
    input logic [5:0] ir_opcode,
    input logic [5:0] ir_function,
    input logic [4:0] ir_info,
    input logic [5:0] mem_opcode,
    input logic [5:0] mem_function,
    input logic [4:0] mem_info,
    input logic wait_request,
    //input logic branch,
    output logic [1:0] MemToReg,
    output logic [1:0] RegDst,
    output logic [1:0] PCSrc,
    output logic [1:0] IorD,
    output logic [1:0] ALUSrcA,
    output logic [2:0] ALUSrcB,
    output logic IrWrite,
    output logic MemWrite,
    output logic MemRead,
    output logic PcWrite,
    output logic RegWrite,
    output logic ABswitch_cnt,
    output logic altpcWrite,
    output logic altpcmux,
    output logic [1:0] extendcont,
    output logic resetmux,
    output logic hilowrite,
    output logic hilosel,
    output logic lr_en,
    output logic lrmux,
    output logic [2:0] mask_cnt,
    output logic [1:0] byte_cnt,
    output logic [3:0] aluop,
    output logic link_en,
    output logic link_in,
    input logic divdone,
    output logic divrst,
    output logic extend_mux,
    output logic byte_store_en,
    output logic half_store_en,
    input logic [1:0] cond,
    output logic bool_cnt,
    output logic alt_link_reg_en,
    output logic altlink,
    input logic [1:0] condu
);
    logic beq;
    logic bgez;
    logic bgtz;
    logic blez;
    logic bltz;
    logic bne;
    logic bgezal;
    logic bltzal;
    logic slti;
    logic sltiu;
    logic slt;
    logic sltu;
    logic subu;
    logic lw;
    logic sw;
    logic addu;
    logic addiu;
    logic lui;
    logic mthi;
    logic mtlo;
    logic mfhi;
    logic mflo;
    logic lb;
    logic lbu;
    logic lh;
    logic lhu;
    logic sb;
    logic sh;
    logic lwl;
    logic lwr;
    logic jr;
    logic jalr;
    logic andi;
    logic andINT;
    logic ori;
    logic orINT;
    logic xori;
    logic xorINT;
    logic sll;
    logic sllv;
    logic sra;
    logic srav;
    logic srl;
    logic srlv;
    logic div;
    logic divu;
    logic mult;
    logic multu;
    logic j;
    logic jal;
    logic nop;
    always_comb begin
        case(state)
        4'b000: begin
 beq = 0;
        bgez = 0;
        bgtz = 0;
        blez = 0;
        bltz = 0;
        bne = 0;
        bgezal = 0;
        bltzal = 0;
        slti = 0;
        sltiu = 0;
        slt = 0;
        sltu = 0;
        subu = 0;
        lw = 0;
        sw = 0;
        addu = 0;
        addiu = 0;
        lui = 0;
        mthi = 0;
        mtlo = 0;
        mfhi = 0;
        mflo = 0;
        lb = 0;;
        lbu = 0;
        lh  = 0;
        lhu = 0;
        sb  = 0;
        sh = 0;
        lwl = 0;
        lwr = 0;
        jr = 0;
        jalr = 0;
        andi = 0;
        andINT  = 0;
        ori = 0;
        orINT = 0;
        xori = 0;
        xorINT= 0;
        sll = 0;
        sllv = 0;
        sra = 0;
        srav = 0;
        srl = 0;
        srlv = 0;
        div = 0;
        divu = 0;
        mult = 0;
        multu = 0;
        j = 0;
        jal = 0;
        nop = 0;
        MemToReg = 2'b00;
        RegDst = 2'b00;
        IorD = 2'b00;
        PCSrc = 2'b00;
        ALUSrcA = 2'b00;
        ALUSrcB = 3'b 001;
        IrWrite = 1;
        MemWrite = 0;
        MemRead = 1;
        PcWrite = 1;
        RegWrite = 0;
        ABswitch_cnt =0;
        extendcont = 2'b10;
        altpcWrite = 0;
        altpcmux = 0;
        resetmux = 0;
        hilowrite = 0;
        if (mfhi ==1) begin
        hilosel =1;
        end else begin
        hilosel = 0;
        end
        lr_en = 0;
        lrmux = 0;
        mask_cnt = 3'b000;
        byte_cnt = 2'b00;
        aluop = 4'b0000;
        link_en = 0;
        link_in = 0;
        divrst = 0;
        extend_mux = 0;
        byte_store_en = 0;
        half_store_en =0;
        bool_cnt =0;
        alt_link_reg_en = 0;
        altlink = 0;
        end
      4'b0001: begin
        if(mem_opcode == 6'b000100) begin
        beq = 1;
        end else if(mem_opcode == 6'b000001 && mem_info == 5'b00001) begin
        bgez = 1;
        end else if(mem_opcode == 6'b000111 && mem_info == 5'b00000) begin
        bgtz = 1;
        end else if(mem_opcode == 6'b000110 && mem_info == 5'b00000) begin
        blez = 1;
        end else if(mem_opcode == 6'b000001 && mem_info == 5'b00000) begin
        bltz = 1;
        end else if(mem_opcode == 6'b000101) begin
        bne = 1;
        end else if(mem_opcode == 6'b000001 && mem_info == 5'b10001) begin
        bgezal = 1;
        end else if(mem_opcode == 6'b000001 && mem_info == 5'b10000) begin
        bltzal = 1;
        end else if(mem_opcode == 6'b001010) begin
        slti = 1;
        end else if(mem_opcode == 6'b001011) begin
        sltiu =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b101010) begin
        slt = 1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b101011) begin
        sltu = 1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b100011) begin
        subu = 1;
        end else if(mem_opcode == 6'b100011) begin
        lw = 1;
        end else if(mem_opcode == 6'b101011) begin
        sw =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b100001) begin
        addu =1;
        end else if(mem_opcode == 6'b001001) begin
        addiu =1;
        end else if(mem_opcode == 6'b001111) begin
        lui =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b010001) begin
        mthi =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b010011) begin
        mtlo =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b010000) begin
        mfhi =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b010010) begin
        mflo =1;
        end else if(mem_opcode == 6'b100000) begin
        lb =1;
        end else if(mem_opcode == 6'b100100) begin
        lbu =1;
        end else if(mem_opcode == 6'b100001) begin
        lh =1;
        end else if(mem_opcode == 6'b100101) begin
        lhu =1;
        end else if(mem_opcode == 6'b101000) begin
        sb =1;
        end else if(mem_opcode == 6'b101001) begin
        sh =1;
        end else if(mem_opcode == 6'b100010) begin
        lwl =1;
        end else if(mem_opcode == 6'b100110) begin
        lwr =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b001000) begin
        jr =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b001001) begin
        jalr =1;
        end else if(mem_opcode == 6'b001100) begin
        andi =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b100100) begin
        andINT=1;
        end else if(mem_opcode == 6'b001101) begin
        ori =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b100101) begin
        orINT=1;
        end else if(mem_opcode == 6'b001110) begin
        xori =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b100110) begin
        xorINT=1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b000000) begin
        sll =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b000100) begin
        sllv =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b000011) begin
        sra =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b000111) begin
        srav =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b000010) begin
        srl =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b000110) begin
        srlv =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b011010) begin
        div =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b011011) begin
        divu =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b011000) begin
        mult =1;
        end else if(mem_opcode == 6'b000000 && mem_function == 6'b011001) begin
        multu =1;
        end else if(mem_opcode == 6'b000010) begin
        j =1;
        end else if(mem_opcode == 6'b000011) begin
        jal =1;
        end else begin
        nop =1;
        end
        MemToReg = 2'b00;
        if(addiu == 1 || andi == 1 || ori == 1 || xori == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 || lui == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb == 1 || sh == 1 || lwl == 1 || lwr == 1 || beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        RegDst = 2'b00;
        end else if(addu == 1 || andINT== 1 || subu == 1 || orINT== 1 || xorINT== 1 || sll == 1 || sllv == 1 || sra == 1 || srav == 1 || srl == 1 || srlv == 1 || slt == 1 || sltu == 1 || div == 1 || divu == 1 || mult == 1 || multu == 1 || mfhi == 1 || mflo == 1 || jr == 1) begin
        RegDst = 2'b01;
        end else if(jal == 1 || jalr == 1) begin
        RegDst = 2'b10;
        end else begin
        RegDst = 2'b00;
        end
        IorD = 2'b00;
        PCSrc = 2'b10;
        ALUSrcA = 2'b00;
        ALUSrcB = 3'b011;
        IrWrite = 0;
        MemWrite = 0;
        MemRead = 0;
        PcWrite = 0;
        RegWrite = 0;
        ABswitch_cnt =0;
        if(addiu == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb == 1 || sh == 1 || lwl == 1 || lwr == 1 || beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        extendcont = 2'b10;
        end else if(lui == 1) begin
        extendcont = 2'b11;
        end else begin
        extendcont = 2'b00;
        end
        if(j == 1 || jal ==1) begin
        altpcWrite = 1;
        end else begin
        altpcWrite = 0;
        end
        altpcmux = 1;
        resetmux = 0;
        hilowrite = 0;
        if (mfhi ==1) begin
        hilosel =1;
        end else begin
        hilosel = 0;
        end
        lr_en = 0;
        if (lwr == 1) begin
        lrmux = 1;
        end else begin
        lrmux = 0;
        end
        mask_cnt = 3'b000;
        byte_cnt = 2'b00;
        if( beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        aluop = 4'b0000;
        end else begin
        aluop = 4'b0000;
        end
        link_en = 0;
        link_in = 0;
        divrst = 0;
        extend_mux = 1;
        byte_store_en = 0;
        half_store_en =0;
        bool_cnt =0;
        alt_link_reg_en = 0;
        altlink = 0;
        end
      4'b0010: begin
        MemToReg = 2'b00;
        if(addiu == 1 || andi == 1 || ori == 1 || xori == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 || lui == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb == 1 || sh == 1 || lwl == 1 || lwr == 1 || beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1) begin
        RegDst = 2'b00;
        end else if(addu == 1 || andINT== 1 || subu == 1 || orINT== 1 || xorINT== 1 || sll == 1 || sllv == 1 || sra == 1 || srav == 1 || srl == 1 || srlv == 1 || slt == 1 || sltu == 1 || div == 1 || divu == 1 || mult == 1 || multu == 1 || mfhi == 1 || mflo == 1 || jr == 1 || jalr == 1) begin
        RegDst = 2'b01;
        end else if(bgezal == 1 || bltzal == 1) begin
        RegDst = 2'b10;
        end else begin
        RegDst = 2'b00;
        end
        IorD = 2'b00;
        PCSrc = 2'b01;
        if(addiu == 1 || andi == 1 || ori == 1 || xori == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 || lui == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb ==1 || sh == 1 || lwl == 1 || lwr == 1) begin
        ALUSrcB = 3'b010;
        end else if( sll == 1 || sra == 1 || srl == 1) begin
        ALUSrcB = 3'b100;
        end else if( sllv == 1 || srav == 1 || srlv == 1) begin
        ALUSrcB = 3'b101;
        end else if( mthi == 1 || mtlo == 1 || mfhi == 1 || mflo == 1 || jr == 1 || jalr == 1) begin
        ALUSrcB = 3'b110;
        end else begin
        ALUSrcB = 3'b000;
        end
        if (lui == 1) begin
        ALUSrcA = 2'b10;
        end else if(mfhi == 1 || mflo ==1) begin
        ALUSrcA = 2'b11;
        end else begin
        ALUSrcA = 2'b01;
        end
        IrWrite = 0;
        MemWrite = 0;
        MemRead = 0;
        PcWrite = 0;
        RegWrite = 0;
        if( sll == 1 || sllv == 1 || sra == 1 || srav == 1 || srl == 1 || srlv == 1) begin
        ABswitch_cnt =1;
        end else begin
        ABswitch_cnt =0;
        end
        if(addiu == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb == 1 || sh == 1 || lwl == 1 || lwr == 1 || beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        extendcont = 2'b10;
        end else if(lui == 1) begin
        extendcont = 2'b11;
        end else begin
        extendcont = 2'b00;
        end
        if(beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        altpcWrite = 1;
        end else begin
        altpcWrite = 0;
        end
        altpcmux = 0;
        resetmux = 0;
        hilowrite = 0;
        if (mfhi ==1) begin
        hilosel =1;
        end else begin
        hilosel = 0;
        end
        lr_en = 0;
        if (lwr == 1) begin
        lrmux = 1;
        end else begin
        lrmux = 0;
        end
        mask_cnt = 3'b000;
        byte_cnt = 2'b00;
        if( beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1 || subu == 1 || slti == 1 || sltiu == 1 || slt == 1 || sltu == 1 ) begin
        aluop = 4'b0001;
        end else if(andi == 1 || andINT== 1) begin
        aluop = 4'b0010;
        end else if(ori == 1 || orINT== 1) begin
        aluop = 4'b0011;
        end else if(xori == 1 || xorINT== 1) begin
        aluop = 4'b0100;
        end else if(sll == 1 || sllv == 1) begin
        aluop = 4'b0101;
        end else if(srl == 1 || srlv == 1) begin
        aluop = 4'b0110;
        end else if(sra == 1 || srav == 1) begin
        aluop = 4'b0111;
        end else if(div == 1) begin
        aluop = 4'b1100;
        end else if(divu == 1) begin
        aluop = 4'b1110;
        end else if(mult == 1) begin
        aluop = 4'b1000;
        end else if(multu == 1) begin
        aluop = 4'b1010;
        end else begin
        aluop = 4'b0000;
        end
        link_en = 1;
        if (bgezal == 1 || bltzal == 1 || jal == 1 || jalr == 1) begin
        link_in = 1;
        end else begin
        link_in = 0;
        end
        if (divdone == 1 && (divu == 1 || div ==1)) begin
        divrst = 1;
        end else begin
        divrst =0;
        end
        extend_mux = 1;
        byte_store_en = 0;
        half_store_en =0;
        if ((slti == 1 && cond == 2'b01) || (sltiu == 1 && condu == 2'b01) || (slt == 1 && cond == 2'b01)  || (sltu == 1 && condu == 2'b01) ) begin
        bool_cnt = 1;
        end else begin
        bool_cnt =0;
        alt_link_reg_en = 0;
        altlink = 0;
        end
        end
      4'b0011: begin
        if(slt ==1 || slti ==1 || sltiu == 1 || sltu == 1) begin
        MemToReg = 2'b10;
        end else begin
        MemToReg = 2'b00;
        end
        if(addiu == 1 || andi == 1 || ori == 1 || xori == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 || lui == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb == 1 || sh == 1 || lwl == 1 || lwr == 1) begin
        RegDst = 2'b00;
        end else begin
        RegDst = 2'b01;
        end
        if(lw == 1 || sw == 1) begin
        IorD = 2'b01;
        end else begin
        IorD = 2'b10;
        end
        PCSrc = 2'b01;
        ALUSrcA = 2'b01;
        ALUSrcB = 3'b000;
        IrWrite = 0;
        if( sw == 1 || sb == 1 || sh == 1) begin
        MemWrite = 1;
        end else begin
        MemWrite = 0;
        end
        if( sw == 1 || sb == 1 || sh == 1) begin
        MemRead = 0;
        end else if(lw == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || lwl == 1 || lwr ==1) begin
        MemRead = 1;
        end else begin
        MemRead = 0;
        end
        PcWrite = 0;
        if( lui ==1 || addiu == 1 || andi == 1 || ori == 1 || xori == 1 || addu == 1 || andINT== 1 || subu == 1 || orINT== 1 || xorINT== 1 || sll == 1 || sllv == 1 || sra == 1 || srav == 1 || srl == 1 || srlv == 1 || slti == 1  || sltiu == 1 || slt == 1  || sltu == 1|| mfhi == 1 || mflo == 1) begin
        RegWrite = 1;
        end else begin
        RegWrite = 0;
        end
        ABswitch_cnt =0;
        if(addiu == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 ||  lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb == 1 || sh == 1 || lwl == 1 || lwr == 1 || beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        extendcont = 2'b10;
        end else if(lui == 1) begin
        extendcont = 2'b11;
        end else begin
        extendcont = 2'b00;
        end
        if(jr == 1 || jalr == 1) begin
        altpcWrite = 1;
        end else begin
        altpcWrite = 0;
        end
        altpcmux = 0;
        resetmux = 0;
        if (div == 1 || divu == 1 || mult == 1 || multu ==1 || mthi ==1 || mtlo == 1) begin
        hilowrite = 1;
        end else begin
        hilowrite = 0;
        end
        if( mthi == 1 || mfhi ==1) begin
        hilosel = 1;
        end else begin
        hilosel = 0;
        end
        lr_en = 0;
        if (lwr == 1) begin
        lrmux = 1;
        end else begin
        lrmux = 0;
        end
        mask_cnt = 3'b000;
        if(sb == 1) begin
        byte_cnt = 2'b01;
        end else if (sh == 1) begin
        byte_cnt = 2'b10;
        end else begin
        byte_cnt = 2'b00;
        end
        if (div == 1) begin
        aluop = 4'b1101;
        end else if(divu ==1) begin
        aluop = 4'b1111;
        end else if(mult == 1) begin
        aluop = 4'b1001;
        end else if(multu == 1) begin
        aluop = 4'b1011;
        end else begin
        aluop = 4'b0000;
        end
        link_en = 0;
        link_in = 0;
        divrst = 0;
        extend_mux = 1;
        if (sb ==1) begin
        byte_store_en = 1;
        end else begin
        byte_store_en = 0;
        end
        if (sh ==1) begin
        half_store_en = 1;
        end else begin
        half_store_en =0;
        end
        if ((slti == 1 && cond == 2'b01) || (sltiu == 1 && condu == 2'b01) || (slt == 1 && cond == 2'b01)  || (sltu == 1 && condu == 2'b01) ) begin
        bool_cnt = bool_cnt;
        end else begin
        bool_cnt = bool_cnt;
        end
        alt_link_reg_en = 1;
        if (jalr == 1) begin
        altlink = 1;
        end else begin
        altlink = 0;
        end
        end
      4'b0100: begin
        if(div == 1 || divu == 1 || mult == 1 || multu == 1) begin
        MemToReg = 2'b00;
        end else if( bgezal == 1 || bltzal ==1 || jal == 1 || jalr == 1 ) begin
        MemToReg = 2'b11;
        end else begin
        MemToReg = 2'b01;
        end
        if(lw == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || lwl == 1 || lwr ==1) begin
        RegDst = 2'b00;
        end else if( bgezal == 1 || bltzal ==1 || jal == 1 || jalr == 1 ) begin
        RegDst = 2'b10;
        end else begin
        RegDst = 2'b00;
        end
        IorD = 2'b00;
        PCSrc = 2'b10;
        ALUSrcA = 2'b00;
        if( bgezal == 1 || bltzal ==1 || jal == 1 || jalr == 1 ) begin
        ALUSrcB = 3'b001;
        end else begin
        ALUSrcB = 3'b011;
        end
        IrWrite = 0;
        MemWrite = 0;
        if(lw == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || lwl == 1 || lwr ==1) begin
        MemRead = 1;
        end else begin
        MemRead = 1;
        end
        PcWrite = 0;
        if(lw == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || lwl == 1 || lwr ==1) begin
        RegWrite = 1;
        end else if( bgezal == 1 || bltzal ==1 || jal == 1 || jalr == 1 ) begin
        RegWrite = 1;
        end else begin
        RegWrite = 0;
        end
        ABswitch_cnt = 0;
        if(addiu == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 || lui == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb == 1 || sh == 1 || lwl == 1 || lwr == 1 || beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        extendcont = 2'b10;
        end else if(lui == 1) begin
        extendcont = 2'b11;
        end else begin
        extendcont = 2'b00;
        end
        altpcWrite = 0;
        altpcmux = 1;
        resetmux = 0;
        if( div == 1 || divu == 1 || mult == 1 || multu == 1) begin
        hilowrite = 1;
        end else begin
        hilowrite = 0;
        end
        if ( mult == 1 || multu == 1 || mfhi == 1 || div == 1 || divu == 1 ) begin
        hilosel = 1;
        end else begin
        hilosel = 0;
        end
        if (lwr == 1 || lwl == 1) begin
        lr_en = 1;
        end else begin
        lr_en = 0;
        end
        if (lwr == 1) begin
        lrmux = 1;
        end else begin
        lrmux = 0;
        end
        if(lb == 1) begin
        mask_cnt = 3'b011;
        end else if (lbu ==1) begin
        mask_cnt = 3'b100;
        end else if (lh ==1) begin
        mask_cnt = 3'b001;
        end else if (lhu ==1) begin
        mask_cnt = 3'b010;
        end else if (lwl ==1) begin
        mask_cnt = 3'b101;
        end else if (lwr ==1) begin
        mask_cnt = 3'b110;
        end else
        mask_cnt = 3'b000;
        byte_cnt = 2'b00;
        aluop = 4'b0000;
        link_en = 0;
        link_in = 0;
        divrst = 0;
        extend_mux = 1;
        byte_store_en = 0;
        half_store_en = 0;
        bool_cnt = 0;
        alt_link_reg_en = 0;
        altlink = 0;
        end
      4'b0101: begin
        MemToReg = 2'b00;
        RegDst = 2'b00;
        IorD = 2'b00;
        PCSrc = 2'b00;
        ALUSrcA = 2'b00;
        ALUSrcB = 3'b001;
        IrWrite = 0;
        MemWrite = 0;
        MemRead = 0;
        PcWrite = 0;
        RegWrite = 0;
        ABswitch_cnt =0;
        if(addiu == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 || lui == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb == 1 || sh == 1 || lwl == 1 || lwr == 1 || beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        extendcont = 2'b10;
        end else if(lui == 1) begin
        extendcont = 2'b11;
        end else begin
        extendcont = 2'b00;
        end
        altpcWrite = 0;
        altpcmux = 1;
        resetmux = 0;
        hilowrite = 0;
        hilosel = 0;
        lr_en = 0;
        if (lwr == 1) begin
        lrmux = 1;
        end else begin
        lrmux = 0;
        end
        mask_cnt = 3'b000;
        byte_cnt = 2'b00;
        aluop = 4'b0000;
        link_en = 0;
        link_in = 0;
        divrst = 0;
        extend_mux = 1;
        byte_store_en = 0;
        half_store_en = 0;
        bool_cnt = 0;
        alt_link_reg_en = 0;
        altlink = 0;
        end
      4'b1111: begin
        MemToReg = 2'b00;
        RegDst = 2'b00;
        IorD = 2'b00;
        PCSrc = 2'b00;
        ALUSrcA = 2'b00;
        ALUSrcB = 3'b001;
        IrWrite = 0;
        MemWrite = 0;
        MemRead = 1;
        PcWrite = 1;
        RegWrite = 0;
        ABswitch_cnt =0;
        if(addiu == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 || lui == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb == 1 || sh == 1 || lwl == 1 || lwr == 1 || beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        extendcont = 2'b10;
        end else if(lui == 1) begin
        extendcont = 2'b11;
        end else begin
        extendcont = 2'b00;
        end
        altpcWrite = 0;
        altpcmux = 1;
        resetmux = 1;
        hilowrite = 0;
        hilosel = 0;
        lr_en = 0;
        if (lwr == 1) begin
        lrmux = 1;
        end else begin
        lrmux = 0;
        end
        mask_cnt = 3'b000;
        byte_cnt = 2'b00;
        aluop = 4'b0000;
        link_en = 0;
        link_in = 0;
        divrst = 0;
        extend_mux = 1;
        byte_store_en = 0;
        half_store_en = 0;
        bool_cnt = 0;
        alt_link_reg_en = 0;
        altlink = 0;
        end
      4'b1110: begin
        MemToReg = 2'b00;
        RegDst = 2'b00;
        IorD = 2'b00;
        PCSrc = 2'b00;
        ALUSrcA = 2'b00;
        ALUSrcB = 3'b001;
        IrWrite = 0;
        MemWrite = 0;
        MemRead = 1;
        PcWrite = 1;
        RegWrite = 0;
        ABswitch_cnt =0;
        if(addiu == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 || lui == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb == 1 || sh == 1 || lwl == 1 || lwr == 1 || beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        extendcont = 2'b10;
        end else if(lui == 1) begin
        extendcont = 2'b11;
        end else begin
        extendcont = 2'b00;
        end
        altpcWrite = 0;
        altpcmux = 1;
        resetmux = 1;
        hilowrite = 0;
        hilosel = 0;
        lr_en = 0;
        if (lwr == 1) begin
        lrmux = 1;
        end else begin
        lrmux = 0;
        end
        mask_cnt = 3'b000;
        byte_cnt = 2'b00;
        aluop = 4'b0000;
        link_en = 0;
        link_in = 0;
        divrst = 0;
        extend_mux = 1;
        byte_store_en = 0;
        half_store_en = 0;
        bool_cnt = 0;
        alt_link_reg_en = 0;
        altlink = 0;
        end
      4'b1001: begin
      if(mem_opcode == 6'b000100) begin
      beq = 1;
      end else if(mem_opcode == 6'b000001 && mem_info == 5'b00001) begin
      bgez = 1;
      end else if(mem_opcode == 6'b000111 && mem_info == 5'b00000) begin
      bgtz = 1;
      end else if(mem_opcode == 6'b000110 && mem_info == 5'b00000) begin
      blez = 1;
      end else if(mem_opcode == 6'b000001 && mem_info == 5'b00000) begin
      bltz = 1;
      end else if(mem_opcode == 6'b000101) begin
      bne = 1;
      end else if(mem_opcode == 6'b000001 && mem_info == 5'b10001) begin
      bgezal = 1;
      end else if(mem_opcode == 6'b000001 && mem_info == 5'b10000) begin
      bltzal = 1;
      end else if(mem_opcode == 6'b001010) begin
      slti = 1;
      end else if(mem_opcode == 6'b001011) begin
      sltiu =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b101010) begin
      slt = 1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b101011) begin
      sltu = 1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b100011) begin
      subu = 1;
      end else if(mem_opcode == 6'b100011) begin
      lw = 1;
      end else if(mem_opcode == 6'b101011) begin
      sw =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b100001) begin
      addu =1;
      end else if(mem_opcode == 6'b001001) begin
      addiu =1;
      end else if(mem_opcode == 6'b001111) begin
      lui =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b010001) begin
      mthi =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b010011) begin
      mtlo =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b010000) begin
      mfhi =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b010010) begin
      mflo =1;
      end else if(mem_opcode == 6'b100000) begin
      lb =1;
      end else if(mem_opcode == 6'b100100) begin
      lbu =1;
      end else if(mem_opcode == 6'b100001) begin
      lh =1;
      end else if(mem_opcode == 6'b100101) begin
      lhu =1;
      end else if(mem_opcode == 6'b101000) begin
      sb =1;
      end else if(mem_opcode == 6'b101001) begin
      sh =1;
      end else if(mem_opcode == 6'b100010) begin
      lwl =1;
      end else if(mem_opcode == 6'b100110) begin
      lwr =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b001000) begin
      jr =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b001001) begin
      jalr =1;
      end else if(mem_opcode == 6'b001100) begin
      andi =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b100100) begin
      andINT=1;
      end else if(mem_opcode == 6'b001101) begin
      ori =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b100101) begin
      orINT=1;
      end else if(mem_opcode == 6'b001110) begin
      xori =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b100110) begin
      xorINT=1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b000000) begin
      sll =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b000100) begin
      sllv =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b000011) begin
      sra =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b000111) begin
      srav =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b000010) begin
      srl =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b000110) begin
      srlv =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b011010) begin
      div =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b011011) begin
      divu =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b011000) begin
      mult =1;
      end else if(mem_opcode == 6'b000000 && mem_function == 6'b011001) begin
      multu =1;
      end else if(mem_opcode == 6'b000010) begin
      j =1;
      end else if(mem_opcode == 6'b000011) begin
      jal =1;
      end else begin
      nop =1;
      end
        MemToReg = 2'b00;
        RegDst = 2'b10;
        IorD = 2'b00;
        PCSrc = 2'b11;
        ALUSrcA = 2'b00;
        ALUSrcB = 3'b001;
        IrWrite = 0;
        MemWrite = 0;
        MemRead = 0;
        PcWrite = 1;
        if(link == 1) begin
        RegWrite = 1;
        end else begin
        RegWrite = 0;
        end
        ABswitch_cnt = 0;
        if(addiu == 1 || lw == 1 || sw == 1 || slti == 1 || sltiu == 1 || lui == 1 || lb == 1 || lbu == 1 || lh == 1 || lhu == 1 || sb == 1 || sh == 1 || lwl == 1 || lwr == 1 || beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        extendcont = 2'b10;
        end else if(lui == 1) begin
        extendcont = 2'b11;
        end else begin
        extendcont = 2'b00;
        end
        if(j == 1 || jal ==1) begin
        altpcWrite = 1;
        end else begin
        altpcWrite = 0;
        end
        altpcmux = 1;
        resetmux = 0;
        hilowrite = 0;
        hilosel = 0;
        lr_en = 0;
        if (lwr == 1) begin
        lrmux = 1;
        end else begin
        lrmux = 0;
        end
        mask_cnt = 3'b000;
        byte_cnt = 2'b00;
        if( beq == 1 || bgez == 1 || bgtz == 1 || blez == 1 || bltz == 1 || bne == 1 || bgezal == 1 || bltzal == 1) begin
        aluop = 4'b0000;
        end else begin
        aluop = 4'b0000;
        end
        link_en = 1;
        link_in = 0;
        divrst =0;
        extend_mux = 1;
        byte_store_en = 0;
        half_store_en = 0;
        bool_cnt = 0;
        alt_link_reg_en = 0;
        altlink = 0;
        end
      endcase
      end
    endmodule
