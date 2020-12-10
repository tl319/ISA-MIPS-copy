#include <iostream>
#include <vector>
#include <cmath>
#include <cassert>

#include "mips2.hpp"

using namespace std;

unsigned int simp_address(uint32_t address)
{
  return (address<0xBCF00000) ? address : address - 0xBFC00000 + 0x00000400;
}


int32_t mips_simulate(vector<unsigned char> mem)
{
    vector<int32_t> registers;
    for(int i = 0; i<32; i++)
    {
      registers.push_back(0);
    }
    int32_t HI = 0;
    int32_t LO = 0;
    uint opcode;
    uint rd_index, rs_index, rt_index, shamt, funct;
    uint32_t jump_address;
    int16_t immediate;
    uint32_t PC = 0xBFC00000; // executing starts here in the memory 3217031168
    uint32_t instr;
    bool prev_was_jump = false;
    bool is_jump = false;
    uint32_t PC_delay_slot;
    uint PC_simple, PC_delay_simple;

    bool running = true;

    while(running)
    { //getting rid of the bits we don't need
      assert(PC<pow(2,32)); //pow(2,11)????
      PC_simple = simp_address(PC);
      PC_delay_simple = simp_address(PC_delay_slot);
      if(!prev_was_jump)   instr = mem[PC_simple]+ mem[PC_simple+1]<<8 + mem[PC_simple+2]<<16 + mem[PC_simple+3]<<24;
      else instr =  mem[PC_delay_simple]+ mem[PC_delay_simple+1]<<8 + mem[PC_delay_simple+2]<<16 + mem[PC_delay_simple+3]<<24;

      opcode = instr  >> 26; //mask the lowest 26 bits
      //assert(opcode < 32);

      rs_index = (instr << 6) >> 27;
      //assert(rs_index<32);
      int32_t& rs = registers[rs_index];

      rt_index = (instr << 11) >> 27;
      //assert(rt_index<32);
      int32_t& rt = registers[rt_index];

      rd_index = (instr << 16) >> 27;
      //assert(rd_index<32);
      int32_t& rd = registers[rd_index];

      shamt = (instr << 21) >> 27;
      //assert(shamt<32);

      funct = (instr<<26) >> 26;
      //assert(funct < 64);

      immediate = (instr<<16)>>16;
      //assert(immediate<pow(2,16));

      jump_address = (instr<<6)>>6;
      //assert(jump_address<pow(2,26));

      is_jump = false;

      if((PC == 0 && !prev_was_jump )|| (PC_delay_slot ==0 && prev_was_jump))
      {
        running = false;
        return registers[2];
      }


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
          else if(funct == 42) //101010,  SLT set on less than
            rd = (rs<rt);
          else if(funct == 43) //101011, SLTU set on less than unsigned
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
            assert(!prev_was_jump);
            is_jump = true;
            PC_delay_slot = PC + 4;
            registers[31] = PC+4;
            PC = rs;

          }
          else if(funct == 8) //001000 JR
          {
            assert(!prev_was_jump);
            is_jump = true;
            PC_delay_slot = PC + 4;
            PC = rs;
          }
        break;
        //I TYPE INSTR

        case 8://001000 ADDI
          rt = rs + immediate;
          break;
        case 9://001001 ADDIU
          rt = (uint32_t)rs + immediate;
          break;
        case 12: //001100 ANDI
          rt = rs & immediate;
          break;
        case 15: //001111 LUI
          rt = immediate << 16;
          break;
        case 13: //001101 ORI
          rt = rs | immediate;
          break;
        case 10: //001010 SLTI
          rt = rs<immediate;
          break;
        case 11: //001011 SLTIU
          rt = (uint32_t)rs < (uint32_t)immediate;
          break;
        case 14://001110 XORI
          rt = rs ^ immediate;
          break;

          //BRANCHES
        case 4: //000100 BEQ
          if(rs==rt) //delay slot!!!!!
          {
            assert(!prev_was_jump);
            is_jump = true;
            PC_delay_slot = PC + 4;
            PC+=immediate*4;
          }
          break;
        case 1:

          if(rt==1) //BGEZ
          {
            if(rs>=0) //delay slot!!!!!
            {
              assert(!prev_was_jump);
              is_jump = true;
              PC_delay_slot = PC + 4;
              PC+=immediate*4;
            }
          }
          else if(rt == 33/*100001*/) //BGEZAL
          {

            if(rs>=0) //delay slot!
            {
              assert(!prev_was_jump);
              is_jump = true;
              registers[31]=PC;
              PC_delay_slot = PC + 4;
              PC+=immediate*4;
            }
          }
          else if(rt == 0) //BLTZ
          {
            if(rs<0)
            {
              assert(!prev_was_jump);
              is_jump = true;
              PC_delay_slot = PC + 4;
              PC+=immediate*4; //delay slot
            }
          }
          else if(rt == 32/*100000*/) //BLTZAL
          {
            if(rs<0)
            {
              assert(!prev_was_jump);
              is_jump = true;
              registers[31]=PC;
              PC_delay_slot = PC + 4;
              PC+=immediate*4;
            }
          }

        break;
        case 7: //000111, BGTZ

          assert(rt==0);
          if(rs>0)
          {
            assert(!prev_was_jump);
            is_jump = true;
            PC_delay_slot = PC + 4;
            PC+=immediate*4;
          }
        break;
        case 6: //000110, BLEZ

          assert(rt==0);
          if(rs<=0)
          {
            assert(!prev_was_jump);
            is_jump = true;
            PC_delay_slot = PC + 4;
            PC+=immediate*4;
          }
        break;
        case 5: //000101, BNE

          if(rs!=rt)
          {
            assert(!prev_was_jump);
            is_jump = true;
            PC_delay_slot = PC + 4;
            PC+=immediate*4;
          }
        break;
        case 2: //000010 J
          {
          assert(!prev_was_jump);
          is_jump = true;
          PC_delay_slot = PC + 4;
          uint32_t pc_upper = (PC>>26)<<26;
          PC=pc_upper*pow(2,16) + (jump_address<<2); //?????????
          }
        break;

        case 3: //000011 JAL
          {
          assert(!prev_was_jump);
          is_jump = true;
          PC_delay_slot = PC + 4;
          registers[31]=PC+4;
          uint32_t pc_upper = (PC>>26)<<26;
          PC=pc_upper*pow(2,16) + (jump_address<<2);
          }
          break;

          //MEM ACCESS
        case 32://100000 //LB
          rt = mem[simp_address(rs+immediate)];
          break;
        case 36: //100100 LBU
          rt = (unsigned char)mem[simp_address(rs+immediate)];
          break;
        case 33: //100001 LH //what if the position is weird?

          rt = (mem[simp_address(rs+immediate+1)]<<8) + mem[simp_address(rs+immediate)];
          break;
        case 37: //100101 LHU
          rt = ((unsigned char)mem[simp_address(rs+immediate+1)]<<8) + (unsigned char)mem[simp_address(rs+immediate)];
          break;
        case 35: //bin:100011, LW what if addressing is incorrect???
          rt = (mem[simp_address(rs + immediate+3)]<<24) + (mem[simp_address(rs+immediate +2)]<<16) + (mem[simp_address(rs+immediate+1)]<<8) + mem[simp_address(rs+immediate)];
          break;
        case 43: //vin:101011, SW what if addressing not correst? so doesn't start at 4*k address

          mem[simp_address(rs + immediate +3)] = rt>>24; //msB
          mem[simp_address(rs + immediate+2)] = (rt<<8)>>24;
          mem[simp_address(rs + immediate+1)] = (rt<<16)>>24;
          mem[simp_address(rs + immediate)] = (rt<<24)>>24; //lsB
          break;
        case 40: //101000 SB
          mem[simp_address(rs + immediate)] = rt; //which byte to store??? lowest??
          break;
        case 41://101001 SH

          mem[simp_address(rs+immediate)] = rt; //which half word to store??? lowest???
          mem[simp_address(rs+immediate+1)] = rt>>8;
          break;


        case 34://100010 LWL //do i have to shift the address left by 2 bits??

          rt = (rt<<16)>>16;
          rt += (mem[simp_address(rs+immediate+1)]<<24)+ (mem[simp_address(rs+immediate)]<<16);
          break;
        case 38://100110 LWR

          rt = (rt>>16)<<16;
          rt += (mem[simp_address(rs+immediate+1)]<<8)+ mem[simp_address(rs+immediate)];
          break;
        default:

         cout<<"Invalid instruction";
         assert(0);
         break;


      }
    if(!is_jump && !prev_was_jump)
        PC+=4;
      prev_was_jump = is_jump;
      assert(registers[0] == 0);


    }
  //return registers[2];

}
