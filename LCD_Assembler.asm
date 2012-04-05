/*
 * LCD_Assembler.asm
 *
 *  Created: 1/13/2012 3:50:13 PM
 *   Author: Nick
 */ 

 .list

;=============
;Declarations:

.def	temp	=	r16
.def	Delay1	=	r17
.def	Delay2	=	r18
.def	Delay3	=	r19

;=============
;Start of Program

		rjmp	3		;first line executed
		ser		R18

;=============
Init:	ser		temp		;Set Register to 0xFF
		out		DDRB, temp	;Set data direction as output
		clr		temp		;Set temp to 0x00
		out		PortB, temp	;Set Port B to 0x00 (LED OFF)
		out		PortB, R17
		out		PortB, R18
		out		PortB, R19
		out		TIFR2, R1

;=============
Start:
		sbi		PortB, 0	;Sets bit 0 of PortB high DIGITAL PIN8
		rcall	Delay
		cbi		PortB, 0
		rcall	Delay
		rjmp	Start

Delay:
		ldi		Delay1, 0x00
		ldi		Delay2, 0xD4
		ldi		Delay3, 0x30

Loop:
		subi	Delay1, 1
		sbci	Delay2, 0
		sbci	Delay3, 0
		brcc	Loop
		ret