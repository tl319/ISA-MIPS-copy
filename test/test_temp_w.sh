
#!/bin/bash
set -eou pipefail

CPU_SRC=$1
TESTCASE="$2" #name of the testcase
TESTCASE_w="${TESTCASE}_w"
TMP=$(echo "$TESTCASE" | cut -d "_" -f 1)
INSTRUCTION=$(echo "${TMP/+/,}")

ROOT="./test/"
PADDING="11"

DEBUG_DIRECTORY="${ROOT}debug"
if [ -d "${DEBUG_DIRECTORY}" ]
then
>&2 echo "debug directory already created" >| ${ROOT}debug/${TESTCASE_w}.txt
else
# >&2 echo "Creating debug directory..."
mkdir ${ROOT}debug
fi

BIN_DIRECTORY="${ROOT}bin"
if [ -d "${BIN_DIRECTORY}" ]
then
>&2 echo "bin directory already created." >> ${ROOT}debug/${TESTCASE_w}.txt
else
>&2 echo "Creating bin directory..." >> ${ROOT}debug/${TESTCASE_w}.txt
mkdir ${ROOT}bin
fi

BINARY_DIRECTORY="${ROOT}binary"
if [ -d "${BINARY_DIRECTORY}" ]
then
>&2 echo "binary directory already created" >> ${ROOT}debug/${TESTCASE_w}.txt
else
>&2 echo "Creating binary directory..." >> ${ROOT}debug/${TESTCASE_w}.txt
mkdir ${ROOT}binary
fi


OUTPUT_DIRECTORY="${ROOT}output"
if [ -d "${OUTPUT_DIRECTORY}" ]
then
>&2 echo "output directory already created" >> ${ROOT}debug/${TESTCASE_w}.txt
else
>&2 echo "Creating output directory..." >> ${ROOT}debug/${TESTCASE_w}.txt
mkdir ${ROOT}output
fi


WAVEFORM_DIRECTORY="${ROOT}waveforms"
if [ -d "${WAVEFORM_DIRECTORY}" ]
then
>&2 echo "waveforms directory already created" >> ${ROOT}debug/${TESTCASE_w}.txt
else
>&2 echo "Creating waveforms directory..." >> ${ROOT}debug/${TESTCASE_w}.txt
mkdir ${ROOT}waveforms
fi

SIMOUT_DIRECTORY="${ROOT}sim_output"
if [ -d "${SIMOUT_DIRECTORY}" ]
then
>&2 echo "sim_output directory already created" >> ${ROOT}debug/${TESTCASE_w}.txt
else
>&2 echo "Creating sim_output directory..." >> ${ROOT}debug/${TESTCASE_w}.txt
mkdir ${ROOT}sim_output
fi

VERILOG_DIRECTORY="${ROOT}verilog_sim"
if [ -d "${VERILOG_DIRECTORY}" ]
then
>&2 echo "verilog_sim directory already created" >> ${ROOT}debug/${TESTCASE_w}.txt
else
>&2 echo "Creating veriog_sim directory..." >> ${ROOT}debug/${TESTCASE_w}.txt
mkdir ${ROOT}verilog_sim
fi

FILE="${ROOT}bin/assembler"
if [ -f "$FILE" ]
then
>&2 echo "Assembler already created." >> ${ROOT}debug/${TESTCASE_w}.txt
else
>&2 echo "Creating assembler..." >> ${ROOT}debug/${TESTCASE_w}.txt
g++ ${ROOT}utils/assembler_v2.cpp ${ROOT}utils/mips_assembly.cpp -o ${ROOT}bin/assembler
fi

FILE="${ROOT}bin/simulator"
if [ -f "$FILE" ]
then
>&2 echo "simulator already created." >> ${ROOT}debug/${TESTCASE_w}.txt
else
>&2 echo "Creating simulator..." >> ${ROOT}debug/${TESTCASE_w}.txt
g++ ${ROOT}utils/mips_assembly.cpp ${ROOT}utils/simulator.cpp ${ROOT}utils/mips_disassembly.cpp ${ROOT}utils/mem_wr_out.cpp ${ROOT}utils/mips_simulator.cpp -o ${ROOT}bin/simulator
fi

FILE="${ROOT}bin/output_filter"
if [ -f "$FILE" ]
then
>&2 echo "output_filter already created." >> ${ROOT}debug/${TESTCASE_w}.txt
else
>&2 echo "Creating output_filter..." >> ${ROOT}debug/${TESTCASE_w}.txt
g++ ${ROOT}utils/output_filter.cpp ${ROOT}utils/mips_filter.cpp -o ${ROOT}bin/output_filter
fi

FILE="${ROOT}bin/mem_access_filter"
if [ -f "$FILE" ]
then
>&2 echo "mem_access_filter already created." >> ${ROOT}debug/${TESTCASE_w}.txt
else
>&2 echo "Creating mem_access_filter..." >> ${ROOT}debug/${TESTCASE_w}.txt
g++ ${ROOT}utils/mem_access_filter.cpp ${ROOT}utils/mips_assembly.cpp -o ${ROOT}bin/mem_access_filter
fi

FILE="${ROOT}bin/output_cmp"
if [ -f "$FILE" ]
then
>&2 echo "output_cmp already created." >> ${ROOT}debug/${TESTCASE_w}.txt
else
>&2 echo "Creating output_cmp..." >> ${ROOT}debug/${TESTCASE_w}.txt
g++ ${ROOT}utils/output_cmp.cpp -o ${ROOT}bin/output_cmp
fi

>&2 echo "Assembling instructions..." >> ${ROOT}debug/${TESTCASE_w}.txt
>&2 ${ROOT}bin/assembler ${ROOT}testcases/${TESTCASE}.asm.txt >| ${ROOT}binary/${TESTCASE}.hex.txt 2>> ${ROOT}debug/${TESTCASE_w}.txt


>&2 echo "CPU being tested for ${TESTCASE_w} testcase..." >> ${ROOT}debug/${TESTCASE_w}.txt

>&2 echo "Compiling test-bench..." >> ${ROOT}debug/${TESTCASE_w}.txt
# Compile a specific simulator for this variant and testbench.
# -s specifies exactly which testbench should be top-level
# The -P command is used to modify the RAM_INIT_FILE parameter on the test-bench at compile-time
iverilog -g 2012 \
   ${CPU_SRC}/*.v ${ROOT}test_bench/*.v\
   -s mips_tb_w \
   -Pmips_tb_w.RAM_INIT_FILE=\"${ROOT}binary/${TESTCASE}.hex.txt\" \
   -o ${ROOT}verilog_sim/mips_tb_${TESTCASE_w}

COMPILE_RES=$?

>&2 echo "Running test-bench..." >> ${ROOT}debug/${TESTCASE_w}.txt
if [[ ${COMPILE_RES} -eq 0 ]]
then
   set +e
   ${ROOT}verilog_sim/mips_tb_${TESTCASE_w} >| ${ROOT}output/${TESTCASE_w}.stdout
   HALT=$?
   set -e
   mv ./cpu_toplvl_waves.vcd ${ROOT}waveforms/${TESTCASE_w}.vcd
else
   >&2 echo "something went wrong, please check name of test case" >> ${ROOT}debug/${TESTCASE_w}.txt
fi

if [[ "${HALT}" -ne 0 ]] ; then
   printf "%-${PADDING}s %-${PADDING}s Fail #CPU does not halt, caused by wait request\n" ${TESTCASE_w} ${INSTRUCTION,,}
   exit
fi

>&2 echo "Extracting memory output..." >> ${ROOT}debug/${TESTCASE_w}.txt
set +e
${ROOT}bin/output_filter ${ROOT}output/${TESTCASE_w}.stdout >| ${ROOT}output/${TESTCASE_w}.out 2>> ${ROOT}debug/${TESTCASE_w}.txt
FILTER_RES=$?
set -e
if [[ ${FILTER_RES} -ne 0 ]]
then
   >&2 echo "${ROOT}test/bin/output_filter not able to extract output, please check output file exists" >> ${ROOT}debug/${TESTCASE_w}.txt
fi
# echo "after filter $?"


>&2 echo "Extracting memory accesses..." >> ${ROOT}debug/${TESTCASE_w}.txt
set +e
${ROOT}bin/mem_access_filter < ${ROOT}output/${TESTCASE_w}.stdout > ${ROOT}output/${TESTCASE_w}_mem.out 2>> ${ROOT}debug/${TESTCASE_w}.txt
FILTER_RES=$?
set -e
if [[ ${FILTER_RES} -ne 0 ]]
then
   >&2 echo "${ROOT}test/bin/mem_access_filter not able to extract output, please check output file exists" >> ${ROOT}debug/${TESTCASE_w}.txt
fi



>&2 echo "Simulating output..." >> ${ROOT}debug/${TESTCASE_w}.txt
set +e
${ROOT}bin/simulator < ${ROOT}binary/${TESTCASE}.hex.txt >| ${ROOT}sim_output/${TESTCASE_w}.out 2>> ${ROOT}debug/${TESTCASE_w}.txt
SIM_RES=$?
set -e
if [[ ${SIM_RES} -ne 0 ]]
then
   >&2 echo "${ROOT}/bin/simulator not able to produce proper output, please check testcases are valid" >> ${ROOT}debug/${TESTCASE_w}.txt
fi

set +e
>&2 echo "Comparing results..." >> ${ROOT}debug/${TESTCASE_w}.txt
diff -iw ${ROOT}output/${TESTCASE_w}.out ${ROOT}sim_output/${TESTCASE_w}.out >> ${ROOT}debug/${TESTCASE_w}.txt 2>> ${ROOT}debug/${TESTCASE_w}.txt
RESULT=$?

>&2 echo "Comparing memory accesses..." >> ${ROOT}debug/${TESTCASE_w}.txt
./output_cmp ${ROOT}output/${TESTCASE_w}_mem.out ${ROOT}sim_output/memory_accesses.txt
#diff -iw ${ROOT}output/${TESTCASE}.out ${ROOT}sim_output/${TESTCASE}.out >> ${ROOT}debug/${TESTCASE}.txt 2>> ${ROOT}debug/${TESTCASE}.txt
RESULT2=$?
set -e

if [[ "${RESULT}" -eq 0 ]] && [[ "${RESULT2}" -eq 0 ]] ; then
   printf "%-${PADDING}s %-${PADDING}s Pass\n" ${TESTCASE_w} ${INSTRUCTION,,}
else
   printf "%-${PADDING}s %-${PADDING}s Fail #Caused by wait request\n" ${TESTCASE_w} ${INSTRUCTION,,}
fi
