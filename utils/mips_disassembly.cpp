#include <iostream>
#include <vector>
#include <cmath>
#include <cassert>
#include "mips2.hpp"

using namespace std;
//how big is the memory?
//where to start writing the instructions?? from 0?

void mips_mem_init(istream& src, vector<unsigned char>& mem)
{
  int line_number=1024;
  string line ="";


  mem.resize(1024, 0);
  while( getline(src, line) )
  {


      assert(line_number <= 2048); //how big is the memory??? pow(2,11)???

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
      //cout<<line;

      if(line.size()!=2){
          cerr<<"Line "<<line_number<<" : expected 2 characters, got '"<<line.size()<<'"'<<endl;
          assert(1);
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
      assert(x< pow(2,8));
      /*mem.push_back(x>>24); //is x one word or one byte??????? assuming word:
      mem.push_back(x>>16);
      mem.push_back(x>>8);*/
      mem.push_back(x);
      line_number++;
  }
mem.resize(2048, 0);
}
