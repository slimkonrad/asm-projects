;****************************************************************************************************************************
;* Program name: GNU Sort Debugger                                                                                          *
;* Copyright (C) 2025 Konner Rigby.                                                                                         *
;* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;* version 3 as published by the Free Software Foundation. This program is distributed in the hope that it will be useful,   *
;* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See    *
;* the GNU General Public License for more details. A copy of the GNU General Public License v3 is available here:          *
;* <https://www.gnu.org/licenses/>.                                                                                         *
;****************************************************************************************************************************

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; Author information
; Author: Konner Rigby
; Author Email: rigbykonner@csu.fullerton.edu or rigbykonner@gmail.com
; CWID: 884547654
; Class: 240-03 Section 03
;
; Program information
;   Program name: GNU Sort Debugger
;   Programming languages: C, x86-64 Assembly, Bash
;   Date program began: 2025-Oct-03
;   Date of last update: 2025-Oct-10
;   Files in this program: executive.c, manager.asm, inputarray.asm, outputarray.asm, sum.asm, sort.c, swap.asm,
;                          isfloat.asm, backuprestore.inc, r.sh
;   Status: Ready for GDB debugging.
;
; Purpose
;   This program serves as a workspace to experiment with and learn the capabilities of the GNU Debugger (GDB).
;
; This file
;   File name: isnan.asm
;   Language: x86-64 Assembly
;   Assemble: nasm -f elf64 -o isnan.o isnan.asm
;   Purpose: A function to check if a 64-bit float (passed in XMM0) is a Not-a-Number (NaN) using
;           the unordered compare instruction (UCOMISD). Returns 0 for NaN, 1 otherwise.
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

global isnan
%include "backuprestore.inc"

segment .data

segment .bss

segment .text
isnan:

; Function Prologue: Save all GPRs
backup

; Move XMM0 (input) to XMM15 for local use
movsd xmm15, xmm0

; UCOMISD compares XMM15 to itself. If the result is unordered (PF=1), it is a NaN.
ucomisd xmm15, xmm15
jne nan  ; Jump if parity flag (PF) is set (unordered = NaN)

; If not NaN
mov rax, 1
jmp exit

nan:
; If NaN
mov rax, 0

exit:
; Function Epilogue: Restore all GPRs
restore
ret