#include "mips.hpp"

pair<string, string> get_address (string s)
{
    for (int i=0; i<s.size(); i++) {
        if (s[i] == ':') {
            return {s.substr(0, i+2), s.substr(i+2, s.size())};
        }
    }
    return {"ERR", "ERR"};
}

bool output_is_data(const string &s)
{
    if (s == "FINAL MEMORY :") return true;
}
