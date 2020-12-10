#include <iostream>
#include <vector>

#include "mips2.hpp"

using namespace std;

int main()
{
  vector<unsigned char> mem;
  int32_t reg2;


  mips_mem_init(cin, mem); //store the initial contents of the ram into the mem vector

  reg2 = mips_simulate(mem);

  ram_write_out(mem); //write out final state of mem

  cout<<"v0:"<<reg2<<endl;
}
