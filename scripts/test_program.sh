#!/bin/sh

# TODO: Actually do some checks before running stuff...
set -o xtrace

cd $RISCVY_HOME
cd test_programs

riscv32-unknown-elf-gcc hello.c -o hello
spike pk hello
