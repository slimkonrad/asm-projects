//****************************************************************************************************************************
//Program name: "Express Delivery".  This program demonstrates how to input and output a string with embedded    *
//white space.  Copyright (C) 2025  Konner Rigby                                                                           *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//****************************************************************************************************************************



// =======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
//Author information
//  Author name: Konner Rigby
//  Author email: rigbykonner@gmail.com or rigbykonner@csu.fullerton.edu
//
//Program information
//  Program name: Express Delivery
//  Programming languages X86 with one module in C++
//
//Purpose
//  We will be taking user input to determine the total time driven and average speed between 3 locations
//
//Project information
//  Files  main.cpp, expressdelivery.asm, run.sh, macro.inc
//  Status: The program has been tested extensively with no detectable errors.
//
//Translator information
// Gnu assembler: nasm -f elf64 -o expressdelivery.o expressdelivery.asm
// Gnu compiler:  g++ -c -m64 -Wall -std=c++2a -o main.o main.cpp
// Gnu linker:    g++ -m64 -std=c++2a -o learn.out expressdelivery.o main.o
//  Execution: ./learn.out
//
//References and credits
//  No references: this module is standard C++
//
//===== Begin code area ===================================================================================================================================================

#include <iostream>
#include <string>


extern "C" double expressdelivery();

int main() {
    std::string name = "";
    std::string e_address = "";

    std::cout << "Welcome to American Express Delivery Service\n";

    double count = 0;
    count = expressdelivery();

    // std::cout << "The driver received this number %.2lf and will keep it for future use.\n\n";
    printf("\nThe driver received this number %.2lf and will keep it for future use.\n", count);
    
    std::cout << "\nThank you for using our software. Have a nice day.\n";
    std::cout << "An integer zero will be returned to the operating system. \n";
    
    return 0;
}