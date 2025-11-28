; ****************************************************************************************************************************
; Program name: "Express Delivery".  This program demonstrates how to input and output a string with embedded    
; white space.  Copyright (C) 2025  Konner Rigby                                                                          
; This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  
; version 3 as published by the Free Software Foundation.                                                                  
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     
; A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                          
; ****************************************************************************************************************************



;// =======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;//Author information
;//  Author name: Konner Rigby
;//  Author email: rigbykonner@gmail.com or rigbykonner@csu.fullerton.edu
;//
;//Program information
;//  Program name: Express Delivery
;//  Programming languages X86 with one module in C++
;//
;//Purpose
;//  We will be taking user input to determine the total time driven and average speed between 3 locations
;//
;//Project information
;//  Files  main.cpp, expressdelivery.asm, run.sh, macro.inc
;//  Status: The program has been tested extensively with no detectable errors.
;//
;//Translator information
;// Gnu assembler: nasm -f elf64 -o expressdelivery.o expressdelivery.asm
;// Gnu compiler:  g++ -c -m64 -Wall -std=c++2a -o main.o main.cpp
;// Gnu linker:    g++ -m64 -std=c++2a -o learn.out expressdelivery.o main.o
;//  Execution: ./learn.out
;//
;//References and credits
;//  No references: this module is standard C++
;//
;//===== Begin code area ===================================================================================================================================================*/


%include "macro.inc"
global expressdelivery
extern printf ; grabs functions from C
extern scanf ; ^^^
extern fgets 
extern stdin
extern strlen


segment .data

    dist1 dq 0.0
    dist2 dq 0.0
    dist3 dq 0.0
    speed1 dq 0.0
    speed2 dq 0.0
    speed3 dq 0.0

    prompt_hi db "This software is maintained by Konner Rigby", 10, 0
    prompt_help db "For assistance contact the developer at rigbykonner@gmail.com", 10, 0
    prompt_dist1 db 10, "Enter the miles driven from Fullerton to Mission Viejo: ", 0
    prompt_dist2 db 10, "Enter the miles driven from Mission Viejo to Long Beach: ",  0
    prompt_dist3 db 10, "Enter the miles driven from Long Beach to Fullerton: ",  0 
    prompt_speed db "Enter the average speed (miles per hour) of that leg of the trip: ", 0
    float_format db "%lf", 0
    
    ; this is for testing 
    testing_prompt db "The total distance is %.2lf miles.", 10, 0
    testing_prompt2 db 10, "The total driving time is %.2lf hours.", 10, 0
    testing_prompt3 db "The average speed was %.2lf m/h.", 10, 0
    





segment .text

    

expressdelivery:
    backup 

    mov rax, 0
    mov rdi, prompt_hi
    call printf

    mov rax, 0 
    mov rdi, prompt_help
    call printf

    ; prompting user for fullerton->mission viejo
    mov rax, 0
    mov rdi, prompt_dist1
    call printf
    
    ; gets the distance for fullerton->mission viejo  
    mov rax, 0
    mov rdi, float_format
    mov rsi, dist1 
    call scanf 

    ; gets the speed for fullerton->mission viejo
    mov rax, 0
    mov rdi, prompt_speed
    call printf 

    mov rax, 0
    mov rdi, float_format 
    mov rsi, speed1
    call scanf 



    ; prompts the user for Mission Viejo->Long Beach
    mov rax, 0 
    mov rdi, prompt_dist2
    call printf 

    ; Gets the distance for Mission Viejo to Long Beach: 
    mov rax, 0 
    mov rdi, float_format 
    mov rsi, dist2
    call scanf

    ; Gets the speed for mission viejo to long beach
    mov rax, 0
    mov rdi, prompt_speed
    call printf 
    
    mov rax, 0
    mov rdi, float_format 
    mov rsi, speed2
    call scanf
    

    ; prompts the user for Long beach->fullerton 
    mov rax, 0
    mov rdi, prompt_dist3
    call printf

    ; gets the distance for long beach->fullerton
    mov rax, 0 
    mov rdi, float_format 
    mov rsi, dist3 
    call scanf

    ; gets the speed  for longbeach->fullerton

    mov rax, 0
    mov rdi, prompt_speed
    call printf

    mov rax, 0
    mov rdi, float_format 
    mov rsi, speed3 
    call scanf


    ; stores all the distances into a total distance
    
    
    movsd xmm14, [dist1] ; stores distance1 into xmm14
    movsd xmm13, [dist2] ; into xmm2
    movsd xmm12, [dist3] ; into xmm3
    movsd xmm5, xmm14 
    addsd xmm15, xmm13 ; adds 0 with 1
    addsd xmm15, xmm12 ; adds 1 with 2 and 0 
    
    movsd xmm10, [speed1]
    movsd xmm9, [speed2]
    movsd xmm8, [speed3]
    divsd xmm14, xmm10
    divsd xmm13, xmm9
    divsd xmm12, xmm8
    movsd xmm11, xmm14 ; xmm11 here holds distance1/speed1
    addsd xmm11, xmm13 ; adds first total speed by 2nd
    addsd xmm11, xmm12 ; now it holds the total speed driven
    
    movsd xmm7, xmm15 
    divsd xmm7, xmm11 ; holds avg speed 

    


    ; testing output for total dist
    ; mov rdi, testing_prompt 
    ; movsd xmm0, xmm15
    ; call printf 

    ; testing for total time driven
    mov rax, 1
    mov rdi, testing_prompt2
    movsd xmm0, xmm11
    call printf

    ; testing for avg speed 
    mov rax, 1 
    mov rdi, testing_prompt3
    movsd xmm0, xmm7
    call printf 

    
    movsd xmm0, xmm7


    ; Restore the general purpose registers
    restore

    ; Return
    ret





    


