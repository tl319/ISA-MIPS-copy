#include <iostream>
#include <vector>

#include "mips.h"

using namespace std;

int main()
{
  vector<uint32_t> mem;



  mips_mem_init(cin, mem); //store the initial contents of the ram into the mem vector

  mips_simulate(mem);

  ram_write_out(mem); //write out final state of mem
}
