;
; SRF01.asm
;
; Created: 2016-08-03 17:05:36
; Author : Mikael Glans
;




 //---------System Clock init----------------
  #define F_CPU 20000000 //

 //ldi r16, 0xFF
 //out OSCCAL, r16

/* ldi r16,(1<<CLKPS3)|(0<<CLKPS2)|(0<<CLKPS1)|(0<<CLKPS0)
 out CLKPR, r16 //prescaler 256*/
 //---------System Clock init----------------
 


  ldi r16, (1<<DDD3)
  out DDRD, r16
  
 
 rcall LCD

	//--------------Start of USART definitions and init--------------------
	//---------------------------------------------------------------------
	.def Count = r22
	.def ADRESS = r20
	.def DATA = r21
	.def rDATA = r23
	.def tDATA = r24
	.def dispDATA = r25


	/*Disable the Power Reduction USART bit, PRUSART0 by writing a logical zero to it*/
	ldi r16, (0<<PRUSART0)
	sts PRR, r16

	/*setting up for baud - - @ 20MHz fosc*/
	ldi r16, 0b00000000
	sts UBRR0H, r16
	ldi r16, 0b00000000
	sts UBRR0L, r16

		/* Setting the XCKn port pin as output, enables master mode. */
		/*DDRD |= (1<<DDD4);*/
		//ldi r16, (1<<DDD4)
		//sts DDRD, r16
	//UCSR0C = (0<<UMSEL01)|(1<<UMSEL00)|(1<<UDORD0)|(1<<UCPHA0)|(0<<UCPOL0);
	/*Asynchronous USART, no parity, 1 stop bit, 8 bit character size, UCPOL0=0 in asynchronous mode, only used in synchronous mode*/
	ldi r16, (0<<UMSEL01)|(0<<UMSEL00)|(0<<UPM01)|(0<<UPM00)|(0<<USBS0)|(1<<UCSZ01)|(1<<UCSZ00)|(0<<UCPOL0)
	sts UCSR0C, r16
	/* Enable receiver and transmitter. 8 bit character size*/
	//UCSR0B = (1<<RXEN0)|(1<<TXEN0);
	ldi r16, (1<<RXEN0)|(1<<TXEN0)|(0<<UCSZ02)
	sts UCSR0B, r16
	/*setting up for baud 9600 @ 20MHz fosc*/
	/* IMPORTANT: The Baud Rate must be set after the transmitter is enabled
	*/
	//UBRR0=832;
	//UBRR0H = 0b00000011;
	//UBRR0L = 0b01000000;
	ldi r16, 0b00000000
	sts UBRR0H, r16
	ldi r16, 0b10000001
	sts UBRR0L, r16
	/* Wait for empty transmit buffer */
	//while ( !( UCSR0A & (1<<UDRE0)) );
    //waitETB1:
	//lds r16,UCSR0A
	//sbrs r16,UDRE0
	//rjmp waitETB1
	/* Put data into buffer, sends the data */
	//UDR0 = '\\'; //Enter SCM
	//ldi r16, 0b00000000
	//sts UDR0, r16

	//--------------End of USART definitions and init----------------------
	//---------------------------------------------------------------------
	
	
	





	

 Main:

 

 ldi r16, 15 ;wait
	 rcall	WaitMiliseconds
rcall SRF01Break
	ldi r16, 15 ;wait
	rcall	WaitMiliseconds	
ldi r16, 0x01 //adress
mov tDATA, r16
rcall SRF01Transmit
	ldi r16, 15 ;wait
	 rcall	WaitMiliseconds
ldi r16, 0x62 //98, range down to zero (factory default)
mov tDATA, r16
rcall SRF01Transmit

	 ldi r16, 15 ;wait
	 rcall	WaitMiliseconds
rcall SRF01Break
	ldi r16, 15 ;wait
	rcall	WaitMiliseconds	
ldi r16, 0x01 //adress
mov tDATA, r16
rcall SRF01Transmit
	ldi r16, 15 ;wait
	 rcall	WaitMiliseconds
ldi r16, 0x51 //81, Real Ranging Mode - Result in centimeters
mov tDATA, r16
rcall SRF01Transmit
	 ldi r16, 150 ;wait at least 70 mS.
	 rcall	WaitMiliseconds
rcall SRF01Break	
	 ldi r16, 15 ;wait
	 rcall	WaitMiliseconds
ldi r16, 0x01 //adress
mov tDATA, r16
rcall SRF01Transmit
	 ldi r16, 15 ;wait
	 rcall	WaitMiliseconds
ldi r16, 0x5E //94, Get Range, returns two bytes (high byte first) from the most recent ranging.
mov tDATA, r16
rcall SRF01Transmit
	 ldi r16, 15 ;wait
	 rcall	WaitMiliseconds
rcall SRF01Receive
	ldi r16, 15 ;wait
	 rcall	WaitMiliseconds
;rcall SRF01Receive
	;ldi r16, 15 ;wait
	 ;rcall	WaitMiliseconds

rcall LCDwrite

	rjmp Main


 #include "wait.asm" ; AVR Assembler v.2
 ;------------------------------------------------------------------------------
; 1-wire definitions
;------------------------------------------------------------------------------
.equ	OW_PORT	= PORTD
.equ	OW_PIN	= PIND
.equ	OW_DDR	= DDRD
.equ	OW_DQ	= PD2

.def	OWCount = r17
;------------------------------------------------------------------------------
; 1-wire definitions
;------------------------------------------------------------------------------



.cseg

SRF01Break:
	/*setting up for baud 4800 @ 20MHz fosc*/
	/* IMPORTANT: The Baud Rate must be set after the transmitter is enabled
	*/
	
	ldi r16, 0b00000001
	sts UBRR0H, r16
	ldi r16, 0b00000011
	sts UBRR0L, r16

	/* Wait for empty transmit buffer */
	//while ( !( UCSR0A & (1<<UDRE0)) );
    waitETB_Break:
	lds r16,UCSR0A
	sbrs r16,UDRE0
	rjmp waitETB_Break
	/* Put data into buffer, sends the data */
	ldi r16, 0b00000000
	sts UDR0, r16
ret

SRF01Transmit:
	/*setting up for baud 9600 @ 20MHz fosc*/
	/* IMPORTANT: The Baud Rate must be set after the transmitter is enabled
	*/
	
	ldi r16, 0b00000000
	sts UBRR0H, r16
	ldi r16, 0b10000000
	sts UBRR0L, r16

	/* Wait for empty transmit buffer */
	//while ( !( UCSR0A & (1<<UDRE0)) );
    waitETB_Transmit:
	lds r16,UCSR0A
	sbrs r16,UDRE0
	rjmp waitETB_Transmit
	/* Put data into buffer, sends the data */
	mov r16, tDATA
	sts UDR0, r16
ret

SRF01Receive:
	/*setting up for baud 9600 @ 20MHz fosc*/
	/* IMPORTANT: The Baud Rate must be set after the transmitter is enabled
	*/
	
	//ldi r16, 0b00000000
	//sts UBRR0H, r16
	//ldi r16, 0b10000000
	//sts UBRR0L, r16

	; Wait for data to be received
	wait_Receive:
	lds r16, UCSR0A
	sbrs r16, RXC0
	rjmp wait_Receive
	; Get and return received data from buffer
	lds r16, UDR0
	mov rDATA, r16

	
	
ret

LCDwrite:
	ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A Clear Display
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds
	ldi r18, 0b01000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds
	ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds
	ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds
	ldi r18, 0b01000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds
	ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds

		

	ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds
	ldi r18, 0b11001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds
	ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds

		
		lsr rDATA
		lsr rDATA
		
	ldi r16, 0b10000000
	or r16, rDATA
	mov r18, r16 //format RS:E:D7:D6:D5:D4:N/A:N/A 
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds
	ldi r16, 0b11000000
	or r16, rDATA
	mov r18, r16 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds
	ldi r16, 0b10000000
	or r16, rDATA
	mov r18, r16 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 200
		rcall	WaitMiliseconds
ret



LCD:
	ldi r16, 200
	rcall	WaitMiliseconds

   //-----------------START OF LCD init-----------------
ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A Control Sequence 8-bit interface
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
	ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds



ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A Control Sequence 8-bit interface
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00001000 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01001000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00001000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds

ldi r18, 0b00001000 //format RS:E:D7:D6:D5:D4:N/A:N/A 4-bit Mode
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01001000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00001000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00100000 //format RS:E:D7:D6:D5:D4:N/A:N/A Function set: N:1 2 line, F:0 5x8
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01100000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00100000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds

ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A Display ON/OFF control
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00111100 //format RS:E:D7:D6:D5:D4:N/A:N/A D display on, C cursor on, B blinking on
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds

ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A Entry Mode
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00011000 //format RS:E:D7:D6:D5:D4:N/A:N/A I/D increament, S no display shift
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01011000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00011000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds

ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A Clear Display
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
//-----------------END OF LCD init-----------------


ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A Clear Display
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds


ret


;------------------------------------------------------------------------------
; Output : r16 - byte from slave
;------------------------------------------------------------------------------
DAC:

 //---------------------1-wire init Vcc powered device Overdrive Mode---------------
	rcall OWReset
	ldi r16, 0x3C     //Overdrive skip ROM
	rcall OWWriteByte
	ldi r16, 0xCC     //Write Conditional Search Register command
	rcall OWWriteByteOD
	ldi r16, 0x8D     //TA1 beginning adress
	rcall OWWriteByteOD
	ldi r16, 0x00     //TA2 adress 008Dh
	rcall OWWriteByteOD
	ldi r16, 0x81     //data byte adress 008Dh
	rcall OWWriteByteOD
	//---------------------1-wire init Vcc powered device Overdrive Mode---------------

	rcall OWResetOD
	ldi r16, 0x3C     //Overdrive skip ROM
	rcall OWWriteByteOD
	ldi r16, 0xF0     //Read PIO Registers command
	rcall OWWriteByteOD
	ldi r16, 0x8D     //TA1 beginning adress
	rcall OWWriteByteOD
	ldi r16, 0x00     //TA2 adress 008Dh
	rcall OWWriteByteOD
	rcall OWReadByteOD //Read Control/Status Register and verify

	rcall OWResetOD
	ldi r16, 0x3C     //Overdrive skip ROM
	rcall OWWriteByteOD
	ldi r16, 0x5A     //Channel-access Write command
	rcall OWWriteByteOD
	mov r16, r18     //Write byte to PIO
	rcall OWWriteByteOD
	mov r16, r18     //
	com r16           //
	//ldi r16, 0xFF     //Write inverted byte to PIO
	rcall OWWriteByteOD
	rcall OWReadByteOD //Read for verification (AAh = success)
	rcall OWReadByteOD //Read PIO pin status
	rcall OWResetOD
	
ret



;-------------------Overdrive Mode Start---------------------------------------
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Output : T - presence bit
;------------------------------------------------------------------------------
OWResetOD:
	cbi		OW_PORT,OW_DQ
	sbi		OW_DDR,OW_DQ

	ldi		XH, HIGH(DVUS(55))
	ldi		XL, LOW(DVUS(55))
	rcall	Wait4xCycles
	
	cbi		OW_DDR,OW_DQ

	ldi		XH, HIGH(DVUS(8))
	ldi		XL, LOW(DVUS(8))
	rcall	Wait4xCycles

	set
	sbis	OW_PIN,OW_DQ
	clt

	ldi		XH, HIGH(DVUS(48))
	ldi		XL, LOW(DVUS(48))
	rcall	Wait4xCycles

	ret
;------------------------------------------------------------------------------
; Input : C - bit to write
;------------------------------------------------------------------------------
OWWriteBitOD:
	brcc	OWWriteZeroOD
	ldi		XH, HIGH(DVUS(1))//Måste Kalibreras
	ldi		XL, LOW(DVUS(1))//Måste Kalibreras
	rjmp	OWWriteOneOD
OWWriteZeroOD:	
	ldi		XH, HIGH(DVUS(10)) 
	ldi		XL, LOW(DVUS(10)) 
OWWriteOneOD:
	sbi		OW_DDR, OW_DQ
	rcall	Wait4xCycles
	cbi		OW_DDR, OW_DQ
	
	ldi		XH, HIGH(DVUS(10))
	ldi		XL, LOW(DVUS(10))
	rcall	Wait4xCycles
	ret
;------------------------------------------------------------------------------
; Input : r16 - byte to write
;------------------------------------------------------------------------------
OWWriteByteOD:
	push	OWCount
	ldi		OWCount,0
OWWriteLoopOD:	
	ror		r16
	rcall	OWWriteBitOD	
	inc		OWCount
	cpi		OWCount,8
	brne	OWWriteLoopOD
	pop		OWCount		
	ret
;------------------------------------------------------------------------------
; Output : C - bit from slave
;------------------------------------------------------------------------------
OWReadBitOD:
	ldi		XH, HIGH(DVUS(1)) //Måste kalibreras
	ldi		XL, LOW(DVUS(1)) //Måste kalibreras
	sbi		OW_DDR, OW_DQ
	rcall	Wait4xCycles
	cbi		OW_DDR, OW_DQ
	ldi		XH, HIGH(DVUS(1)) //1.5 kohm optimal pull-up. Kalibrera så att sampling inte sker försent, 1us-2us tRD - READ VALID, pga oexakta tider, oscilloskop!
	ldi		XL, LOW(DVUS(1)) //1.5 kohm optimal pull-up. Kalibrera så att sampling inte sker försent,  1us-2us tRD - READ VALID, pga oexakta tider, oscilloskop!
	rcall	Wait4xCycles
	clt
	sbic	OW_PIN,OW_DQ
	set
	ldi		XH, HIGH(DVUS(10))
	ldi		XL, LOW(DVUS(10))
	rcall	Wait4xCycles
	sec
	brts	OWReadBitEndOD
	clc
OWReadBitEndOD:
	ret
;------------------------------------------------------------------------------
; Output : r16 - byte from slave
;------------------------------------------------------------------------------
OWReadByteOD:
	push	OWCount
	ldi		OWCount,0
OWReadLoopOD:
	rcall	OWReadBitOD
	ror		r16
	inc		OWCount
	cpi		OWCount,8
	brne	OWReadLoopOD
	pop		OWCount
	ret
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------



;-------------------Overdrive Mode End-----------------------------------------
;------------------------------------------------------------------------------


;-------------------Standard Mode Start-----------------------------------------
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Output : T - presence bit
;------------------------------------------------------------------------------
OWReset:
	cbi		OW_PORT,OW_DQ
	sbi		OW_DDR,OW_DQ

	ldi		XH, HIGH(DVUS(470))
	ldi		XL, LOW(DVUS(470))
	rcall	Wait4xCycles
	
	cbi		OW_DDR,OW_DQ

	ldi		XH, HIGH(DVUS(70))
	ldi		XL, LOW(DVUS(70))
	rcall	Wait4xCycles

	set
	sbis	OW_PIN,OW_DQ
	clt

	ldi		XH, HIGH(DVUS(240))
	ldi		XL, LOW(DVUS(240))
	rcall	Wait4xCycles

	ret
;------------------------------------------------------------------------------
; Input : C - bit to write
;------------------------------------------------------------------------------
OWWriteBit:
	brcc	OWWriteZero
	ldi		XH, HIGH(DVUS(1))
	ldi		XL, LOW(DVUS(1))
	rjmp	OWWriteOne
OWWriteZero:	
	ldi		XH, HIGH(DVUS(70)) //Changed from 120
	ldi		XL, LOW(DVUS(70)) //Changed from 120
OWWriteOne:
	sbi		OW_DDR, OW_DQ
	rcall	Wait4xCycles
	cbi		OW_DDR, OW_DQ
	
	ldi		XH, HIGH(DVUS(60))
	ldi		XL, LOW(DVUS(60))
	rcall	Wait4xCycles
	ret
;------------------------------------------------------------------------------
; Input : r16 - byte to write
;------------------------------------------------------------------------------
OWWriteByte:
	push	OWCount
	ldi		OWCount,0
OWWriteLoop:	
	ror		r16
	rcall	OWWriteBit	
	inc		OWCount
	cpi		OWCount,8
	brne	OWWriteLoop
	pop		OWCount		
	ret
;------------------------------------------------------------------------------
; Output : C - bit from slave
;------------------------------------------------------------------------------
OWReadBit:
	ldi		XH, HIGH(DVUS(1))
	ldi		XL, LOW(DVUS(1))
	sbi		OW_DDR, OW_DQ
	rcall	Wait4xCycles
	cbi		OW_DDR, OW_DQ
	ldi		XH, HIGH(DVUS(8)) //Kolla så att sampling inte sker försent, max 15us tRD - READ VALID, pga oexakta tider, oscilloskop!
	ldi		XL, LOW(DVUS(8)) //Kolla så att sampling inte sker försent, max 15us tRD - READ VALID, pga oexakta tider, oscilloskop!
	rcall	Wait4xCycles
	clt
	sbic	OW_PIN,OW_DQ
	set
	ldi		XH, HIGH(DVUS(50))
	ldi		XL, LOW(DVUS(50))
	rcall	Wait4xCycles
	sec
	brts	OWReadBitEnd
	clc
OWReadBitEnd:
	ret
;------------------------------------------------------------------------------
; Output : r16 - byte from slave
;------------------------------------------------------------------------------
OWReadByte:
	push	OWCount
	ldi		OWCount,0
OWReadLoop:
	rcall	OWReadBit
	ror		r16
	inc		OWCount
	cpi		OWCount,8
	brne	OWReadLoop
	pop		OWCount
	ret
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------

;-------------------Standard Mode End------------------------------------------
;------------------------------------------------------------------------------


