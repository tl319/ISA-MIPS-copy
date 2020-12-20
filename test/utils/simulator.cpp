#include <iostream>
#include <vector>
#include <fstream>

#include "mips2.hpp"
#include "mips.hpp"

using namespace std;

int main(/*int argc, char** argv*/) //or should w
{
  /*if (argc < 2) {
      cerr << "ERR: Please include assembly program as program argument." << endl;
      exit(1);
  }*/
  ofstream Addresses("filename.txt"); //test/sim_out/addresses.txt
  vector<unsigned char> mem;
  int32_t reg2= 0;

//mem.resize(2048, 0);
  mips_mem_init(cin, mem); //store the initial contents of the ram into the mem vector

  reg2 = mips_simulate(mem, Addresses);

  ram_write_out(mem); //write out final state of mem

  cout<<"v0: "<<to_hex8(reg2)<<endl;

  Addresses.close();
}
