#include <iostream>
#include <vector>
#include <cmath>
#include <cassert>

#include "mips2.hpp"
#include "mips.hpp"

using namespace std;

unsigned int simp_address(uint32_t address)
{
  return (address<0xBFC00000) ? address : address - 0xBFC00000 + 0x00000400;
}


int32_t mips_simulate(vector<unsigned char>& mem)
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
    uint32_t PC_delay_slot = 0;
    unsigned int PC_simple, PC_delay_simple;
    bool running = true;
 long long int i = 0;

    while(true)
    { //getting rid of the bits we don't need
    i++;
    if(i>=1000000000) return 0xFF1FF1FF;
    if((PC == 0 && !prev_was_jump )|| (PC_delay_slot ==0 && prev_was_jump))
    {
      //running = false;
      return registers[2];
    }
       assert(PC<pow(2,32)); //pow(2,11)????
      PC_simple = simp_address(PC); //cerr<<endl<<PC_simple;
      if(!prev_was_jump) assert(PC_simple<2048);
      PC_delay_simple = simp_address(PC_delay_slot);
      if(prev_was_jump)assert(PC_delay_simple<2048);
      if(!prev_was_jump)   instr = mem[PC_simple]+ (mem[PC_simple+1]<<8) + (mem[PC_simple+2]<<16) + (mem[PC_simple+3]<<24);
      else instr =  mem[PC_delay_simple]+ (mem[PC_delay_simple+1]<<8) + (mem[PC_delay_simple+2]<<16) + (mem[PC_delay_simple+3]<<24);
//cerr<<to_hex8(PC)<< " "<<instr<<endl;
      opcode = instr  >> 26; //mask the lowest 26 bits
      //cerr<<opcode <<endl;
      //assert(opcode < 32);

        rs_index= (instr << 6) >> 27;
        rt_index = (instr << 11) >> 27;
        rd_index= (instr << 16) >> 27;


      /*int32_t& rs = registers[rs_index];
      int32_t& rt = registers[rt_index];
      int32_t& rd = registers[rd_index];*/


      shamt = (instr << 21) >> 27;
      //assert(shamt<32);

      funct = (instr<<26) >> 26;
      //assert(funct < 64);

      immediate = (instr<<16)>>16;
      //assert(immediate<pow(2,16));

      jump_address = (instr<<6)>>6;
      //assert(jump_address<pow(2,26));

      is_jump = false;

registers[0] = 0;

          uint vaddr;
          int32_t data;
          int32_t reg_rt;

      switch(opcode)
      {
        case 0: //R type instructions

         //ALU
          if(funct == 32) //bin 100000, add
            registers[rd_index] = registers[rs_index]+ registers[rt_index];
          else if(funct == 33) //100001, addu
            registers[rd_index] = (uint32_t)registers[rs_index] + (uint32_t)registers[rt_index];
          else if(funct == 36) //100100, and
            registers[rd_index] = registers[rs_index] & registers[rt_index];
          else if (funct == 37) //100101, or
            registers[rd_index] = registers[rs_index] | registers[rt_index];
          else if(funct == 39) //100111, nor
            registers[rd_index] = ~(registers[rs_index] | registers[rt_index]);
          else if(funct == 42) //101010,  SLT set on less than
            registers[rd_index] = (registers[rs_index]<registers[rt_index]);
          else if(funct == 43) //101011, SLTU set on less than unsigned
            registers[rd_index] = ((uint32_t)registers[rs_index])<((uint32_t)registers[rt_index]);
          else if(funct == 34) //100010, sub
            registers[rd_index] = registers[rs_index]-registers[rt_index];
          else if(funct == 35) //100011, subu
            registers[rd_index] = (uint32_t)registers[rs_index] - (uint32_t)registers[rt_index];
          else if(funct == 38) //100110 XOR
            registers[rd_index] = registers[rs_index] ^ registers[rt_index];

          //SHIFTS
          else if(funct == 0) //SLL by shamt
            registers[rd_index] = registers[rt_index] <<(uint32_t) shamt;
          else if(funct == 4) //000100,  SLLV
            registers[rd_index] = registers[rt_index] << (uint32_t)registers[rs_index];
          else if(funct == 3) //000011, SRA
            registers[rd_index] = registers[rt_index] >> (uint32_t)shamt;
          else if (funct == 7) //000111, SRAV
            registers[rd_index] = registers[rt_index]>>(uint32_t)registers[rs_index];
          else if(funct == 2) //000010, SRL
            registers[rd_index] = (uint32_t)registers[rt_index] >> (uint32_t)shamt;
          else if(funct == 6) //000110, SRLV
            registers[rd_index] = (uint32_t) registers[rt_index]>>(uint32_t)registers[rs_index];

          //MULTIPLY
          else if(funct == 26 && registers[rt_index]!=0) //011010 DIV
          {

            HI = registers[rs_index] % registers[rt_index];
            LO = registers[rs_index]/registers[rt_index];
          }
          else if(funct == 27 && registers[rt_index]!=0) //011011 DIVU
          {
             HI = (uint32_t)registers[rs_index] % (uint32_t)registers[rt_index];
             LO = (uint32_t)registers[rs_index] / (uint32_t)registers[rt_index];
          }
          else if(funct == 16) //010000 MFHI
            registers[rd_index] = HI;
          else if(funct == 18) //010010 MFLO
            registers[rd_index] = LO;
          else if(funct == 17) // 010001 MTHI
            HI = registers[rs_index];
          else if(funct == 19 ) //010011 MTLO
            LO = registers[rs_index];
          else if(funct == 24) //011000 MULT
          {
            int64_t result = registers[rs_index]*registers[rt_index];
            HI = result>>32;
            LO = result;
          }
          else if(funct ==25) //011001 MULTU
          {
            uint64_t result = (uint64_t)((uint32_t)registers[rs_index])*(uint64_t)((uint32_t)registers[rt_index]);
            HI = result>>32;
            LO = result;
          }

          //BRANCH
          else if(funct == 9) //001001 JALR
          {
            assert(!prev_was_jump);
            is_jump = true;
            PC_delay_slot = PC + 4;
            registers[rd_index] = PC+8;
            PC = registers[rs_index]-4;
            //if(PC!=0) PC-=4;

          }
          else if(funct == 8) //001000 JR
          {
            assert(!prev_was_jump);
            is_jump = true;
            PC_delay_slot = PC + 4;
            PC = registers[rs_index]-4;
            //if(PC!=0) PC-=4;
            //return registers[2];
          }
        break;
        //I TYPE INSTR

        case 8://001000 ADDI
          registers[rt_index] = registers[rs_index] + immediate;
          break;
        case 9://001001 ADDIU
          registers[rt_index] = (uint32_t)registers[rs_index] + immediate;
          break;
        case 12: //001100 ANDI
          registers[rt_index] = (uint32_t)registers[rs_index] & (uint16_t)immediate;
          break;
        case 15: //001111 LUI
          registers[rt_index] = immediate << 16;
          break;
        case 13: //001101 ORI
          registers[rt_index] = (uint32_t)registers[rs_index] | (uint16_t)immediate;
          break;
        case 10: //001010 SLTI
          registers[rt_index] = registers[rs_index]<immediate;
          break;
        case 11: //001011 SLTIU
          registers[rt_index] = (uint32_t)registers[rs_index] < (uint32_t)immediate;
          break;
        case 14://001110 XORI
          registers[rt_index] = (uint32_t)registers[rs_index] ^ (uint16_t)immediate;
          break;

          //BRANCHES
        case 4: //000100 BEQ
          if(registers[rs_index]==registers[rt_index]) //delay slot!!!!!
          {
            assert(!prev_was_jump);
            is_jump = true;
            PC_delay_slot = PC + 4;
            PC+=immediate*4;
          }
          break;
        case 1:

          if(rt_index==1) //BGEZ
          {
            if(registers[rs_index]>=0) //delay slot!!!!!
            {
              assert(!prev_was_jump);
              is_jump = true;
              PC_delay_slot = PC + 4;
              PC+=immediate*4;
            }
          }
          else if(rt_index == 17/*10001*/) //BGEZAL
          {
            registers[31]=PC + 8;
            if(registers[rs_index]>=0) //delay slot!
            {
              assert(!prev_was_jump);
              is_jump = true;
              PC_delay_slot = PC + 4;
              PC+=immediate*4;
            }
          }
          else if(rt_index == 0) //BLTZ
          {
            if(registers[rs_index]<0)
            {
              assert(!prev_was_jump);
              is_jump = true;
              PC_delay_slot = PC + 4;
              PC+=immediate*4; //delay slot
            }
          }
          else if(rt_index == 16/*10000*/) //BLTZAL
          {
            registers[31]=PC+8;
            if(registers[rs_index]<0)
            {
              assert(!prev_was_jump);
              is_jump = true;

              PC_delay_slot = PC + 4;
              PC+=immediate*4;
            }
          }

        break;
        case 7: //000111, BGTZ

          assert(rt_index==0);
          if(registers[rs_index]>0)
          {
            assert(!prev_was_jump);
            is_jump = true;
            PC_delay_slot = PC + 4;
            PC+=immediate*4;
          }
        break;
        case 6: //000110, BLEZ

          assert(rt_index==0);
          if(registers[rs_index]<=0)
          {
            assert(!prev_was_jump);
            is_jump = true;
            PC_delay_slot = PC + 4;
            PC+=immediate*4;
          }
        break;
        case 5: //000101, BNE

          if(registers[rs_index]!=registers[rt_index])
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
          uint32_t pc_upper = (PC>>28)<<28;
          PC=pc_upper+ (jump_address<<2)-4; //?????????
          }
        break;

        case 3: //000011 JAL
          {
          assert(!prev_was_jump);
          registers[31]=PC+8;
          is_jump = true;
          PC_delay_slot = PC + 4;

          uint32_t pc_upper = (PC>>28)<<28;
          PC=pc_upper + (jump_address<<2)-4;
          }
          break;

          //MEM ACCESS
        case 32://100000 //LB
          registers[rt_index] = (int8_t)mem[simp_address(registers[rs_index]+immediate)];
          break;
        case 36: //100100 LBU
          registers[rt_index] = (unsigned char)mem[simp_address(registers[rs_index]+immediate)];
          break;
        case 33: //100001 LH //what if the position is weird?
          registers[rt_index] = (int32_t)((int16_t)((mem[simp_address(registers[rs_index]+immediate+1)]<<8)) + (int16_t)mem[simp_address(registers[rs_index]+immediate)]);
          break;
        case 37: //100101 LHU
          registers[rt_index] = ((uint16_t)mem[simp_address(registers[rs_index]+immediate+1)]<<8) + (unsigned char)mem[simp_address(registers[rs_index]+immediate)];
          break;
        case 35: //bin:100011, LW what if addressing is incorrect???
          registers[rt_index] = (mem[simp_address(registers[rs_index] + immediate+3)]<<24) + (mem[simp_address(registers[rs_index]+immediate +2)]<<16) + (mem[simp_address(registers[rs_index]+immediate+1)]<<8) + mem[simp_address(registers[rs_index]+immediate)];
          break;
        case 43: //vin:101011, SW what if addressing not correst? so doesn't start at 4*k address

          mem[simp_address(registers[rs_index] + immediate +3)] = registers[rt_index]>>24; //msB
          mem[simp_address(registers[rs_index] + immediate+2)] = (registers[rt_index]<<8)>>24;
          mem[simp_address(registers[rs_index] + immediate+1)] = (registers[rt_index]<<16)>>24;
          mem[simp_address(registers[rs_index] + immediate)] = (registers[rt_index]<<24)>>24; //lsB
          break;
        case 40: //101000 SB
          mem[simp_address(registers[rs_index] + immediate)] = registers[rt_index]; //which byte to store??? lowest??
          break;
        case 41://101001 SH

          mem[simp_address(registers[rs_index]+immediate)] = registers[rt_index]; //which half word to store??? lowest???
          mem[simp_address(registers[rs_index]+immediate+1)] = registers[rt_index]>>8;
          break;


        case 34://100010 LWL //do i have to shift the address left by 2 bits??
          vaddr = (registers[rs_index]+immediate)%4;
          reg_rt = registers[rt_index];
          data = (mem[simp_address(registers[rs_index] + immediate+3-vaddr)]<<24) + (mem[simp_address(registers[rs_index]+immediate +2-vaddr)]<<16) + (mem[simp_address(registers[rs_index]+immediate+1-vaddr)]<<8) + mem[simp_address(registers[rs_index]+immediate-vaddr)];
          if(vaddr == 0)
          {
          registers[rt_index] = ((uint32_t)registers[rt_index]<<8)>>8;
          registers[rt_index] += ((data<<24) & 0xFF000000);
          //registers[rt_index] =data;
          }
          else if(vaddr == 1)
          {
          registers[rt_index] = ((uint32_t)registers[rt_index]<<16)>>16;
          registers[rt_index] += ((data<<16) & 0xFFFF0000);
          //registers[rt_index] =data;
          }
          else if(vaddr ==2)
          {
          registers[rt_index] = ((uint32_t)registers[rt_index]<<24)>>24;
          registers[rt_index] += ((data<<8) & 0xFFFFFF00);
          //registers[rt_index] =data;
          }
          else /*if(vaddr ==3)*/
          {
          registers[rt_index] = data;
          //registers[rt_index] += mem & 0x00000000;
          }
          break;
        case 38://100110 LWR
          vaddr = (registers[rs_index]+immediate)%4;
          //reg_rt = registers[rt_index];
          data = (mem[simp_address(registers[rs_index] + immediate+3-vaddr)]<<24) + (mem[simp_address(registers[rs_index]+immediate +2-vaddr)]<<16) + (mem[simp_address(registers[rs_index]+immediate+1-vaddr)]<<8) + mem[simp_address(registers[rs_index]+immediate-vaddr)];
          if(vaddr == 3)
          {
            registers[rt_index] = ((uint32_t)registers[rt_index]>>8)<<8;
            registers[rt_index] += ((data>>24) & 0x000000FF);
        //registers[rt_index] =data;
          }
          else if(vaddr == 2)
          {
            registers[rt_index] = ((uint32_t)registers[rt_index]>>16)<<16;
            registers[rt_index] += ((data>>16) & 0x0000FFFF);
        //registers[rt_index] =data;
        }
        else if(vaddr ==1)
        {
        registers[rt_index] = ((uint32_t)registers[rt_index]>>24)<<24;
        registers[rt_index] += ((data>>8) & 0x00FFFFFF);
        //registers[rt_index] =data;
        }
        else /*if(vaddr ==3)*/
        {
        registers[rt_index] = data;
        //registers[rt_index] += mem & 0x00000000;
        }

          break;
        default:
         cout<<"Invalid instruction";
         assert(0);
         break;


      }
    if(!is_jump /*&& PC!=0*/)
        PC+=4;
      prev_was_jump = is_jump;
      //assert(registers[0] == 0);
    registers[0] = 0;

    }
  return registers[2];

}
