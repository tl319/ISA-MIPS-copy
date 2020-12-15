#!/bin/bash
set -eou pipefail

SPEC=${1:-"null"}

if [ $SPEC == "null" ]
then
    # Use a wild-card to specifiy that every file with this pattern represents a testcase file
    TESTCASES="testcases/*.asm.txt"
    # Loop over every file matching the TESTCASES pattern
    for i in ${TESTCASES} ; do
        # Extract just the testcase name from the filename. See `man basename` for what this command does.
        TESTNAME=$(basename ${i} .asm.txt)
        # Dispatch to the main test-case script
        bash test_temp.sh "${TESTNAME}"
    done
else
    TESTCASES=$(find -ipath "./testcases/${SPEC}*") 
    for i in ${TESTCASES} ; do
        TESTNAME=$(basename ${i} .asm.txt)
        bash test_temp.sh "${TESTNAME}" 
    done
fi