#include <iostream>
#include "mips.hpp"
#include <cstring>

using namespace std;

int main() //input from stdin, output lines starting with MEM_ADDRESS:
{
  string line;
  vector<string> words;
  while(getline(cin, line))
  {
    words = string_break(line);
    if(words[0]=="MEM_ADDRESS:")
    {
      for(int i =0 ; i<words[1].size(); i++)
      {
      cout<<(char)toupper(words[1][i]);
      }
      cout<<endl;
    }
  }

}
