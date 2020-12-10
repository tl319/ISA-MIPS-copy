#ifndef mips_hpp
#define mu0_hpp

#include <string>
#include <vector>
#include <cassert>
#include <iostream>
#include <map>
#include <utility>
#include <iomanip>
#include <bitset>
#include <fstream>

using namespace std;

//DISASSEMBLY
//initialises data and instruction memory according to the binary file from src
void mips_mem_init(istream& src, vector<unsigned char>& mem);

string to_hex1(unsigned char x);

//void disassemble_instr(const uint32_t& instr, uint& opcode, uint& dest, uint& source1, , uint& source2, uint& address, uint& immediate, )

//runs the simulation, when the data is already in the RAM, outputs the values of the registers after every instruction
//should instr_mem be const???
int32_t mips_simulate(vector<unsigned char> mem);

void ram_write_out(const vector<unsigned char>& mem);

#endif
