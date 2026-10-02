/*
 * NOKIA6100.asm
 *
 *  Created: 2015-10-01 18:12:17
 *   Author: Mikael
 */ 




 //---------System Clock init----------------
  #define F_CPU 20000000

 //ldi r16, 0xFF
 //out OSCCAL, r16

/* ldi r16,(1<<CLKPS3)|(0<<CLKPS2)|(0<<CLKPS1)|(0<<CLKPS0)
 out CLKPR, r16 //prescaler 256*/
 //---------System Clock init----------------

 .def	rami1 = r22
 ldi rami1, 0x00
 .def	rami2 = r23
 ldi rami2, 0x00

 
 //-------------------SPI init------------------------------------------------------------------------------
  ldi r16, (1<<DDC2)|(1<<DDC0) ;PC2 CS [25], PC0 RESET [23]
  out DDRC, r16
  ldi r16, (1<<DDB2)|(1<<DDB3)|(1<<DDB5) ;PB2 |SS [16], PB3 MOSI [17], PB5 SCK [19]
  out DDRB, r16 ;

  ldi r16, (0<<PB5)|(0<<PB3) ;SCK and MOSI (DATA) is low to begin with
  out PORTB, r16

  ldi r16, (0<<PRSPI)
  sts PRR, r16 //Power Reduction Serial Peripheral Interface bit disabled

  ; Disable SPI, MSB first, sample (rising) setup (falling), Master, set clock rate fck/128
ldi r16, (0<<SPIE)|(0<<SPE)|(0<<DORD)|(0<<CPOL)|(0<<CPHA)|(1<<MSTR)|(1<<SPR1)|(1<<SPR0)
out SPCR,r16
  ; Double SPI Speed Bit not set
ldi r16, (0<<SPI2X)
out SPSR,r16
//------------------SPI init-------------------------------------------------------------------------------
 
 sbi PORTC, LCD_CS // disable device CS on NOKIA6100
 
 rcall LCD
 rcall NOKIA_LCD_init
 /*
 cbi PORTC, LCD_CS // enable device CS
	
	
	ldi r20, 0b00000000 //command
	ldi r21, 0x75 //PASET
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x04 //
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x80 //
	rcall SendLcd

	
	ldi r20, 0b00000000 //command
	ldi r21, 0x15 //CASET
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x04 //
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x80 //
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0x5C //RAMWR
	rcall SendLcd
	loop:
	ldi r20, 0b11111111 //data
	ldi r21, 0xff //
	rcall SendLcd
	inc rami
	cpi		rami,0xFF
	brne	loop
	
 
	
	sbi PORTC, LCD_CS // disable device CS
	*/
 Main:




 

	rjmp Main


 #include "wait.asm" ; AVR Assembler v.2
 ;------------------------------------------------------------------------------
; 1-wire definitions
;------------------------------------------------------------------------------
.equ	OW_PORT	= PORTD
.equ	OW_PIN	= PIND
.equ	OW_DDR	= DDRD
.equ	OW_DQ	= PD1

.def	OWCount = r17
;------------------------------------------------------------------------------
; 1-wire definitions
;------------------------------------------------------------------------------

 ;------------------------------------------------------------------------------
; NOKIA6100 definitions
;------------------------------------------------------------------------------
.equ LCD_CS = PC2 
//.equ LCD_CLK = PB7 
.equ LCD_DATA = PB3 
.equ LCD_RESET = PC0
.equ SPI_PORT = PORTB
.equ SPI_SCK = PB5
 ;------------------------------------------------------------------------------
; NOKIA6100 definitions
;------------------------------------------------------------------------------

.cseg


NOKIA_LCD_init:

sbi PORTC, LCD_CS // disable device CS

		cbi PORTC, LCD_RESET
	ldi r16, 200
	rcall	WaitMiliseconds
		sbi PORTC, LCD_RESET
	ldi r16, 200
	rcall	WaitMiliseconds
	
cbi PORTC, LCD_CS // enable device CS
	ldi		XH, HIGH(DVUS(4))
	ldi		XL, LOW(DVUS(4))
	rcall	Wait4xCycles

	

	/*
	ldi r20, 0b00000000 //command
	ldi r21, 0xCA //DISCTL
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x00 //
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x20 //
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x11 //
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x00 //Dispersion
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0xBB //COMSCN
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x00 //
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0xD1 //OSCON
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0x94 //SLPOUT
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0x20 //PWRCTR
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x0F //
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0xA6 //DISNOR , DISINV 0xA7
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0x81 //VOLCTR
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x1F //0x27
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x03 //
	rcall SendLcd

	ldi r16, 2
	rcall	WaitMiliseconds

	ldi r20, 0b00000000 //command
	ldi r21, 0xBC //DATCTL
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x00 //
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x00 //
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x04 //16 gray scale type B
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0xAF //DISON
	rcall SendLcd
	*/
	
	
	

	
	ldi r20, 0b00000000 //command
	ldi r21, 0x11 //SLEEPOUT
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0x13 //INVON
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0x3A //COLMOD
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x02 //8 bits per pixel
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0x36 //MADCTL
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0xC0 //
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0x25 //SETCON
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x47 //contrast 0x47
	rcall SendLcd
	ldi r16, 20
	rcall	WaitMiliseconds

	ldi r20, 0b00000000 //command
	ldi r21, 0x2B //PASET
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x04 //
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x81 //
	rcall SendLcd

	
	ldi r20, 0b00000000 //command
	ldi r21, 0x2A //CASET
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x04 //
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x81 //
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0x2C //RAMWR
	rcall SendLcd
	loop10:
	loop9:
	ldi r20, 0b11111111 //data
	ldi r21, 0x00 //0x03, 0x1c, 0xe0
	rcall SendLcd
	inc rami1
	cpi		rami1,0x81
	brne	loop9
	ldi rami1, 0x00
	inc rami2
	cpi rami2,0x81
	brne loop10
	ldi rami2, 0x00

	ldi r20, 0b00000000 //command
	ldi r21, 0x2B //PASET
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x04 //
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x40 //
	rcall SendLcd

	
	ldi r20, 0b00000000 //command
	ldi r21, 0x2A //CASET
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x04 //
	rcall SendLcd
	ldi r20, 0b11111111 //data
	ldi r21, 0x40 //
	rcall SendLcd

	ldi r20, 0b00000000 //command
	ldi r21, 0x2C //RAMWR
	rcall SendLcd
	loop2:
	loop1:
	ldi r20, 0b11111111 //data
	ldi r21, 0xe0 //0x03, 0x1c, 0xe0
	rcall SendLcd
	inc rami1
	cpi		rami1,0x81
	brne	loop1
	ldi rami1, 0x00
	inc rami2
	cpi rami2,0x81
	brne loop2
	ldi rami2, 0x00

	ldi r20, 0b00000000 //command
	ldi r21, 0x2C //RAMWR
	rcall SendLcd
	loop4:
	loop3:
	ldi r20, 0b11111111 //data
	ldi r21, 0x03 //0x03, 0x1c, 0xe0
	rcall SendLcd
	inc rami1
	cpi		rami1,0x81
	brne	loop3
	ldi rami1, 0x00
	inc rami2
	cpi rami2,0x40
	brne loop4
	ldi rami2, 0x00

	ldi r20, 0b00000000 //command
	ldi r21, 0x2C //RAMWR
	rcall SendLcd
	loop6:
	loop5:
	ldi r20, 0b11111111 //data
	ldi r21, 0x1c //0x03, 0x1c, 0xe0
	rcall SendLcd
	inc rami1
	cpi		rami1,0x81
	brne	loop5
	ldi rami1, 0x00
	inc rami2
	cpi rami2,0x20
	brne loop6
	ldi rami2, 0x00

	ldi r20, 0b00000000 //command
	ldi r21, 0x2C //RAMWR
	rcall SendLcd
	loop8:
	loop7:
	ldi r20, 0b11111111 //data
	ldi r21, 0xff //0x03, 0x1c, 0xe0
	rcall SendLcd
	inc rami1
	cpi		rami1,0x81
	brne	loop7
	ldi rami1, 0x00
	inc rami2
	cpi rami2,0x10
	brne loop8
	ldi rami2, 0x00

	ldi r20, 0b00000000 //command
	ldi r21, 0x29 //DISPON
	rcall SendLcd
	
	ldi r20, 0b00000000 //command
	ldi r21, 0x03 //BSTRON
	rcall SendLcd
	

	
	


		ldi		XH, HIGH(DVUS(4))
		ldi		XL, LOW(DVUS(4))
		rcall	Wait4xCycles
	sbi PORTC, LCD_CS // disable device CS
ret

SendLcd:

		ldi		XH, HIGH(DVUS(4))
		ldi		XL, LOW(DVUS(4))
		rcall	Wait4xCycles
// set up first bit as command or data 
sbrc r20,0
sbi SPI_PORT, LCD_DATA
sbrs r20,0
cbi SPI_PORT, LCD_DATA
	

 //cbi PORTC, LCD_CS// Enable device CS 


		ldi		XH, HIGH(DVUS(2))
		ldi		XL, LOW(DVUS(2))
		rcall	Wait4xCycles
 sbi SPI_PORT, SPI_SCK // Pull Clock HIGH 
	ldi		XH, HIGH(DVUS(4))
	ldi		XL, LOW(DVUS(4))
	rcall	Wait4xCycles
 cbi SPI_PORT, SPI_SCK // Pull Clock LOW 
	ldi		XH, HIGH(DVUS(4))
	ldi		XL, LOW(DVUS(4))
	rcall	Wait4xCycles

 ldi r16, (0<<SPIE)|(1<<SPE)|(0<<DORD)|(0<<CPOL)|(0<<CPHA)|(1<<MSTR)|(1<<SPR1)|(1<<SPR0)
 out SPCR, r16  // Enable Hardware SPI 

		// send data 
		out SPDR,r21
		
		Wait_Transmit: // wait until send complete
		; Wait for transmission complete
		in r21, SPSR
		sbrs r21, SPIF
		rjmp Wait_Transmit


 //sbi PORTC, LCD_CS // disable device CS 

		ldi		XH, HIGH(DVUS(4))
		ldi		XL, LOW(DVUS(4))
		rcall	Wait4xCycles

 ldi r16, (0<<SPIE)|(0<<SPE)|(0<<DORD)|(0<<CPOL)|(0<<CPHA)|(1<<MSTR)|(1<<SPR1)|(1<<SPR0)
 out SPCR, r16 
// Disable Hardware SPI, this releases the SPI pins 
// for general IO use. which is used to send the 1'st bit out 
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

	ldi r16, 200
	rcall	WaitMiliseconds

ldi r18, 0b00100000 //format RS:E:D7:D6:D5:D4:N/A:N/A Set DDRAM ADR 00000000
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
ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A 
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

ldi r18, 0b00010000 //format RS:E:D7:D6:D5:D4:N/A:N/A Set CGRAM ADR 00000000
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b01010000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00010000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A 
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

ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A Write Data to CGRAM ADR 00000000
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10101100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11101100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10101100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds

ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A Write Data to CGRAM ADR 00000001
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds

ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A Write Data to CGRAM ADR 00000010
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds

ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A Write Data to CGRAM ADR 00000011
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds

ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A Write Data to CGRAM ADR 00000100
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds

ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A Write Data to CGRAM ADR 00000101
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds

ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A Write Data to CGRAM ADR 00000110
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
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

ldi r18, 0b10000000 //format RS:E:D7:D6:D5:D4:N/A:N/A Write your figure
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10000000 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b11000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 200
	rcall	WaitMiliseconds
ldi r18, 0b10000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
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




