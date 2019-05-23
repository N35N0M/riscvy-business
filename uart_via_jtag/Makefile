# File: makefile
# Author: Aaron Odell
# Company: Digilent Inc.
# Date: 8/16/2010
# Description: makefile for Adept SDK DjtgDemo

CC = gcc
INC = /usr/include/digilent/adept
LIBDIR = /usr/lib64/digilent/adept
TARGETS = DjtgDemo
CFLAGS = -I $(INC) -L $(LIBDIR) -ldjtg -ldmgr

all: $(TARGETS)

DjtgDemo:
	$(CC) -o DjtgDemo DjtgDemo.cpp $(CFLAGS)
	

.PHONY: clean

clean:
	rm -f $(TARGETS)

