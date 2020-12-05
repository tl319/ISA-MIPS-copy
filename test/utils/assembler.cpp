#include "mips.hpp"

using namespace std;

int main()
{
    string filename;
    std::cout << "Please enter input filename: ";
    cin >> filename;

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

    vector<pair<string, string>> instr_and_operands;
    map<string, int> labels;

    for (int i=0; i<lines.size(); i++) {
        pair<string, string> word = sep_word(lines[i]);
        string head = word.first;
        //cout << head << endl;

        if(mips_is_label_decl(head)){
            head.pop_back(); // remove colon
            labels[head]=instr_and_operands.size();
            word.second.erase(word.second.begin());
            if (mips_is_data(word.second)) {
                instr_and_operands.push_back({word.second,""});
            }
        }else if(mips_is_instruction(head)){
            string address = word.second;
            address.erase(address.begin());
            instr_and_operands.push_back({head,address});

        }else{
            cerr<<"Couldn't parse '"<<head<<"'\n";
            exit(1);
        }
    }
    
    for(int i=0; i<instr_and_operands.size(); i++) {
        if (mips_is_instruction(instr_and_operands[i].first)) {
            string opname = instr_and_operands[i].first;
            uint32_t opcode = mips_instr_to_opcode(opname);
            uint32_t othcode;
            char type = mips_instruction_type(opname);
            if (type == 'j') {
                string operand = instr_and_operands[i].second;
                if (labels[operand]) {
                    othcode = labels[operand];
                } else {
                    othcode = stoi(operand);
                }
            } else if (type == 'r') {
                vector<string> operands = string_break(instr_and_operands[i].second);
                uint32_t rs = 0;
                uint32_t rt = 0;
                uint32_t rd = 0;
                uint32_t sa = 0;
                uint32_t fn = mips_r_instr_to_fncode(opname);
                if (operands.size()==3) {
                    operands[0].erase(operands[0].begin());
                    operands[1].erase(operands[1].begin());
                    operands[2].erase(operands[2].begin());
                    // Check if instruction is a SLL, SRL, SRA instruction;
                    if (opname == "SLL" || opname == "SRL" || opname == "SRA") {
                        rd = stoi(operands[0]) << 11;
                        rt = stoi(operands[1]) << 16;
                        sa = stoi(operands[2]) << 6;
                    } else {
                        rd = stoi(operands[0]) << 11;
                        rs = stoi(operands[1]) << 21;
                        rt = stoi(operands[2]) << 16;
                    }
                    othcode = rs + rt + rd + sa + fn;
                } else if (operands.size()==2) {
                    operands[0].erase(operands[0].begin());
                    operands[1].erase(operands[1].begin());

                    rs = stoi(operands[0]) << 21;
                    rt = stoi(operands[1]) << 16;

                    othcode = rs + rt + rd + sa + fn;
                } else if (operands.size()==1) {
                    operands[0].erase(operands[0].begin());
                    rs = stoi(operands[0]) << 21;
                    othcode = rs + fn;
                } else {
                    cerr << "ERR: Invalid arguments for r-type instruction '" << opname << "'." << endl;
                }
            } else if (type == 'i') {
                vector<string> operands = string_break(instr_and_operands[i].second);
                if (operands.size()==3) {
                    operands[0].erase(operands[0].begin());
                    operands[1].erase(operands[1].begin());

                    uint32_t rs = stoi(operands[0]) << 21;
                    uint32_t rt = stoi(operands[1]) << 16;
                    uint32_t offset = stoi(operands[2]);

                    othcode = rs + rt + offset;
                } else if (operands.size()==2) {
                    operands[0].erase(operands[0].begin());

                    uint32_t rs = stoi(operands[0]) << 21;
                    uint32_t offset = stoi(operands[1]);

                    othcode = rs + offset;
                } else {
                    cerr << "ERR: Invalid number of operands for i-type instruction '" << opname << "'." << endl; 
                    exit(1);
                }
            }

            opcode<<26;
            uint32_t lin = opcode + othcode;
            cout << to_hex8(lin) << endl;
        } else {
            uint32_t data = stoi(instr_and_operands[i].first);
            cout << to_hex8(data) << endl;
        }
    }
}