/*
 * DS2450S_Ljussensor.asm
 *
 *  Created: 2014-12-27 18:13:23
 *   Author: Mikael
 */ 
 #define F_CPU 6400000

 ldi r16, 0xFF
 out OSCCAL, r16

 ldi r16,(1<<CLKPS3)|(0<<CLKPS2)|(0<<CLKPS1)|(0<<CLKPS0)
 out CLKPR, r16 //prescaler 256

 ldi r17,(1<<PB2)|(1<<PB1)|(0<<PB0) 
 out DDRB, r17 //USI init

 Main:

 
    //---------------------1-wire init Vcc powered device---------------
	rcall OWReset
	ldi r16, 0xCC     //skip ROM
	rcall OWWriteByte
	ldi r16, 0x55     //Write Memory Command
	rcall OWWriteByte
	ldi r16, 0x1C     //TA1 beginning adress
	rcall OWWriteByte
	ldi r16, 0x00     //TA2 adress 001Ch
	rcall OWWriteByte
	ldi r16, 0x40     //data byte adress 001Ch
	rcall OWWriteByte
	rcall OWReadByte
	rcall OWReadByte //16- bit CRC

	ldi r16, 1
	rcall WaitMiliseconds // 1 ms delay, this proofs you are the one who 
						//control then you want to read time slots! (You don´t need to hurry to read them!)

	rcall OWReadByte //read-back for simple verification
	//---------------------1-wire init Vcc powered device---------------
	

	rcall OWReset
	ldi r16, 0xCC     //skip ROM
	rcall OWWriteByte
	ldi r16, 0x55     //Write Memory Command
	rcall OWWriteByte
	ldi r16, 0x08     //TA1 beginning adress
	rcall OWWriteByte
	ldi r16, 0x00     //TA2 adress 0008h
	rcall OWWriteByte

	//---------------------CH A------------------------------
	ldi r16, 0x0C     //data byte adress 0008h
	rcall OWWriteByte
	rcall OWReadByte
	rcall OWReadByte //16- bit CRC
	rcall OWReadByte //read-back for simple verification
	ldi r16, 0x01     //data byte adress 0009h
	rcall OWWriteByte
	rcall OWReadByte
	rcall OWReadByte //16- bit CRC
	rcall OWReadByte //read-back for simple verification
	//---------------------CH A------------------------------

	//---------------------CH B------------------------------
	ldi r16, 0xC0     //data byte adress 000Ah
	rcall OWWriteByte
	rcall OWReadByte
	rcall OWReadByte //16- bit CRC
	rcall OWReadByte //read-back for simple verification
	ldi r16, 0x00     //data byte adress 000Bh
	rcall OWWriteByte
	rcall OWReadByte
	rcall OWReadByte //16- bit CRC
	rcall OWReadByte //read-back for simple verification
	//---------------------CH B------------------------------

	//---------------------CH C------------------------------
	ldi r16, 0xC0     //data byte adress 000Ch
	rcall OWWriteByte
	rcall OWReadByte
	rcall OWReadByte //16- bit CRC
	rcall OWReadByte //read-back for simple verification
	ldi r16, 0x00     //data byte adress 000Dh
	rcall OWWriteByte
	rcall OWReadByte
	rcall OWReadByte //16- bit CRC
	rcall OWReadByte //read-back for simple verification
	//---------------------CH C------------------------------

	//---------------------CH D------------------------------
	ldi r16, 0xC0     //data byte adress 000Eh
	rcall OWWriteByte
	rcall OWReadByte
	rcall OWReadByte //16- bit CRC
	rcall OWReadByte //read-back for simple verification
	ldi r16, 0x00     //data byte adress 000Fh
	rcall OWWriteByte
	rcall OWReadByte
	rcall OWReadByte //16- bit CRC
	rcall OWReadByte //read-back for simple verification
	//---------------------CH D------------------------------
	

	rcall OWReset
	ldi r16, 0xCC     //skip ROM
	rcall OWWriteByte
	ldi r16, 0x3C     //Convert Command
	rcall OWWriteByte
	ldi r16, 0x01     //input select mask, ch A
	rcall OWWriteByte
	ldi r16, 0x01     //read out control, preset to all 0´s
	rcall OWWriteByte
	rcall OWReadByte
	rcall OWReadByte //16- bit CRC
	ldi r16, 4
	rcall WaitMiliseconds // 4 ms delay
	

	rcall OWReset
	ldi r16, 0xCC     //skip ROM
	rcall OWWriteByte
	ldi r16, 0xAA     //Read Memory Command
	rcall OWWriteByte
	ldi r16, 0x01     //TA1, beginning adress
	rcall OWWriteByte
	ldi r16, 0x00     //TA2, adress 0001h [high byte ch A]
	rcall OWWriteByte
	rcall OWReadByte // status data

	mov r18, r16
	rcall SPITransfer_Fast
	//rcall OWWriteByte //Writing what´s read
	
	/*rcall OWReadByte
	rcall OWReadByte //16- bit CRC*/
	

	
	
rjmp Main

 #include "wait.asm" ; AVR Assembler v.2
 ;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
.equ	OW_PORT	= PORTB
.equ	OW_PIN	= PINB
.equ	OW_DDR	= DDRB
.equ	OW_DQ	= PB4

.def	OWCount = r17
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
.cseg



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
	ldi		XH, HIGH(DVUS(5)) //Kolla så att sampling inte sker försent, max 15us tRD - READ VALID, pga oexakta tider, oscilloskop!
	ldi		XL, LOW(DVUS(5)) //Kolla så att sampling inte sker försent, max 15us tRD - READ VALID, pga oexakta tider, oscilloskop!
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


SPITransfer_Fast:

ldi r16, 0x00
out USIDR,r18
ldi r16,(1<<USIWM0)|(0<<USICS0)|(1<<USITC)
ldi r17,(1<<USIWM0)|(0<<USICS0)|(1<<USITC)|(1<<USICLK)
out USICR,r16 ; MSB
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16 ; LSB
out USICR,r17
in r16,USIDR

ldi r16, 0x00
out USIDR,r18
ldi r16,(1<<USIWM0)|(0<<USICS0)|(1<<USITC)
ldi r17,(1<<USIWM0)|(0<<USICS0)|(1<<USITC)|(1<<USICLK)
out USICR,r16 ; MSB
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16 ; LSB
out USICR,r17
in r16,USIDR

ldi r16, 0x00
out USIDR,r16
ldi r16,(1<<USIWM0)|(0<<USICS0)|(1<<USITC)
ldi r17,(1<<USIWM0)|(0<<USICS0)|(1<<USITC)|(1<<USICLK)
out USICR,r16 ; MSB
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16
out USICR,r17
out USICR,r16 ; LSB
out USICR,r17
in r16,USIDR

ret