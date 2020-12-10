#!/bin/bash
set -eou pipefail

TESTCASE="$1" #name of the testcase

>&2 echo "CPU being tested for ${TESTCASE} testcase..."

echo "${TESTCASE}"
#assembling the instructions
>&2 echo "Assembling instructions..."
./bin/assembler ./test/testcases/${TESTCASE}.asm.txt >|test/binary/${TESTCASE}.hex.txt
./bin/assembler ./test/testcases/${TESTCASE}.asm.txt >|test/binary/basics.hex.txt


>&2 echo "Compiling verilog files..."

#iverilog -g 2012 \
#   src/*.v  \
#   -s src/MIPS_tb.v \ #test bench what's the name???
#   -PMIPS_tb.RAM_INIT_FILE=\"test/binary/${TESTCASE}.hex.txt\" \
#   -o test/simulator/MIPS_tb_${TESTCASE}

   iverilog -g 2012 ./src/*.v -s ./src/MIPS_tb.v -o test/simulator/MIPS_tb_${TESTCASE} && ./test/simulator/MIPS_tb_${TESTCASE} >| basics.stdou

>&2 echo "Running verilog files..."

set +e
test/simulator/MIPS_tb_${TESTCASE} > test/output/MIPS_tb_${TESTCASE}.out #.stdout??????

#RES=$?
set -e

#failure code????

#extracting results from the output????

>&2 echo "Running the cpp simulator for reference..."

set +e
bin/simulator < test/binary/${TESTCASE}.hex.txt > test/reference/${TESTCASE}.out
set -e

>&2 echo "Comparing verilog output files with reference output files"


set +e
diff -w test/reference/${TESTCASE}.out test/output/MIPS_tb_${TESTCASE}.out
RES=$?
set -e


if [[ "${RES}" -ne 0 ]] ; then
   echo " ${TESTCASE}, FAIL"
else
   echo " ${TESTCASE}, pass"
fi
