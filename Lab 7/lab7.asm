; Class: CSE 313 Machine Organization Lab
; Section: 04
; Instructor: Taline Georgiou
; Term: Fall 2018
; Name(s): Christian Mesina and Jared Acosta
; Lab #7: Compute Day of the Week
; Description: This LC-3 program calculates the given day, month and year
;	       and will return the day of the week. In this program, the usual
;	       number of the month will be stored at x31F0. The day of the month
;	       will be stored at x31F1 and the year will be stored at x31F2. The  
;	       output will contain a number between 0 and 6 that corresponds to the
;	       days of the week, starting with Sunday. This output will be stored in
;	       location x31F3. Also, the prompt will display the corresponding name	  
;	       of the day. This program will use Zeller's formula which is 
;	       f = k + (13m - 1)/5 + D + D/4 + C/4 - 2C. k is the day of the month, 
;	       m is the month number, D is the last 2 digits of the year, and C is 
;	       the century and it is the first two digits of the year. This program
;	       provides 5 outputs which are January 3, 1905, June 6 1938, June 23, 1941,
; 	       May 7, 1961, and the date when this lab is due which is November 28, 2018.

		.ORIG x3000

		LDI R3, MONTH			; M (month)
		LDI R4, DAY			; k (Day)
		LDI R5, YEAR			; D and C (year)
	
		JSR COMPUTE_M			; Calculate M
		JSR COMPUTE_D			; Calculate D
		JSR COMPUTE_C			; Calculate C
			
		ADD R6, R4 #0			; R6 <- k (Day)	
			
		LDI R2, M
		ADD R2, R2, #-1 		; (M - 1)
		AND R1, R1, #0	
		ADD R1, R1, #13 
		JSR MULTIPLY			; 13(M) - 1
	
		LDI R1, X_MUL_Y					
		AND R2, R2, #0
		ADD R2, R2, #5
		JSR DIVIDE			; (13 * (M - 1)) / 5
	
		LDI R1, X_DIV_Y
		ADD R6, R6, R1			; k + (13 * (M - 1)) / 5
		
		LDI R1, D
		ADD R6, R6, R1			; k + (13 * (M - 1)) / 5 + D
	
		AND R2, R2, #0
		ADD R2, R2, #4
		JSR DIVIDE			; D / 4
		LDI R1, X_DIV_Y
		ADD R6, R6, R1			; k + (13 * (M - 1))  / 5 + D + D / 4
	
		LDI R1, C
		AND R2, R2, #0
		ADD R2, R2, #4
		JSR DIVIDE			; C / 4
		
		LDI R1, X_DIV_Y		
		ADD R6, R6, R1			; k + (13 * (M - 1)) / 5 + D + (D / 4) + C / 4
	
	
		LDI R1, C
		AND R2, R2, #0
		ADD R2, R2, #2			
		JSR MULTIPLY			; -(2 * C)
	
		LDI R1, X_MUL_Y
		ADD R6, R6, R1			; Zeller's Formula
	
		LDI R0, DAY_OF_THE_WEEK
		ADD R1, R6, #0
		AND R2, R2, #0
		ADD R2, R2, #7
		JSR MOD				; f mod 7
	
		LDI R1, X_MOD_Y
		AND R2, R2, #0
		ADD R2, R2, #9
		JSR MULTIPLY
		LDI R1, X_MUL_Y
		ADD R0, R0, R1
		PUTS
		HALT


		LEA R0, DAYS
LOOP		ADD R0, R0, #10			; Go to next day
		ADD R3, R3, #-1			; Decrement loop variable
		BR LOOP

		PUTS
		HALT
	
DAYS	.STRINGZ "Sunday   "
	.STRINGZ "Monday   "
	.STRINGZ "Tuesday  "
	.STRINGZ "Wednesday"
	.STRINGZ "Thursday "
	.STRINGZ "Friday   "
	.STRINGZ "Saturday "

MONTH		.FILL x31F0
DAY		.FILL x31F1
YEAR		.FILL x31F2
DAY_OF_THE_WEEK .FILL x31F3
M		.FILL x3100
D		.FILL x3101
C		.FILL x3102	
X_MUL_Y 	.FILL x3103
X_DIV_Y 	.FILL x3104
X_MOD_Y 	.FILL x3105
N_100		.FILL #100


; Compute the value of M
COMPUTE_M	STI R1, SAVE_R1			; Save registers
		STI R2, SAVE_R2
		STI R3, SAVE_R3
		
		LDI R1, MONTH
		ADD R3, R1, #0
		AND R2, R2, #0
		ADD R2, R2, #-2
		ADD R1, R1, R2
		BRp MONTH_GET_2
		ADD R3, R3, #12
		BR #2
MONTH_GET_2	ADD R3, R3, #0
		STI R3, M 
		LDI R1, SAVE_R1			; Restore registers
		LDI R2, SAVE_R2
		LDI R3, SAVE_R3
		RET
		
; Compute the value of D
COMPUTE_D	STI R1, SAVE_R1			; Save registers
		STI R2, SAVE_R2
		STI R3, SAVE_R3

		LDI R1, YEAR
		LD  R2, N_100	
		JSR MOD				; Calculate D
		LDI R3, X_MOD_Y
		STI R3, D
		LDI R1, SAVE_R1			; Restore registers
		LDI R2, SAVE_R2
		LDI R3, SAVE_R3
		RET

; Compute the value of C
COMPUTE_C	STI R1, SAVE_R1			; Save registers
		STI R2, SAVE_R2
		STI R3, SAVE_R3

		LDI R1, YEAR
		LD  R2, N_100	
		JSR DIVIDE			; Calculate C
		LDI R3, X_DIV_Y
		STI R3, C
		LDI R1, SAVE_R1			; Restore registers
		LDI R2, SAVE_R2
		LDI R3, SAVE_R3
		RET

; Multpilication and Division Subroutine
MULTIPLY	AND R2, R2, #0			; R4 is the sign of the product
		ADD R2, R2, #1			; Sign of the product is 1
		AND R3, R3, #0 			; Stores the product of X and Y

		ST R0, saveX			; Stores X into R0
		ST R1, saveY			; Stores Y into R1

		ADD R0, R0 , #0
		BRzp negX
		NOT R5, R0			; two's comp. of X
		ADD R5, R5, #1
		NOT R3, R3			; R3 <- (-R3)
		ADD R3, R3, #1

negX 		ADD R1, R1, #0			; Negates X
		BRzp negY
		NOT R6, R1			; two's comp. of Y
		ADD R6, R6, #1
		NOT R3, R3			; R3 <- (-R3)
		ADD R3, R3, #1

negY 		ADD R1, R1, #0			; Negates Y

loopM 		ADD R1, R1, #0			; Multiplication loop
		BRz stop			; If zero go to "stop"
		ADD R3, R3, R0			; R2 <- R2 + X
		ADD R1, R1, #-1			; Decrements Y
		BR loopM

stop 		ADD R2, R2, #0			; If sign is positive
		BRp done			; go to "done"
		NOT R3, R3	
		ADD R3, R3, #1

done		LD R0, saveX			; Loads X 
		LD R1, saveY			; Loads Y
		RET

saveX 		.FILL x0			; Saves X
saveY 		.FILL x0			; Saves Y

DIVIDE 		AND R2, R2, #0			; Initializes quotient
		AND R3, R3, #0			; Initializes remainder
		AND R4, R4, #0			; Initializes valid
		AND R5, R5, #0			; Initializes temp

		ADD R0, R0 ,#0			; Go to "zero" 
		BRp zero			; if X is positive
		RET

zero 		ADD R1, R1, #0			; Go to "next"
		BRp next			; if Y is positive
		RET

next		ADD R4, R4, #1			; valid = 1
		ADD R5, R5, R0			; temp <- X
		NOT R1, R1			; two's comp. of X
		ADD R1, R1, #1

loopD		ADD R6, R5, R1			; R7 <- R6 + Y
		BRn done			; If negative go to "done"
		ADD R5, R5, R1			; temp - Y
		ADD R2, R2, #1			; quotient + 1
		ADD R3, R5, #0			; remainder <- temp
		BR loopD
		RET

MOD		STI R1, SAVE_R1			; Save registers
		STI R2, SAVE_R2			
		STI R3, SAVE_R3		
		STI R4, SAVE_R4			
		STI R5, SAVE_R5			

		AND R5, R5, #0
		ADD R1, R1, #0
		BRn X_NEG_3			; Change X to positive, if X is negative
		BR #3
X_NEG_3		NOT R1, R1
		ADD R1, R1, #1
		NOT R5, R5
		ADD R2, R2, #0
		BRn Y_NEG_3
		BR #3
Y_NEG_3		NOT R2, R2			; Change Y to positive, if Y is negative 
		ADD R2, R2, #1
		NOT R5, R5
		NOT R3, R2			; Initialize the decrement counter	
		ADD R3, R3, #1			
		ADD R4, R1, #0			; Initialize the modulus counter
MOD_REPEAT	ADD R1, R1, R3 		
		BRnz #2				; If R3 cannot go into R1 exit loop
		ADD R4, R4, R3			; else continue to calculate modulus
		BR MOD_REPEAT
		STI R4, X_MOD_Y
		LDI R1, SAVE_R1			; Restore registers
		LDI R2, SAVE_R2			
		LDI R3, SAVE_R3			
		LDI R4, SAVE_R4			
		LDI R5, SAVE_R5						
		RET

; Save and restore registers
SAVE_R1 	.FILL x3500
SAVE_R2 	.FILL x3501
SAVE_R3 	.FILL x3502
SAVE_R4 	.FILL x3503
SAVE_R5 	.FILL x3504
SAVE_R7 	.FILL x3505	

		.END