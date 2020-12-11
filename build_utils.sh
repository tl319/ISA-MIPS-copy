#!/bin/bash

set -eou pipefail

MIPS_SOURCES="utils/mips_assembly.cpp utils/mips_disassembly.cpp utils/mips_simulator.cpp utils/mem_wr_out.cpp"

echo "Compiling MIPS utils" > /dev/stderr
g++  utils/assembler_v2.cpp ${MIPS_SOURCES} -o bin/assembler
g++  utils/simulator.cpp ${MIPS_SOURCES} -o bin/simulator

echo "  done" > /dev/stderr
