; Class: CSE 313 Machine Organization Lab
; Section: 04
; Instructor: Taline Georgiou
; Term: Fall 2018
; Name(s): Christian Mesina and Jared Acosta
; Lab #2: Arithmetic Functions
; Description: This LC-3 program computes the difference X - Y and places it at location x3122.
;	       It also place the absolute values |X| and |Y| at locations x3123 and x3124 respectively.
; 	       It also determines which of |X| and |Y| is larger. It places 1 at location x3125 if |X| 
;	       is, a 2 if |Y| is, or a 0 if they are equal.

	.ORIG x3000
	LDI R1, X	; R1 = X
 	LDI R2, Y	; R2 = Y

; X - Y 
 	NOT R3, R2	; 1's comp. of Y
 	ADD R3, R3, #1	; 2's comp. of Y
 	ADD R3, R1, R3	; R4 = X - Y
	STI R3, sub	; R3 <- (X - Y)

;|X|
	ADD R4, R1, #0
	BRzp abs1
	NOT R4, R1	; 1's comp. of X
	ADD R4, R4, #1	; 2's comp. of X
abs1	STI R4, absX	; R4 <- |X|

;|Y|
	ADD R5, R2, #0
	BRzp abs2
	NOT R5, R5	; 1's comp. of Y
	ADD R5, R5, #1	; 2's comp. of Y
abs2	STI R5, absY	; R5 <- |Y|

; |X| - |Y|
	NOT R5, R5	
	ADD R5, R5, #1	; R5 <- -|Y|
	ADD R6, R4, R5	; R6 <- |X| - |Y|
	BRz STORE	; If R6 is zer or positive, move to NEXT
	AND R6, R6, #0	; R6 <- #0
	ADD R6, R6, #2	; R6 <- #2
	BRp SETZ	; Z <- #2

STORE	BRz SETZ	; If R6 is zero, set Z <- #0
	AND R6, R6, #0	; R6 <- #0
	ADD R6, R6, #1	; R6 <- #1
	BRp SETZ	; Z <- #1

SETZ	STI R6, Z	; Z <- R6

	HALT
X	.FILL x3120
Y	.FILL x3121
sub	.FILL x3122
absX	.FILL x3123
absY	.FILL x3124
Z	.FILL x3125
	.END
