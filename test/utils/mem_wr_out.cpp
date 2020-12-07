#include <iostream>
#include <vector>
#include "mips.hpp"

using namespace std;

string to_hex1(unsigned char x)
{
      char tmp[16]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
      string res;
      res.push_back(tmp[(x>>28)&0xF]);
      res.push_back(tmp[(x>>24)&0xF]);
      return res;
}

void ram_write_out(const vector<unsigned char>& mem)
{
  for(unsigned int i = 0xBFC00000-1024; i<0xBFC00000+1024; i++)
  {
    if(mem[i]!=0)
      cout<<i<<":"<<to_hex1(mem[i]) << endl;
  }
}
