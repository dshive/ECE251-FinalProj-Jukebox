;*************************************************************** 
; Only edit this document if you first change the MotorDrive.s file  
;***************************************************************	

;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
GPIO_PORTF_BASE 	EQU 			0x40025000 
GPIO_PORTF_DATA 	EQU 			0x400253FC 		;Port F data address
GPIO_PORTF_DIR 		EQU 			0x40025400
GPIO_PORTF_AFSEL 	EQU 			0x40025420
GPIO_PORTF_DEN 		EQU 			0x4002551C
SYSCTL_RCGCGPIO 	EQU 			0x400FE608
PORTF_LOCK_R 		EQU 			0x40025520 ; Port F Lock Register
Lock_Key 			EQU 			0x4C4F434B ; Unlock code for all Lock Registers
GPIO_PORTF_CR_R 	EQU 			0x40025524 ; 
GPIO_PORTF_DIR_R 	EQU 			0x40025400 ; Direction Register, Port F
GPIO_PORTF_AFSEL_R 	EQU 			0x40025420 ; Alternate Function Register, Pt F
GPIO_PORTF_DEN_R 	EQU 			0x4002551C ; Digital Enable Register, Port F
PFdata 				EQU 			0x400253FC ; Port F Data address 
GPIO_PORTF_PUR_R 	EQU 			0x40025510
DELAY_CLOCKS		EQU				1500000
;***************************************************************
; Data Section in READWRITE
; Values of the data in this section are not properly initialazed, 
; but labels can be used in the program to change the data values.
;***************************************************************
;LABEL          DIRECTIVE       VALUE                           COMMENT
				
;                AREA            |.sdata|, DATA, READWRITE
;                THUMB			
								
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************
;LABEL          DIRECTIVE       VALUE                           COMMENT
;                AREA            |.data|, DATA, READONLY
;                THUMB

;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA    	MotorDown, READONLY, CODE
			THUMB
			EXPORT  	__MotorDown		; Make available
			
				
__MotorDown
;From the lecture slides
			LDR R1,=SYSCTL_RCGCGPIO ; load R1 with RCGCGPIO address
			LDR R0, [R1] 			; load R0 with value in RCGCGPIO
			ORR R0, #2_100000 		; set bit 5 to turn on Port F clock. Why 5?
			STR R0, [R1] 			; store value in RCGCGPIO
			NOP 					; three non-GPIO instruction times
			NOP						; needed to allow
			NOP 					; time for clock to finish
;Port F is now running

;All this does is enable Pin 0 of Port F:
; Unlock Port F
			LDR R1, =PORTF_LOCK_R ; load R1 with PORTF_LOCK_R address
			LDR R0, =Lock_Key ; load R0 with lock key
			STR R0, [R1] ; store key in PORTF_LOCK_R
			LDR R1, =GPIO_PORTF_CR_R ; enable commit for Port F
			MOV R0, #0xFF ; 1 means allow access
			STR R0, [R1]
;GPIO Port F is now unlocked.

;***********************************************************************
;Initialization of Port F: Disable analog functionality, Disable
;alternate function, Set direction register.
;***********************************************************************
			LDR R1, =GPIO_PORTF_DIR_R ; Data direction setup
			LDR R0, [R1]
			BIC R0, #0xFF
			ORR R0, #2_011110 ; Set bits 1,2,3,4 as output; 0 as input
			STR R0, [R1]
			LDR R1, =GPIO_PORTF_AFSEL_R ; Set up standard GPIO functionality
			LDR R0, [R1] ; rather than some special use (A/D...)
			BIC R0, #0xFF
			STR R0, [R1]
			LDR R1, =GPIO_PORTF_DEN_R ; Enable digital (vs. Analog) function
			LDR R0, [R1]
			ORR R0, #0xFF
			STR R0, [R1] 
			
;*************************************************************************
;Set up pull up resistors
;*************************************************************************
			LDR r0, =GPIO_PORTF_PUR_R
			MOV r1, #2_00011110 ; Pull up resistors have a 1 so at 0 and 4
			STR r1, [r0]

;*************************************************************************			
;Code to work the LEDS
;*************************************************************************

;This is the same code, but it is reversed, so that the motor steps in reverse	
Loop_DM		PUSH		{LR}
			BL			Delay
			BL			Step4
			BL			Delay
			BL			Step3
			BL			Delay
			BL			Step2
			BL			Delay
			BL			Step
			BL			Delay
			POP			{PC}
			
			
Step		LDR			R1, =GPIO_PORTF_DATA
			MOV			R0, #0x10
			STR 		R0, [R1]
			BX			LR

Step2		
			LDR			R1, =GPIO_PORTF_DATA
			MOV			R0, #0x08
			STR 		R0, [R1]
			BX			LR
			
Step3		
			LDR			R1, =GPIO_PORTF_DATA
			MOV			R0, #0x04
			STR 		R0, [R1]
			BX			LR
			
			
Step4	
			LDR			R1, =GPIO_PORTF_DATA
			MOV			R0, #0x02
			STR 		R0, [R1]
			BX			LR
			


;******************************************
; Subroutine to create delay, 
; DELAY_CLOCKS is the counter which is 
; decremented to zero
;******************************************	
Delay	LDR	R2,=DELAY_CLOCKS	; set delay count
del		SUBS 	R2, R2, #1		; decrement count
		BNE	del		; if not at zero, do again
		BX	LR			; return when done

;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE	VALUE			COMMENT
			ALIGN
			END
