		.ORIG x3000
	
		LDI R0, X 	; multiplicand and dividend
 		LDI R1, Y 	; multiplier and divisor

		JSR MULTIPLY 	; multiplication subroutine
 		STI R3, prod	; stores the product

		JSR DIVIDE	; division subroutine
		STI R2, quot	; stores the quotient
		STI R3, mod	; stores the remainder	

		HALT

X		.FILL x3100
Y		.FILL x3101
prod		.FILL x3102
quot		.FILL x3103
mod		.FILL x3104

; X * Y
MULTIPLY 	AND R2, R2, #0	; R4 is the sign of the product
		ADD R2, R2, #1	; Sign of the product is 1
		AND R3, R3, #0 	; Stores the product of X and Y

		ST R0, saveX	; Stores X into R0
		ST R1, saveY	; Stores Y into R1

		ADD R0, R0 , #0
		BRzp negX
		NOT R5, R0	; two's comp. of X
		ADD R5, R5, #1
		NOT R3, R3	; R3 <- (-R3)
		ADD R3, R3, #1

negX 		ADD R1, R1, #0	; Negates X
		BRzp negY
		NOT R6, R1	; two's comp. of Y
		ADD R6, R6, #1
		NOT R3, R3	; R3 <- (-R3)
		ADD R3, R3, #1

negY 		ADD R1, R1, #0	; Negates Y

loopM 		ADD R1, R1, #0	; Multiplication loop
		BRz stop	; If zero go to "stop"
		ADD R3, R3, R0	; R2 <- R2 + X
		ADD R1, R1, #-1	; Decrements Y
		BR loopM

stop 		ADD R2, R2, #0	; If sign is positive
		BRp done	; go to "done"
		NOT R3, R3
		ADD R3, R3, #1

done		LD R0, saveX	; Loads X 
		LD R1, saveY	; Loads Y
		RET

saveX 		.FILL x0	; Saves X
saveY 		.FILL x0	; Saves Y

DIVIDE 		AND R2, R2, #0	; Initializes quotient
		AND R3, R3, #0	; Initializes remainder
		AND R4, R4, #0	; Initializes valid
		AND R5, R5, #0	; Initializes temp

		ADD R0, R0 ,#0	; Go to "zero" 
		BRp zero	; if X is positive
		RET

zero 		ADD R1, R1, #0	; Go to "next"
		BRp next	; if Y is positive
		RET

next		ADD R4, R4, #1	; valid = 1
		ADD R5, R5, R0	; temp <- X
		NOT R1, R1	; two's comp. of X
		ADD R1, R1, #1

loopd		ADD R6, R5, R1	; R7 <- R6 + Y
		BRn done	; If negative go to "done"
		ADD R5, R5, R1	; temp - Y
		ADD R2, R2, #1	; quotient + 1
		ADD R3, R5, #0	; remainder <- temp
		BR loopd
		RET

		.END	
