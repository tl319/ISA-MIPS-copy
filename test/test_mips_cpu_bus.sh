#!/bin/bash
set -eou pipefail

CPU_SRC=${1:-null}
SPEC=${2:-null}
ROOT="./test/"
if [ -d  "${CPU_SRC}" ]
then
    if [ $SPEC == "null" ]
    then
        # Use a wild-card to specifiy that every file with this pattern represents a testcase file
        TESTCASES="${ROOT}testcases/*.asm.txt"
        # Loop over every file matching the TESTCASES pattern
        for i in ${TESTCASES} ; do
            # Extract just the testcase name from the filename. See `man basename` for what this command does.
            TESTNAME=$(basename ${i} .asm.txt)
            # Dispatch to the main test-case script
            # bash ${ROOT}test_temp.sh "${CPU_SRC}" "${TESTNAME}"
             bash ${ROOT}test_temp_w.sh "${CPU_SRC}" "${TESTNAME}"
        done
    else
        TESTCASES=$(find -ipath "${ROOT}testcases/${SPEC}_*.asm.txt") 
        for i in ${TESTCASES} ; do
            TESTNAME=$(basename ${i} .asm.txt)
            # bash ${ROOT}test_temp.sh "${CPU_SRC}" "${TESTNAME}"
            bash ${ROOT}test_temp_w.sh "${CPU_SRC}" "${TESTNAME}"
        done
    fi
else
    echo "Specified CPU directory - \"${CPU_SRC}\" not found, Please check CPU directory exists"
fi
