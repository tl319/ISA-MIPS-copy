
#!/bin/bash
set -eou pipefail

CPU_SRC="./../rtl"
TESTCASE="$1" #name of the testcase

BIN_DIRECTORY="./bin"
if [ -d "${BIN_DIRECTORY}" ]
then
>&2 echo "bin directory already created."
else
>&2 echo "Creating bin directory..."
mkdir bin
fi 

BINARY_DIRECTORY="./binary"
if [ -d "${BINARY_DIRECTORY}" ]
then
>&2 echo "binary directory already created"
else
>&2 echo "Creating binary directory..."
mkdir binary
fi 


OUTPUT_DIRECTORY="./output"
if [ -d "${OUTPUT_DIRECTORY}" ]
then
>&2 echo "output directory already created"
else
>&2 echo "Creating output directory..."
mkdir output
fi 


WAVEFORM_DIRECTORY="./waveforms"
if [ -d "${WAVEFORM_DIRECTORY}" ]
then
>&2 echo "waveforms directory already created"
else
>&2 echo "Creating waveforms directory..."
mkdir waveforms
fi 

VERILOG_DIRECTORY="./verilog_sim"
if [ -d "${VERILOG_DIRECTORY}" ]
then
>&2 echo "verilog_sim directory already created"
else
>&2 echo "Creating veriog_sim directory..."
mkdir verilog_sim
fi 

FILE="./bin/assembler1"
if [ -f "$FILE" ]
then
>&2 echo "Assembler already created."
else
>&2 echo "Creating assembler..."
g++ ./utils/assembler_v2.cpp ./utils/mips_assembly.cpp -o ./bin/assembler
fi 

FILE="./bin/output_filter"
if [ -f "$FILE" ]
then
>&2 echo "output_filter already created."
else
>&2 echo "Creating output_filter..."
g++ ./utils/output_filter.cpp ./utils/mips_filter.cpp -o ./bin/output_filter
fi 


>&2 echo "Assembling instructions..."
./bin/assembler ./testcases/${TESTCASE}.asm.txt >| ./binary/${TESTCASE}.hex.txt


>&2 echo "CPU being tested for ${TESTCASE} testcase..."

>&2 echo "Compiling test-bench..."
# Compile a specific simulator for this variant and testbench.
# -s specifies exactly which testbench should be top-level
# The -P command is used to modify the RAM_INIT_FILE parameter on the test-bench at compile-time
iverilog -g 2012 \
   ${CPU_SRC}/*.v ./test_bench/*.v\
   -s mips_tb \
   -Pmips_tb.RAM_INIT_FILE=\"binary/${TESTCASE}.hex.txt\" \
   -o ./verilog_sim/mips_tb_${TESTCASE} 


>&2 echo "Running test-bench..."
if [[ $? -eq 0 ]]
then
   ./verilog_sim/mips_tb_${TESTCASE} >| ./output/${TESTCASE}.stdout
   mv ./cpu_toplvl_waves.vcd ./waveforms/${TESTCASE}.vcd
else
   >&2 echo "something went wrong, please check name of test case"
fi

>&2 echo "Extracting memory output..."
./bin/output_filter ./output/${TESTCASE}.stdout >| ./output/${TESTCASE}.out
