#!/bin/sh

# TODO: Actually do some checks before running stuff...

if [ -z ${RISCVY_HOME} ]; then 
	echo "RISCVY_HOME is not set. Have you sourced sourceme in the toplevel directory?"
	exit 1
else 
	echo "RISCVY_HOME is set to '$RISCVY_HOME'"
fi

set -o xtrace

cd $RISCVY_HOME
cd test-programs

riscv32-unknown-elf-gcc hello.c -o hello
spike pk hello
