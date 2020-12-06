#!/bin/bash

set -eou pipefail

MIPS_SOURCES="utils/mips_assembly.cpp utils/mips_disassembly.cpp utils/mips_simulator.cpp utils/mem_wr_out.cpp"

echo "Compiling MIPS utils" > /dev/stderr
g++ -o bin/assembler utils/assembler.cpp ${MIPS_SOURCES}
g++ -o bin/simulator utils/simulator.cpp ${MIPS_SOURCES}
g++ -o bin/disassembler utils/disassembler.cpp ${MIPS_SOURCES}
echo "  done" > /dev/stderr
