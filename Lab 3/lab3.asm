; Class: CSE 313 Machine Organization Lab
; Section: 04
; Instructor: Taline Georgiou
; Term: Fall 2018
; Name(s): Christian Mesina and Jared Acosta
; Lab #3: Days of the Week
; Description: This LC3 Program lets the user enter a numer from 0-6
; 	       which then inputs the "Days of the Week". If the user
;	       enters 0, it wil input "Sunday". 1 for "Monday", 2
;	       for "Tuesday", 3 for "Wednesday", 4 for "Thursday",
; 	       5 for "Friday", and 6 for "Saturday". If the user
;	       enters a number other than 0-6, then the program
; 	       terminates. For this program, we used the TRAP 
;	       instructions to make the program faster and efficient.
;	       For the results, they told us to input 0,1,4,6 to
;	       test if the program is really working and readable.

	.ORIG x3000
RESTART	LEA R0, PROMPT		; R0 <- Loads the Days of the Week
	PUTS	
	GETC			; R0 <- ASCII value of character
	
	ADD R3, R0, x0		; R3 <- R0
	ADD R3, R3, #-16	; Subtract 48, the ASCII value of 0
	ADD R3, R3, #-16
	ADD R3, R3, #-16	; R3 now contains the actual value
	
	LEA R0, DAYS		; R0 <- Address of "Sunday"
	ADD R3, R3, x0		; R0 <- R0 + 10 * i	

LOOP	BRz DISPLAY
	ADD R0, R0, #10		; Go to next day
	ADD R3, R3, #-1		; Decrement loop variable
	BR LOOP

DISPLAY	PUTS
	LEA R0, NL		; Prints a new line
	PUTS
	BR RESTART
	
INVALID	HALT
	
PROMPT	.STRINGZ "Please enter a number: "
DAYS	.STRINGZ "Sunday   "
	.STRINGZ "Monday   "
	.STRINGZ "Tuesday  "
	.STRINGZ "Wednesday"
	.STRINGZ "Thursday "
	.STRINGZ "Friday   "
	.STRINGZ "Saturday "

NL	.FILL x00A		; Executes and Stores the new line
	.END