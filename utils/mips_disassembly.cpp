#include <iostream>
#include <vector>
#include <cmath>
#include <cassert>
#include "mips.hpp"

using namespace std;
//how big is the memory?
//where to start writing the instructions?? from 0?

void mips_mem_init(istream& src, vector<unsigned char>& mem)
{
  int line_number=1;
  string line;
  while( getline(src, line) )
  {
      assert(line_number <= pow(2,32)); //how big is the memory???

      // Trim initial space
      while(line.size()>0 && isspace(line.front()))
      {
          line = line.substr(1); // Remove first characters
      }

      // Trim trailing space
      while(line.size()>0 && isspace(line.back()))
      {
          line.pop_back();
      }

      if(line.size()!=8){
          cerr<<"Line "<<line_number<<" : expected eight characters, got '"<<line<<'"'<<endl;
          exit(1);
      }
      for(int i=0; i<line.size(); i++)
      {
          if(!isxdigit(line[i]))
          {
              cerr<<"Line "<<line_number<<" : expected only hexadecimal digits, got '"<<line[i]<<'"'<<endl;
              exit(1);
          }
      }

      unsigned x=stoul(line, nullptr, 16); //convert from hex to decimal
      assert(x< pow(2,32));
      mem.push_back(x>>24); //is x one word or one byte??????? assuming word:
      mem.push_back(x>>16);
      mem.push_back(x>>8);
      mem.push_back(x);

      line_number++;
  }
  mem.resize(pow(2,32), 0); //again memory size??
  mem[0] = 0x0;
  mem[1]=0xBFC00004;
  mem[2] =0xFFFFFFFF;
  mem[3] = 0x44332211;
}
