#!/bin/bash

#Author: Konner Rigby
#Program name: Express Delivery
#Purpose: This is a Bash script file whose purpose is to compile and run the program "Express Delivery".

# For research purpose only. Please don't copy word for word. Avoid academic dishonesty. 

# Remove old object and executable files
rm -f *.o learn.out

# Assemble the assembly file into an object file
echo "Assembling expressdelivery.asm into expressdelivery.o"
nasm -f elf64 -o expressdelivery.o expressdelivery.asm

# Compile main.cpp into an object file
echo "Compiling main.cpp into main.o"
g++ -c -m64 -Wall -fno-pie -no-pie -o main.o main.cpp

# Link object files into executable
echo "Linking expressdelivery.o and main.o into learn.out"
g++ -m64 -Wall -fno-pie -no-pie -z noexecstack -lm -o learn.out expressdelivery.o main.o

# Run the program
echo "Running the program:"
./learn.out
# chmod +x r.sh
echo 
echo "This bash file will now terminate."
