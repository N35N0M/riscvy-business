#!/bin/bash

echo "===== STARTING CHISEL 3 INSTALL SCRIPT ====="
# Disclaimer: this is just a script based on https://github.com/freechipsproject/chisel3#installation
# Too lazy to do this manually more than once.

if [ -z ${RISCVY_HOME} ]; then 
	echo "RISCVY_HOME is not set. Have you sourced sourceme in the toplevel directory?"
	exit 1
else 
	echo "RISCVY_HOME is set to '$RISCVY_HOME'"
fi

echo -e "\n\n "
sudo apt-get install default-jdk
echo -e "\n\n "

# Source: https://stackoverflow.com/questions/226703/how-do-i-prompt-for-yes-no-cancel-input-in-a-linux-shell-script
REPO_KEY=642AC823

echo -e "***WARNING***: The provided key might be outdated. \nOnly continue to run if you are sure that this key can be trusted: $REPO_KEY\n\n"

while true; do
	read -p "Do you wish to install this program with the provided key? (y/n)" yn
	case $yn in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) echo "Please answer yes or no.";;
	esac
done

echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv $REPO_KEY
sudo apt-get update
sudo apt-get install -y sbt

echo -e "\n\n"

sudo apt-get install git make autoconf g++ flex bison

if [ ! -d tmp ]; then
	echo "Tmp doesnt exist. Making tmp dir."
	mkdir tmp
else
	echo "tmp exists!"
fi

cd tmp


if [ ! -d verilator ]; then
	git clone http://git.veripool.org/git/verilator
	git pull
	git checkout verilator_3_922
fi

cd verilator
unset VERILATOR_ROOT
autoconf
./configure
make
sudo make install
