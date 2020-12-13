#include "mips.hpp"

using namespace std;

int main(int argc, char** argv)
{   
    if (argc < 2) {
        cerr << "ERR: Please include assembly program as program argument." << endl;
        exit(1);
    }

    string filename = argv[1];

    ifstream file;
    file.open(filename);

    if (!file.is_open()) {
        cerr << "ERR: File cannot be read" << endl;
        exit(1);
    } else {
        cerr << "Reading from file '" << filename << "'" << endl;
    }

    vector<string> lines;
    string line;
    while(file.good()) {
        getline(file, line);
        lines.push_back(line);
    }

    vector<pair<string, string>> tag_and_data;
    string v0 = "";
    vector<int> address_index;
    for (int i=0; i<lines.size(); i++) {
        if(lines[i]=="----------"){
            address_index.push_back(i);
        }else{
            if(get_address(lines[i]).first== "v0 : "){
                
                v0 = lines[i];
            }
        }
    }

    for(int i=address_index[2]+1; i<address_index[3]; i++){
        tag_and_data.push_back(get_address(lines[i]));
    }

    for(int i = 0; i<tag_and_data.size();i++){
        cout << tag_and_data[i].second << endl;
    }
        cout << v0 << endl;
}

    