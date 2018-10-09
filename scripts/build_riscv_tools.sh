#!/bin/bash

# This script encapsulates the setup described in the rocket chip docs.
set -e

echo "===== STARTING RISC-V BUILD TOOLS SCRIPT ====="


# Creds: https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
if [ -z ${RISCVY_HOME} ]; then 
	echo "RISCVY_HOME is not set. Have you sourced sourceme in the toplevel directory?"
	exit 1
else 
	echo "RISCVY_HOME is set to '$RISCVY_HOME'"
fi

if [ -z ${RISCV} ]; then 
	echo "RISCV is not set. Have you sourced sourceme in the toplevel directory?" 
	exit 1
else 
	echo "RISCV is set to '$RISCV'"
fi

echo -e "\n*\nInstalling required dependences... assuming we are on ubuntu...\n*\n"

# Just going to assume that this is run on Ubuntu 18LTS for now...
sudo apt-get install -y autoconf automake autotools-dev curl device-tree-compiler libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat1-dev pkg-config

echo -e "\n*\nNavigating to RISC-V tool source and building binaries...\n*\n"

cd $RISCVY_HOME

git submodule update --init --recursive

cd rocket-chip/riscv-tools

# -jN refers to the number of cores on the build system.
export MAKEFLAGS="$MAKEFLAGS -j4"
./build.sh
./build-rv32ima.sh

echo -e "\n\nSee the following folder for built tools: $RISCV"
echo "===== RISC-V BUILD TOOLS SCRIPT COMPLETE ====="
