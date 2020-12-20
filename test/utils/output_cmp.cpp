#include <iostream>
#include <fstream>
#include <set>

using namespace std;

int main(int argc, char** argv)
{
  if(argc!=3)
  {
    cerr<<"invalid number of arguments"<<endl;
    exit(1);
  }
  ifstream file1(argv[1]); //CPU
  ifstream file2(argv[2]); //simulator

  set<string> CPU_addresses;
  set<string> sim_addresses;

  string line;

  while(getline(file1,line))
  {
    CPU_addresses.insert(line);
  }

  line = "";
  while(getline(file2,line))
  {
    sim_addresses.insert(line);
  }

/*  for(auto it = CPU_addresses.begin(); it!=CPU_addresses.end();it++)
  {
    cout<<*it<<endl;
  }
  cout<< "----"<<endl;

  for(auto it = sim_addresses.begin(); it!=sim_addresses.end();it++)
  {
    cout<<*it<<endl;
  }*/
  if(CPU_addresses == sim_addresses)
  {
    //cout<<"YES";
    return 0;
  }
  //cout<<"NO";

  return -1;





}
