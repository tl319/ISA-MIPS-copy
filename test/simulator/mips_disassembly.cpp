#include <iostream>
#include <vector>
#include <cmath>
#include <cassert>
#include "mips.hpp"

using namespace std;
//how big is the memory?
//where to start writing the instructions?? from 0?

void mips_mem_init(istream& src, vector<uint32_t>& mem)
{
  int line_number=1;
  string line;
  while( getline(src, line) )
  {
      assert(line_number <= pow(2,30)); //how big is the memory???

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
      assert(x< pow(2,30));
      mem.push_back(x);

      line_number++;
  }
  mem.resize(pow(2,30), 0); //again memory size??
}
