#include <iostream>
#include "mips.hpp"

void ram_write_out(const vector<uint32_t>& mem)
{
  for(int i = 0; i<mem.size(); i++)
  {
    std::cout<<mem[i] << std::endl;
  }
}
