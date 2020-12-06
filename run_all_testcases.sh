#!/bin/bash
set -eou pipefail


#compiling MIPS utils cpp files
./build_utils.sh

TESTCASE_NAMES="test/testcases/*.asm.txt"

for i in ${TESTCASE_NAMES} ; do

    TESTCASE=$(basename ${i} .asm.txt)

    ./run_one_testcase.sh ${TESTCASE}
done
