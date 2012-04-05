;******1/20/2012***************************
;First attempt to write a program to interface
;with an LCD using Assembly. Code uses PORTD
;and mucks with pin 0 and 1 so those pins
;couldnt be used unless this code is modified
;with some bitwise ops.
                                            
.def	tempVar1 = R17	
.def	tempVar2 = R18 
.def	registerSelect = R19	
.def	data = R21	
.def	delay1 = R22 
.def	delay2 = R23	
.def	delay3 = R24

	;**************************************
	;Initilization
	;**************************************
	
Init:

	;Delay 30 ms (16MHZ 1 ms = 16,000 ops, 30 ms 480,000 ops, / 5 = 96,000, HEX = 017700)
	ldi		delay1, 0x00
	ldi		delay2, 0x77
	ldi		delay3, 0x01
	call	DelayBy5Ops	
	
	ser	tempVar1		;Set all bits in register to 1
	out	DDRD, tempVar1	;Set PortB Data Direction Out
	
	call	Set8Bit		;Set 8-Bit Mode
	
	;Delay 4.5ms 72000 ops, / 5 = 14,400, HEX = 003840
	ldi 	delay1, 0x40
	ldi		delay2, 0x38
	ldi		delay3, 0x00
	call	DelayBy5Ops
	
	call	Set8Bit
	call	set8Bit
	call	set4Bit
	
	ldi		data, 0x20 | 0x08 	;Setup 2 Line Mode
	ldi		registerSelect, 0x00	;0x00 for Command, 0x08 For Data
	call	SendCommand	;Send Command to LCD

	ldi		data, 0x08 | 0x04 | 0x02 | 0x01
	ldi		registerSelect, 0x00
	call	sendCommand

	ldi		data, 0x01
	ldi		registerSelect, 0x00
	call	sendCommand

	;delay 2000 Microseconds
	;Delay 2ms 32000 ops, / 5 = 6,400, HEX = 001900
	ldi 	delay1, 0x00
	ldi		delay2, 0x19
	ldi		delay3, 0x00
	call	DelayBy5Ops
	
	ldi		data, 0x04 | 0x02 | 0x00
	ldi		registerSelect, 0x00
	call	SendCommand

	;**************************************
	;Start the Program
	;**************************************
	
start:

	ldi		registerSelect, 0x04
	ldi		data, 'H'
	call	SendCommand
	ldi		data, 'E'
	call	SendCommand
	ldi		data, 'L'
	call	SendCommand
	ldi		data, 'L'
	call	SendCommand
	ldi		data, 'O'
	call	SendCommand
	ldi		data, ' '
	call	SendCommand
	ldi		data, 'W'
	call	SendCommand
	ldi		data, 'O'
	call	SendCommand
	ldi		data, 'R'
	call	SendCommand
	ldi		data, 'L'
	call	SendCommand
	ldi		data, 'D'
	call	SendCommand

DoNothing:
	nop
	rjmp 	DoNothing


	;**************************************
	;Send Command
	;**************************************
SendCommand:
	;registerSelect and data must be set before using
	;this command
	;Send the High Nibble
	mov		tempVar1, registerSelect 	;Setup the Register Select Value		
	mov		tempVar2, data				;Copy 8-bit Data Variable
	
	andi	tempVar2, 0xF0				;Extract High Nibble, Clear Low Nibble of our Data Var
	or		tempVar1, tempVar2			;Set High Nibble with an Bitwise OR
	out		PORTD, tempVar1				;Send our Value to the port

	call	PulseEnable;				;Instruct LCD to read values
	
	;Send the Low Nibble
	mov		tempVar2, data				;Copy 8-bit Data Variable
	andi	tempVar2, 0x0F				;Extract Low Nibble, Clear High Nibble of our Data Var
	swap	tempVar2					;swap the nibble of our data var
	andi	tempVar1, 0x0F				;Clear High Nibble of our temp variable
	or		tempVar1, tempVar2			;Set High Nibble of our data variable, with low nibble
	out		PORTD, tempvar1				;Send value to port

	Call	PulseEnable;				;Instruct LCD to read values
	ret

	;**************************************
	;Set 8-BIT Mode
	;**************************************
Set8Bit:
	ldi		tempVar1, 0b00110000 	;Set 8Bit Mode
	out		PORTD, tempVar1			;Load into Port
	call	PulseEnable				;Send Data to LCD
	RET								;Return from Subroutine

	;**************************************
	;Set 4-BIT Mode
	;**************************************
Set4Bit:
	ldi		tempVar1, 0b00100000 	;Set 4Bit Mode
	out		PORTD, tempVar1			;Load into Port
	call	PulseEnable
	RET								;Return from Subroutine

	;***************************************	
	;Send Signal to LCD to Read Data Pins
	;***************************************
PulseEnable:
	cbi		PORTD, 3	;Clear Enable BIT
	
	;Delay 1 Microsecond
	;Delay 1us 16 ops, / 4 = 4, HEX = 000004
	ldi 	delay1, 0x04
	ldi		delay2, 0x00
	call	DelayBy4Ops
	
	sbi		PORTD, 3	;Set Enable BIT

	;Delay 1us 16 ops, / 4 = 4, HEX = 000004
	ldi 	delay1, 0x04
	ldi		delay2, 0x00
	call	DelayBy4Ops
	
	cbi		PORTD, 3	;Clear Enable BIT

	;Delay 100 Microseconds
	ldi 	delay1, 0x90
	ldi		delay2, 0x01
	call	DelayBy4Ops
	
	ret				;Return from subroutine
	
	;**************************************
	;Delays
	;**************************************	

	;Uses 3 Operations per LOOP, each subtraction is 1 and 2 for brcc
DelayBy3Ops:
	subi	delay1, 1		;Subtract 1 from the register
	brcc	delayBy3Ops		;Exit loop is SREG C is Set
	ret
	
	;Uses 4 Operations per LOOP, each subtraction is 1 and 2 for brcc
DelayBy4Ops:
	subi	Delay1, 1		;Subtract 1 from the register
	sbci	delay2, 0		;Subtract 1 if SREG C is Set
	brcc	DelayBy4Ops		;Exit loop is SREG C is Set
	ret
	
	;Uses 5 Operations per LOOP, each subtraction is 1 and 2 for brcc
DelayBy5Ops:
	subi	delay1, 1		;Subtract 1 from the register
	sbci	delay2, 0		;Subtract 1 if SREG C is Set
	sbci	delay3, 0		;Subtract 1 if SREG C is Set
	brcc	DelayBy5Ops		;Exit loop is SREG C is Set
	ret