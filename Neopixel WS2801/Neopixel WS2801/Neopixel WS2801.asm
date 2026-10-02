;
; Neopixel WS2801.asm
;
; Created: 2016-05-25 23:33:00
; Author : Mikael Glans
;


//---------System Clock init----------------
  #define F_CPU 20000000
 //---------System Clock init----------------
 

//-------------------SPI init------------------------------------------------------------------------------
 ldi r16, (1<<DDB2)|(1<<DDB3)|(1<<DDB5) ;PB2 |SS [16], PB3 MOSI [17], PB5 SCK [19]
  out DDRB, r16 ;

  

  ldi r16, (0<<PRSPI)
  sts PRR, r16 //Power Reduction Serial Peripheral Interface bit disabled

  ; Enable SPI, MSB first, sample (rising) setup (falling), Master, set clock rate fck/2
ldi r16, (0<<SPIE)|(1<<SPE)|(0<<DORD)|(1<<CPOL)|(1<<CPHA)|(1<<MSTR)|(0<<SPR1)|(0<<SPR0)
out SPCR,r16
  ; Double SPI Speed Bit set
ldi r16, (1<<SPI2X)
out SPSR,r16


 //------------------SPI init-------------------------------------------------------------------------------
 Startup:
			
		ldi r21, 0b00000000 //green
		out SPDR,r21
		Wait_Transmit0:
		; Wait for transmission complete
		in r21, SPSR
		sbrs r21, SPIF
		rjmp Wait_Transmit0


		ldi r21, 0b11111111 //blue
		out SPDR,r21
		Wait_Transmit1:
		; Wait for transmission complete
		in r21, SPSR
		sbrs r21, SPIF
		rjmp Wait_Transmit1	

		ldi r21, 0b11111111 //red
		out SPDR,r21
		Wait_Transmit2:
		; Wait for transmission complete
		in r21, SPSR
		sbrs r21, SPIF
		rjmp Wait_Transmit2	


			ldi r16, 200
			rcall WaitMiliseconds
			ldi r16, 200
			rcall WaitMiliseconds
			ldi r16, 200
			rcall WaitMiliseconds
			ldi r16, 200
			rcall WaitMiliseconds
			ldi r16, 200
			rcall WaitMiliseconds

; Replace with your application code
start:
    //inc r16
	
	
	rcall DS18B20
	
	cpi r16, 0b00000100
	brcc sendred

	cpi r16, 0b00000010
	brcc sendgreen

	cpi r16, 0b00000001
	brcc sendblue
	


		sendred:
			ldi r21, 0b00000000 //green
			out SPDR,r21
			Wait_Transmit3:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit3


			ldi r21, 0b00000000 //blue
			out SPDR,r21
			Wait_Transmit4:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit4	

			ldi r21, 0b11111111 //red
			out SPDR,r21
			Wait_Transmit5:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit5	
		rjmp start


		sendgreen:
			ldi r21, 0b11111111 //green
			out SPDR,r21
			Wait_Transmit6:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit6


			ldi r21, 0b00000000 //blue
			out SPDR,r21
			Wait_Transmit7:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit7	

			ldi r21, 0b00000000 //red
			out SPDR,r21
			Wait_Transmit8:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit8	
		rjmp start


		sendblue:
			ldi r21, 0b00000000 //green
			out SPDR,r21
			Wait_Transmit9:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit9


			ldi r21, 0b11111111 //blue
			out SPDR,r21
			Wait_Transmit10:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit10	

			ldi r21, 0b00000000 //red
			out SPDR,r21
			Wait_Transmit11:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit11	
		rjmp start

    rjmp start


#include "wait.asm" ; AVR Assembler v.2	
 


;------------------------------------------------------------------------------
; 1-wire definitions DS18B20
;------------------------------------------------------------------------------
.equ	OW_PORT_DS18B20	= PORTD
.equ	OW_PIN_DS18B20	= PIND
.equ	OW_DDR_DS18B20	= DDRD
.equ	OW_DQ_DS18B20	= PD2

.def	OWCount = r17
;------------------------------------------------------------------------------
; 1-wire definitions DS18B20
;------------------------------------------------------------------------------

DS18B20:
rcall OWResetDS18B20
ldi r16, 0xCC ;skip ROM
rcall OWWriteByteDS18B20
ldi r16, 0x4E ;Write Scratchpad
rcall OWWriteByteDS18B20
	ldi r16, 0b00000111 ;TH +125*C
	rcall OWWriteByteDS18B20
	ldi r16, 0b11111100 ;TL -55*C
	rcall OWWriteByteDS18B20
	ldi r16, 0b00011111 ; Configuration register: R1=0, R0=0 9 bit resolution, 93,75 ms conv.
	rcall OWWriteByteDS18B20

rcall OWResetDS18B20
ldi r16, 0xCC ;skip ROM
rcall OWWriteByteDS18B20
ldi r16, 0x44 ;Convert T
rcall OWWriteByteDS18B20
ldi r16, 100 ;OBS with 9-bit res!
rcall WaitMiliseconds

rcall OWResetDS18B20
ldi r16, 0xCC ;skip ROM
rcall OWWriteByteDS18B20
ldi r16, 0xBE ;Read Scratchpad
rcall OWWriteByteDS18B20
rcall OWReadByteDS18B20
rcall OWReadByteDS18B20
;mov r18, r16
rcall OWResetDS18B20
ret

;-------------------Standard Mode Start DS18B20-----------------------------------------
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Output : T - presence bit
;------------------------------------------------------------------------------
OWResetDS18B20:
	cbi		OW_PORT_DS18B20, OW_DQ_DS18B20
	sbi		OW_DDR_DS18B20, OW_DQ_DS18B20

	ldi		XH, HIGH(DVUS(480))
	ldi		XL, LOW(DVUS(480))
	rcall	Wait4xCycles
	
	cbi		OW_DDR_DS18B20, OW_DQ_DS18B20

	ldi		XH, HIGH(DVUS(70))
	ldi		XL, LOW(DVUS(70))
	rcall	Wait4xCycles

	set
	sbis	OW_PIN_DS18B20, OW_DQ_DS18B20
	clt

	ldi		XH, HIGH(DVUS(410))
	ldi		XL, LOW(DVUS(410))
	rcall	Wait4xCycles

	ret
;------------------------------------------------------------------------------
; Input : C - bit to write
;------------------------------------------------------------------------------
OWWriteBitDS18B20:
	brcc	OWWriteZeroDS18B20
	ldi		XH, HIGH(DVUS(1))
	ldi		XL, LOW(DVUS(1))
	rjmp	OWWriteOneDS18B20
OWWriteZeroDS18B20:	
	ldi		XH, HIGH(DVUS(70)) //Changed from 120
	ldi		XL, LOW(DVUS(70)) //Changed from 120
OWWriteOneDS18B20:
	sbi		OW_DDR_DS18B20, OW_DQ_DS18B20
	rcall	Wait4xCycles
	cbi		OW_DDR_DS18B20, OW_DQ_DS18B20
	
	ldi		XH, HIGH(DVUS(60))
	ldi		XL, LOW(DVUS(60))
	rcall	Wait4xCycles
	ret
;------------------------------------------------------------------------------
; Input : r16 - byte to write
;------------------------------------------------------------------------------
OWWriteByteDS18B20:
	push	OWCount
	ldi		OWCount,0
OWWriteLoopDS18B20:	
	ror		r16
	rcall	OWWriteBitDS18B20	
	inc		OWCount
	cpi		OWCount,8
	brne	OWWriteLoopDS18B20
	pop		OWCount		
	ret
;------------------------------------------------------------------------------
; Output : C - bit from slave
;------------------------------------------------------------------------------
OWReadBitDS18B20:
	ldi		XH, HIGH(DVUS(1))
	ldi		XL, LOW(DVUS(1))
	sbi		OW_DDR_DS18B20, OW_DQ_DS18B20
	rcall	Wait4xCycles
	cbi		OW_DDR_DS18B20, OW_DQ_DS18B20
	ldi		XH, HIGH(DVUS(5)) //Kolla så att sampling inte sker för tidigt, max 15us tRD - READ VALID, pga oexakta tider, oscilloskop!
	ldi		XL, LOW(DVUS(5)) //Kolla så att sampling inte sker för tidigt, max 15us tRD - READ VALID, pga oexakta tider, oscilloskop!
	rcall	Wait4xCycles
	clt
	sbic	OW_PIN_DS18B20, OW_DQ_DS18B20
	set
	ldi		XH, HIGH(DVUS(55))
	ldi		XL, LOW(DVUS(55))
	rcall	Wait4xCycles
	sec
	brts	OWReadBitEndDS18B20
	clc
OWReadBitEndDS18B20:
	ret
;------------------------------------------------------------------------------
; Output : r16 - byte from slave
;------------------------------------------------------------------------------
OWReadByteDS18B20:
	push	OWCount
	ldi		OWCount,0
OWReadLoopDS18B20:
	rcall	OWReadBitDS18B20
	ror		r16
	inc		OWCount
	cpi		OWCount,8
	brne	OWReadLoopDS18B20
	pop		OWCount
	ret
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------

;-------------------Standard Mode End DS18B20------------------------------------------
;------------------------------------------------------------------------------