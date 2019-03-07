#!/bin/bash

function printMsg(){
	printf "\nSTATUS CODE: $1\n
|-------------|--------------|-------------|
| COMPILATION | MEMORY LEAKS | THREAD RACE |
|-------------|--------------|-------------|
|-------------|--------------|-------------|
|----$2-----|-----$3-----|----$4-----|
|-------------|--------------|-------------|
|-------------|--------------|-------------|\n
\n"
exit $1
}

# Bash arguments
dirPath=$1
program=$2

# Variables
finOut=0
printMake="PASS"
printVal="PASS"
printHel="PASS"

# Check if Makefile exists
cd $dirPath
if [ ! -f Makefile ]; then
    echo "MAKEFILE NOT FOUND"
    exit 7
else
	# Run Makefile
	make
	outMake=$?

	if [ $outMake -gt 0 ]; then
		finOut=$(($finOut + 7))
		printMake="FAIL"
		printVal="FAIL"
		printHel="FAIL"
	else
		# Shift the arguments array by 2
		shift 2

		# Run memory leak test
		valgrind --leak-check=full --error-exitcode=1 ./$program $@
		outVal=$?

		if [ $outVal -eq 1 ]; then
			finOut=$(($finOut + 2))
			printVal="FAIL"
		fi

		# Run thread racing test
		valgrind --tool=helgrind --error-exitcode=1 ./$program $@
		outHel=$?
		if [ $outHel -eq 1 ]; then
			finOut=$(($finOut + 1))
			printHel="FAIL"
		fi
	fi
fi

# Print the result
printMsg $finOut $printMake $printVal $printHel