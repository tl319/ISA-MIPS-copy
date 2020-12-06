#include <iostream>
#include <vector>
#include "mips.hpp"

using namespace std;

void ram_write_out(const vector<unsigned char>& mem)
{
  for(int i = 0; i<mem.size(); i++)
  {
    std::cout<<(uint32_t)mem[i] << std::endl;
  }
}
