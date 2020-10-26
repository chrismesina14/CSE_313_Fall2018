; Class: CSE 313 Machine Organization Lab
; Section: 04
; Instructor: Taline Georgiou
; Term: Fall 2018
; Name(s): Christian Mesina and Jared Acosta
; Lab #4: Fibonacci Numbers
; Description: This LC3 program implements the Fibonacci number sequence.
;	       This program will compute the nth Fibonacci number of a 
;	       specified number. This program will find the largest Fn such
;	       that no overflow occurs. It will n = N such that FN is the 
;	       largest Fibonacci number to be correctly represented with 16 
;	       bits in two's complement format. This program will store n	
;	       in x3100, Fn in x3101, N in x3102, and FN in x3103. For each
;	       n = 15 and n = 20, this program will show the values of F15 and F19
;	       respectively.

		.ORIG x3000

		LEA R0, xFF	; PC offset value is stored
		LDR R0, R0, #0	

; Initializing values into register
		ADD R1, R1, #0	
		ADD R2, R2, #1	; n = 1 and n = 2
		ADD R3, R3, #0	; Stores n	
		ADD R4, R4, #0	; Counters the current number

		ADD R0, R0, x-2	; Checks if n <= 2
		BRnz num	
		
Fib_n		NOT R5, R0	 
		ADD R5, R5, #1	; Compares the value against n
		ADD R5, R5, R4	; Subtracts the value from n
		BRz num		

		ADD R3, R1, R2	; Computes next Fn value
		ADD R4, R4, #1	; Increment the value
		ADD R1, R2, #0	; R1 = R2
		ADD R2, R3, #0	; R2 = R3
		BR Fib_n
	
num 		STI R3, Fn	; Stores Fn into R3

Num		ADD R3, R1, R2	; Computes next FN value
		BRn Fib_N	; If negative it overflow
		
		ADD R1, R2, #0	; R1 = R2
		ADD R2, R3, #0	; R2 = R3
		ADD R4, R4, #1	
		BR Num

Fib_N		STI R4, N	; Stores N into R4
		STI R2, FN	; Stores FN into R2

		HALT

Fn		.FILL x3101
N		.FILL x3102
FN		.FILL x3103
		.END