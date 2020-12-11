#include "mips.hpp"

bool mips_is_instruction(const string &s)
{
    if (s == "addiu") return true;
    if (s == "addu") return true;
    if (s == "and") return true;
    if (s == "andi") return true;
    if (s == "beq") return true;
    if (s == "bgez") return true;
    if (s == "bgezal") return true;
    if (s == "bgtz") return true;
    if (s == "blez") return true;
    if (s == "bltz") return true;
    if (s == "bltzal") return true;
    if (s == "bne") return true;
    if (s == "div") return true;
    if (s == "divu") return true;
    if (s == "j") return true;
    if (s == "jalr") return true;
    if (s == "jal") return true;
    if (s == "jr") return true;
    if (s == "lb") return true;
    if (s == "lbu") return true;
    if (s == "lh") return true;
    if (s == "lhu") return true;
    if (s == "lui") return true;
    if (s == "lw") return true;
    if (s == "lwl") return true;
    if (s == "lwr") return true;
    if (s == "mthi") return true;
    if (s == "mtlo") return true;
    if (s == "mult") return true;
    if (s == "multu") return true;
    if (s == "or") return true;
    if (s == "ori") return true;
    if (s == "sb") return true;
    if (s == "sh") return true;
    if (s == "sll") return true;
    if (s == "sllv") return true;
    if (s == "slt") return true;
    if (s == "slti") return true;
    if (s == "sltiu") return true;
    if (s == "sltu") return true;
    if (s == "sra") return true;
    if (s == "srav") return true;
    if (s == "srl") return true;
    if (s == "srlv") return true;
    if (s == "subu") return true;
    if (s == "sw") return true;
    if (s == "xor") return true;
    if (s == "xori") return true;
    return false;
}

bool mips_is_label_decl(const string &s)
{
    if(s.size()<2){
        return false;
    }

    if(!(isalpha(s[0]) || s[0]=='_')){
        return false;
    }

    for(int i=1; i<s.size()-1; i++){
        if(!(isalnum(s[i]) || s[i]=='_')){
            return false;
        }
    }

    if(!(s.back()==':')){
        return false;
    }

    return true;
}

bool mips_is_data(const string &s)
{
    if(s.empty()){
        return false;
    }

    int pos=0;
    if(s[pos]=='-' || s[pos]=='+'){
        pos=pos+1;
    }

    while(pos < s.size()){
        if(!isdigit(s[pos])){
            return false;
        }
        pos++;
    }

    return true;
}

char mips_instruction_type(const string &s)
{
    if (s == "j" || s == "jal") {
        return 'j';
    }

    if (s == "addu") return 'r';
    if (s == "and") return 'r';
    if (s == "or") return 'r';
    if (s == "slt") return 'r';
    if (s == "sltu") return 'r';
    if (s == "subu") return 'r';
    if (s == "xor") return 'r';
    if (s == "sll") return 'r';
    if (s == "sllv") return 'r';
    if (s == "sra") return 'r';
    if (s == "srav") return 'r';
    if (s == "srl") return 'r';
    if (s == "srlv") return 'r';
    if (s == "div") return 'r';
    if (s == "divu") return 'r';
    if (s == "mthi") return 'r';
    if (s == "mtlo") return 'r';
    if (s == "mult") return 'r';
    if (s == "multu") return 'r';
    if (s == "jalr") return 'r';
    if (s == "jr") return 'r';

    return 'i';
}

uint16_t mips_instr_to_opcode(const string &s)
{
    if (s == "addiu") return 9;
    if (s == "addu") return 0;
    if (s == "and") return 0;
    if (s == "andi") return 12;
    if (s == "beq") return 4;
    if (s == "bgez") return 1;
    if (s == "bgezal") return 1;
    if (s == "bgtz") return 7;
    if (s == "blez") return 6;
    if (s == "bltz") return 1;
    if (s == "bltzal") return 1;
    if (s == "bne") return 5;
    if (s == "div") return 0;
    if (s == "divu") return 0;
    if (s == "j") return 2;
    if (s == "jal") return 3;
    if (s == "jalr") return 0;
    if (s == "jr") return 0;
    if (s == "lb") return 32;
    if (s == "lbu") return 36;
    if (s == "lh") return 33;
    if (s == "lhu") return 37;
    if (s == "lui") return 15;
    if (s == "lw") return 35;
    if (s == "lwl") return 38;
    if (s == "lwr") return 39;
    if (s == "mthi") return 0;
    if (s == "mtlo") return 0;
    if (s == "mult") return 0;
    if (s == "multu") return 0;
    if (s == "or") return 0;
    if (s == "ori") return 13;
    if (s == "sb") return 40;
    if (s == "sh") return 41;
    if (s == "sll") return 0;
    if (s == "sllv") return 0;
    if (s == "slt") return 0;
    if (s == "slti") return 10;
    if (s == "sltiu") return 11;
    if (s == "sltu") return 0;
    if (s == "sra") return 0;
    if (s == "srav") return 0;
    if (s == "srl") return 0;
    if (s == "srlv") return 0;
    if (s == "subu") return 0;
    if (s == "sw") return 43;
    if (s == "xor") return 0;
    if (s == "xori") return 14;
    return -1;
}

uint16_t mips_r_instr_to_fncode(const string &s)
{
    assert(mips_instruction_type(s)=='r');
    if (s == "addu") return 33;
    if (s == "and") return 36;
    if (s == "div") return 26;
    if (s == "divu") return 27;
    if (s == "jalr") return 9;
    if (s == "jr") return 8;
    if (s == "mthi") return 17;
    if (s == "mtlo") return 19;
    if (s == "mult") return 24;
    if (s == "multu") return 25;
    if (s == "or") return 37;
    if (s == "sll") return 0;
    if (s == "sllv") return 4;
    if (s == "slt") return 42;
    if (s == "sltu") return 43;
    if (s == "sra") return 3;
    if (s == "srav") return 7;
    if (s == "srl") return 2;
    if (s == "srlv") return 6;
    if (s == "subu") return 35;
    if (s == "xor") return 38;
    return -1;
}

string to_hex8(uint32_t x)
{
    char tmp[16]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
    string res;
    res.push_back(tmp[(x>>28)&0xF]);
    res.push_back(tmp[(x>>24)&0xF]);
    res.push_back(tmp[(x>>20)&0xF]);
    res.push_back(tmp[(x>>16)&0xF]);
    res.push_back(tmp[(x>>12)&0xF]);
    res.push_back(tmp[(x>>8)&0xF]);
    res.push_back(tmp[(x>>4)&0xF]);
    res.push_back(tmp[x&0xF]);
    return res;
}

vector<string> string_break(string s)
{
    vector<string> res;
    string word = "";
    for(int i=0; i<s.size(); i++){
        if (s[i] == ' ') {
            res.push_back(word);
            word = "";
        } else if (i == s.size()-1) {
            word = word + s[i];
            res.push_back(word);
        } else {
            word = word + s[i];
        }
    }
    return res;
}

pair<string, string> sep_word (string s)
{
    for (int i=0; i<s.size(); i++) {
        if (s[i] == ' ') {
            return {s.substr(0, i), s.substr(i, s.size())};
        }
    }
    return {"ERR", "ERR"};
}

vector<string> opr_break(string s)
{
    vector<string> res;
    string word = "";
    for(int i=0; i<s.size(); i++){
        if (s[i] == ',') {
            res.push_back(word);
            word = "";
        } else if (i == s.size()-1) {
            word = word + s[i];
            res.push_back(word);
        } else {
            word = word + s[i];
        }
    }
    return res;
}

pair<string, string> addr_break(string s)
{
    int openb;
    int closeb;
    for (int i=0; i<s.size(); i++) {
        if (s[i] == '(') {
            openb = i;
        }
        if (s[i] == ')') {
            closeb = i;
        }
    }
    string rs = s.substr(openb+1, closeb-1);
    string offset = s.substr(0, openb);
    rs.pop_back();
    return {rs, offset};
}

bool mips_is_mem_acc_instr(const string &s)
{
    if (s == "lb") return true;
    if (s == "lbu") return true;
    if (s == "lh") return true;
    if (s == "lhu") return true;
    if (s == "lw") return true;
    if (s == "lwl") return true;
    if (s == "lwr") return true;
    if (s == "sb") return true;
    if (s == "sh") return true;
    if (s == "sw") return true;
    return false;
}