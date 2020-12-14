
#!/bin/bash
set -eou pipefail

CPU_SRC="./../rtl"
TESTCASE="$1" #name of the testcase

DEBUG_DIRECTORY="./debug"
if [ -d "${DEBUG_DIRECTORY}" ]
then
>&2 echo "debug directory already created" >> ./debug/${TESTCASE}.txt
else
>&2 echo "Creating debug directory..." 
mkdir debug
fi 

BIN_DIRECTORY="./bin"
if [ -d "${BIN_DIRECTORY}" ]
then
>&2 echo "bin directory already created." >> ./debug/${TESTCASE}.txt
else
>&2 echo "Creating bin directory..." >> ./debug/${TESTCASE}.txt
mkdir bin
fi 

BINARY_DIRECTORY="./binary"
if [ -d "${BINARY_DIRECTORY}" ]
then
>&2 echo "binary directory already created" >> ./debug/${TESTCASE}.txt
else
>&2 echo "Creating binary directory..." >> ./debug/${TESTCASE}.txt
mkdir binary
fi 


OUTPUT_DIRECTORY="./output"
if [ -d "${OUTPUT_DIRECTORY}" ]
then
>&2 echo "output directory already created" >> ./debug/${TESTCASE}.txt
else
>&2 echo "Creating output directory..." >> ./debug/${TESTCASE}.txt
mkdir output
fi 


WAVEFORM_DIRECTORY="./waveforms"
if [ -d "${WAVEFORM_DIRECTORY}" ]
then
>&2 echo "waveforms directory already created" >> ./debug/${TESTCASE}.txt
else
>&2 echo "Creating waveforms directory..." >> ./debug/${TESTCASE}.txt
mkdir waveforms
fi 

SIMOUT_DIRECTORY="./sim_output"
if [ -d "${SIMOUT_DIRECTORY}" ]
then
>&2 echo "sim_output directory already created" >> ./debug/${TESTCASE}.txt
else
>&2 echo "Creating sim_output directory..." >> ./debug/${TESTCASE}.txt
mkdir sim_output
fi 

VERILOG_DIRECTORY="./verilog_sim"
if [ -d "${VERILOG_DIRECTORY}" ]
then
>&2 echo "verilog_sim directory already created" >> ./debug/${TESTCASE}.txt
else
>&2 echo "Creating veriog_sim directory..." >> ./debug/${TESTCASE}.txt
mkdir verilog_sim
fi 

FILE="./bin/assembler"
if [ -f "$FILE" ]
then
>&2 echo "Assembler already created." >> ./debug/${TESTCASE}.txt
else
>&2 echo "Creating assembler..." >> ./debug/${TESTCASE}.txt
g++ ./utils/assembler_v2.cpp ./utils/mips_assembly.cpp -o ./bin/assembler
fi 

FILE="./bin/simulator"
if [ -f "$FILE" ]
then
>&2 echo "simulator already created." >> ./debug/${TESTCASE}.txt
else
>&2 echo "Creating simulator..." >> ./debug/${TESTCASE}.txt
g++ ./utils/mips_assembly.cpp ./utils/simulator.cpp ./utils/mips_disassembly.cpp ./utils/mem_wr_out.cpp ./utils/mips_simulator.cpp -o ./bin/simulator
fi 

FILE="./bin/output_filter"
if [ -f "$FILE" ]
then
>&2 echo "output_filter already created." >> ./debug/${TESTCASE}.txt
else
>&2 echo "Creating output_filter..." >> ./debug/${TESTCASE}.txt
g++ ./utils/output_filter.cpp ./utils/mips_filter.cpp -o ./bin/output_filter
fi 


>&2 echo "Assembling instructions..." >> ./debug/${TESTCASE}.txt
./bin/assembler ./testcases/${TESTCASE}.asm.txt >| ./binary/${TESTCASE}.hex.txt 


>&2 echo "CPU being tested for ${TESTCASE} testcase..." >> ./debug/${TESTCASE}.txt

>&2 echo "Compiling test-bench..." >> ./debug/${TESTCASE}.txt
# Compile a specific simulator for this variant and testbench.
# -s specifies exactly which testbench should be top-level
# The -P command is used to modify the RAM_INIT_FILE parameter on the test-bench at compile-time
iverilog -g 2012 \
   ${CPU_SRC}/*.v ./test_bench/*.v\
   -s mips_tb \
   -Pmips_tb.RAM_INIT_FILE=\"binary/${TESTCASE}.hex.txt\" \
   -o ./verilog_sim/mips_tb_${TESTCASE} 


>&2 echo "Running test-bench..." >> ./debug/${TESTCASE}.txt
if [[ $? -eq 0 ]]
then
   set +e
   ./verilog_sim/mips_tb_${TESTCASE} >| ./output/${TESTCASE}.stdout 
   HALT=$?
   set -e
   mv ./cpu_toplvl_waves.vcd ./waveforms/${TESTCASE}.vcd
else
   >&2 echo "something went wrong, please check name of test case" >> ./debug/${TESTCASE}.txt
fi

if [[ "${HALT}" -ne 0 ]] ; then
   echo "${TESTCASE} ${TESTCASE} FAIL #CPU does not halt"
   exit
fi

>&2 echo "Extracting memory output..." >> ./debug/${TESTCASE}.txt
./bin/output_filter ./output/${TESTCASE}.stdout >| ./output/${TESTCASE}.out 
# echo "after filter $?"
>&2 echo "Simulating output..." >> ./debug/${TESTCASE}.txt
./bin/simulator < ./binary/${TESTCASE}.hex.txt >| ./sim_output/${TESTCASE}.out 

set +e
>&2 echo "Comparing results..." >> ./debug/${TESTCASE}.txt
diff -iw ./output/${TESTCASE}.out ./sim_output/${TESTCASE}.out >> ./debug/${TESTCASE}.txt
RESULT=$?
set -e

if [[ "${RESULT}" -eq 0 ]] ; then 
   echo "${TESTCASE} ${TESTCASE} PASS"
else
   echo "${TESTCASE} ${TESTCASE} FAIL"
fi
