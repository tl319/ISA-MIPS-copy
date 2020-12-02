#include <iostream>
#include <vector>
#include <cmath>
#include <cassert>

#include "mips.hpp"

using namespace std;

void simulate(vector<uint32_t> mem)
{
    vector<int32_t> registers;
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
          //else if(funct == ) //
        case 35: //bin:100011, LW
          rt = mem[rs + immediate];
        case 43: //vin:101011, SW
          mem[rs + immediate] = rt;
        //case
      }
      PC++;
    }

}
