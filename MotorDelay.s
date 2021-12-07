;*************************************************************** 
; This code is to delay one the motor gets to the spot where the record is
;If this was an actual jukebox, this would give the machine time to grab the record
;and place it on the turntable
;***************************************************************	

;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
DELAY_CLOCKS		EQU				6000000 ;Delay time before the motor steps down
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
			AREA    	MotorDelay, READONLY, CODE
			THUMB
			EXPORT  	__MotorDelay	; Make available
			
				
__MotorDelay
;From the lecture slides
			B		DelayTime

;******************************************
; Subroutine to create delay, 
; DELAY_CLOCKS is the counter which is 
; decremented to zero
;******************************************	
DelayTime	LDR	R2,=DELAY_CLOCKS	; set delay count
del		SUBS 	R2, R2, #1		; decrement count
		BNE	del		; if not at zero, do again
		BX	LR			; return when done

;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE	VALUE			COMMENT
			ALIGN
			END
