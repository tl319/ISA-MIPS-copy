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
        cerr << "ERR: File cannot be read, filename:" << filename <<endl;
        exit(1);
    } else {
        // cerr << "Reading from file '" << filename << "'" << endl;
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

        if(mips_is_label_decl(head)){
            head.pop_back(); // remove colon
            labels[head]=instr_and_operands.size();
            word.second.erase(word.second.begin());
            if (mips_is_data(word.second)) {
                // If label is labelling data
                instr_and_operands.push_back({word.second,""});
            } else {
                // If label is labelling an instruction in the program
                pair<string, string> word2 = sep_word(word.second);
                assert(mips_is_instruction(word2.first));
                string address = word2.second;
                address.erase(address.begin());
                instr_and_operands.push_back({word2.first, address});
            }
        }else if(mips_is_instruction(head)){
            string address = word.second;
            address.erase(address.begin());
            instr_and_operands.push_back({head,address});
        }else if(mips_is_data(head)){
            instr_and_operands.push_back({head, ""});
        }else if(head[0] == '#') {
            // If there is a hash ("#") in the beginning of a line, the line is a comment
            continue;
        }else if(lines[i]=="") {
            // If there is a blank line in the assembly text file, ignore it.
            continue;
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
                vector<string> operands = opr_break(instr_and_operands[i].second);
                uint32_t rs = 0;
                uint32_t rt = 0;
                uint32_t rd = 0;
                uint32_t sa = 0;
                uint32_t fn = mips_r_instr_to_fncode(opname);
                if (operands.size()==3) {
                    operands[0].erase(operands[0].begin());
                    operands[1].erase(operands[1].begin());
                    if (opname == "sll" || opname == "srl" || opname == "sra") {
                        rd = stoi(operands[0]) << 11;
                        rt = stoi(operands[1]) << 16;
                        sa = stoi(operands[2]) << 6;
                    } else if (opname == "sllv" || opname == "srav" || opname == "srlv"){
                        operands[2].erase(operands[2].begin());
                        rd = stoi(operands[0]) << 11;
                        rt = stoi(operands[1]) << 16;
                        rs = stoi(operands[2]) << 21;
                    } else {
                        operands[2].erase(operands[2].begin());
                        rd = stoi(operands[0]) << 11;
                        rs = stoi(operands[1]) << 21;
                        rt = stoi(operands[2]) << 16;
                    }
                    othcode = rs + rt + rd + sa + fn;
                } else if (operands.size()==2) {
                    operands[0].erase(operands[0].begin());
                    operands[1].erase(operands[1].begin());

                    if (opname == "jalr") {
                        rd = stoi(operands[0]) << 11;
                        rs = stoi(operands[1]) << 21;
                    } else {
                        rs = stoi(operands[0]) << 21;
                        rt = stoi(operands[1]) << 16;
                    }

                    othcode = rs + rt + rd + sa + fn;
                } else if (operands.size()==1) {
                    operands[0].erase(operands[0].begin());
                    if (opname == "mfhi" || opname == "mflo") {
                        rd = stoi(operands[0]) << 11;
                    } else if (opname == "jalr") {
                        rd = 31 << 11;
                        rs = stoi(operands[0]) << 21;
                    } else {
                        rs = stoi(operands[0]) << 21;
                    }
                    othcode = rd + rs + fn;
                } else {
                    cerr << "ERR: Invalid arguments for r-type instruction '" << opname << "'." << endl;
                }
            } else if (type == 'i') {
                vector<string> operands = opr_break(instr_and_operands[i].second);
                if (operands.size()==3) {
                    operands[0].erase(operands[0].begin());
                    operands[1].erase(operands[1].begin());

                    uint32_t rs = 0;
                    uint32_t rt = 0;
                    uint16_t imm;
                    if (opname == "beq" || opname == "bne") {
                        rs = stoi(operands[0]) << 21;
                        rt = stoi(operands[1]) << 16;
                        imm = stoi(operands[2]);
                    } else {
                        rt = stoi(operands[0]) << 16;
                        rs = stoi(operands[1]) << 21;
                        imm = stoi(operands[2]);
                    }
                
                    othcode = rs + rt + imm;
                } else if (operands.size()==2) {
                    if (mips_is_mem_acc_instr(opname)) {
                        operands[0].erase(operands[0].begin());
                        pair<string, string> abs_addr = addr_break(operands[1]);
                        abs_addr.first.erase(abs_addr.first.begin());
                        uint32_t rt = stoi(operands[0]) << 16;
                        uint32_t rs = stoi(abs_addr.first) << 21;
                        uint32_t imm = stoi(abs_addr.second);

                        othcode = rt + rs + imm;
                    } else {
                        operands[0].erase(operands[0].begin());
                        uint32_t rs = 0;
                        uint32_t rt = 0;
                        uint32_t imm = stoi(operands[1]);
                        
                        if (opname == "lui") {
                            rt = stoi(operands[0]) << 16;
                        } else {
                            rs = stoi(operands[0]) << 21;

                            if (opname == "bgez") {
                                rt = 1 << 16;
                            }
                            if (opname == "bgezal") {
                                rt = 17 << 16;
                            }
                            if (opname == "bltzal") {
                                rt = 16 << 16;
                            }
                        }

                        othcode = rs + rt + imm;
                    }
                } else {
                    cerr << "ERR: Invalid number of operands for i-type instruction '" << opname << "'." << endl; 
                    exit(1);
                }
            }

            opcode = opcode<<26;
            uint32_t lin = opcode + othcode;
            string word = to_hex8(lin);
            cout << word.substr(6,2) << endl;
            cout << word.substr(4,2) << endl;
            cout << word.substr(2,2) << endl;
            cout << word.substr(0,2) << endl;
        } else {
            uint32_t data = stoi(instr_and_operands[i].first);
            string word = to_hex8(data);
            cout << word.substr(6,2) << endl;
            cout << word.substr(4,2) << endl;
            cout << word.substr(2,2) << endl;
            cout << word.substr(0,2) << endl;
        }
    }
    // cerr << "SUCCESS: Assembly has been compiled into machine code." << endl;
}