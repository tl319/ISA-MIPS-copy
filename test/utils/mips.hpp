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

// Assembly

// Returns true if the s is a valid MIPS instruction OPCODE
bool mips_is_instruction(const string &s);

// Return true if the s is a valid label declaration
bool mips_is_label_decl(const string &s);

// Return true if the s represents data ( a decimal integer constant)
bool mips_is_data(const string &s);

// Returns r, i, j depending on the instruction 's' argument in the function
char mips_instruction_type(const string &s);

// Returns corresponding opcode of MIPS assembly instruction 's'
uint16_t mips_instr_to_opcode(const string &s);

// Returns corresponding function code of a r-type MIPS instruction 's'
uint16_t mips_r_instr_to_fncode(const string &s);

// Returns the hex string of uint16_t 'x'
string to_hex8(uint32_t x);

// Returns a vector words in sentence 's'
vector<string> string_break(string s);

// Returns a pair of opname and operands from a word 'w'
pair<string, string> sep_word (string s);

//DISASSEMBLY
//initialises data and instruction memory according to the binary file from src
void mips_mem_init(istream& src, vector<unsigned char>& mem);



//void disassemble_instr(const uint32_t& instr, uint& opcode, uint& dest, uint& source1, , uint& source2, uint& address, uint& immediate, )

//runs the simulation, when the data is already in the RAM, outputs the values of the registers after every instruction
//should instr_mem be const???
void mips_simulate(vector<unsigned char> mem);

void ram_write_out(const vector<unsigned char>& mem);

#endif
