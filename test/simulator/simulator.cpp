#include <iostream>
#include <vector>

#include "mips.hpp"

using namespace std;

int main()
{
  vector<unsigned char> mem;



  mips_mem_init(cin, mem); //store the initial contents of the ram into the mem vector

  mips_simulate(mem);

  ram_write_out(mem); //write out final state of mem
}
