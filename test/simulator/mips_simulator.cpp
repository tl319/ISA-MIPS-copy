#include <iostream>
#include <vector>
#include <cmath>
#include <cassert>

#include "mips.hpp"

using namespace std;

void simulate(vector<uint32_t> mem)
{
    vector<int32_t> registers;
    int32_t HI, LO;
    uint opcode;
    uint rd_index, rs_index, rt_index, shamt, funct;
    uint32_t jump_address;
    uint16_t immediate;
    uint32_t PC = 0xBFC00000; //, executing starts here in the memory 3217031168
    uint32_t instr;

    bool running = true;

    while(running)
    { //getting rid of the bits we don't need
      assert(PC<pow(2,30));
      instr = mem[PC];

      opcode = instr  >> 26; //mask the lowest 26 bits
      assert(opcode < 32);

      rs_index = (instr << 6) >> 27;
      assert(rs_index<32);
      int32_t& rs = registers[rs_index];

      rt_index = (instr << 11) >> 27;
      assert(rt_index<32);
      int32_t& rt = registers[rt_index];

      rd_index = (instr << 16) >> 27;
      assert(rd_index<32);
      int32_t& rd = registers[rd_index];

      shamt = (instr << 21) >> 27;
      assert(shamt<32);

      funct = (instr<<26) >> 26;
      assert(funct < 64);

      immediate = (instr<<16)>>16;
      assert(immediate<pow(2,16));

      jump_address = (instr<<6)>>6;
      assert(jump_address<pow(2,26));




      switch(opcode)
      {
        case 0: //R type instructions
         //ALU
          if(funct == 32) //bin 100000, add
            rd = rs+ rt;
          else if(funct == 33) //100001, addu
            rd = (uint32_t)rs + (uint32_t)rt;
          else if(funct == 36) //100100, and
            rd = rs & rt;
          else if (funct == 37) //100101, or
            rd = rs | rt;
          else if(funct == 39) //100111, nor
            rd = ~(rs | rt);
          else if(funct == 42) //101010, set on less than
            rd = (rs<rt);
          else if(funct == 43) //101011, set on less than unsigned
            rd = ((uint32_t)rs<(uint32_t)rt);
          else if(funct == 34) //100010, sub
            rd = rs-rt;
          else if(funct == 35) //100011, subu
            rd = (uint32_t)rs - (uint32_t)rt;
          else if(funct == 38) //100110 XOR
            rd = rs ^ rt;

          //SHIFTS
          else if(funct == 0) //SLL by shamt
            rd = rt << shamt;
          else if(funct == 4) //000100,  SLLV
            rd = rt << (uint32_t)rs;
          else if(funct == 3) //000011, SRA
            rd = (uint32_t)rt >> shamt;
          else if (funct == 7) //000111, SRAV
            rd = (uint32_t)rt>>(uint32_t)rs;
          else if(funct == 2) //000010, SRL
            rd = rt >> shamt;
          else if(funct == 6) //000110, SRLV
            rd = rt>>(uint32_t)rs;

          //MULTIPLY
          else if(funct == 26) //011010 DIV
          {
            HI = rs % rt;
            LO = rs/rt;
          }
          else if(funct == 27) //011011 DIVU
          {
             HI = (uint32_t)rs % (uint32_t)rt;
             LO = (uint32_t)rs / (uint32_t)rt;
          }
          else if(funct == 16) //010000 MFHI
            rd = HI;
          else if(funct == 18) //010010 MFLO
            rd = LO;
          else if(funct == 17) // 010001 MTHI
            HI = rs;
          else if(funct == 19 ) //010011 MTLO
            LO = rs;
          else if(funct == 24) //011000 MULT
          {
            HI = rs*rt;
            LO = rs*rt;
          }
          else if(funct ==25) //011001 MULTU
          {
            HI = (uint32_t)rs*(uint32_t)rt;
            LO = (uint32_t)rs*(uint32_t)rt;
          }

          //BRANCH
          else if(funct == 9) //001001 JALR
          {
            rd = PC;
            PC = rs;
          }
          else if(funct == 8) //001000 JR
            PC = rs;
        //I TYPE INSTR
        case 8://001000 ADDI
          rt = rs + immediate;

        case 9://001001 ADDIU
          rt = (uint32_t)rs + immediate;
        case 12: //001100 ANDI
          rt = rs & immediate;
        case 15: //001111 LUI
          rt = immediate << 16;
        case 13: //001101 ORI
          rt = rs | immediate;
        case 10: //001010 SLTI
          rt = rs<immediate;
        case 11: //001011 SLTIU
          rt = (uint32_t)rs < (uint32_t)immediate;
        case 14://001110 XORI
          rt = rs ^ immediate;

          //MEM ACCESS
        case 32://100000 //LB
          rt = (signed char)mem[rs+immediate];
        case 36: //100100 LBU
          rt = (unsigned char)mem[rs+immediate];
        case 33: //100001 LH
          rt = (short int)mem[rs+immediate];
        case 37: //100101 LHU
          rt = (unsigned int)mem[rs+immediate];
        case 35: //bin:100011, LW
          rt = mem[rs + immediate];
        case 43: //vin:101011, SW
          mem[rs + immediate] = rt;
        //case 40: //101000 SB
          //mem[rs + immediate] = rt;
        //case 41://101001 SH
          //mem[rs+immediate] = rt;

      }
      PC++;
    }

}
