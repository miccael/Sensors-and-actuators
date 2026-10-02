;
; WS2801.asm
;
; Created: 2016-06-22 21:18:12
; Author : Mikael Glans
;



//---------System Clock init----------------
  #define F_CPU 8000000
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
			
			ldi r21, 0b00001111 //green
			out SPDR,r21
			Wait_Transmit0:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit0


			ldi r21, 0b00001111 //blue
			out SPDR,r21
			Wait_Transmit1:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit1	

			ldi r21, 0b00001111 //red
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
	
	rcall sendmagenta
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
	rcall sendcyan
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
	rcall sendblue
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
	rcall sendgreen
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
	rcall sendyellow
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
	rcall sendred
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
	rcall sendyellow
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
	rcall sendgreen
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
	rcall sendblue
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
	rcall sendcyan
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
		
			
rjmp start

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

			ldi r21, 0b00001111 //red
			out SPDR,r21
			Wait_Transmit5:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit5	
		ret


		sendgreen:
			ldi r21, 0b00001111 //green
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
		ret


		sendblue:
			ldi r21, 0b00000000 //green
			out SPDR,r21
			Wait_Transmit9:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit9


			ldi r21, 0b00001111 //blue
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
		ret


		sendyellow:
			ldi r21, 0b00001111 //green
			out SPDR,r21
			Wait_Transmit12:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit12


			ldi r21, 0b00000000 //blue
			out SPDR,r21
			Wait_Transmit13:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit13	

			ldi r21, 0b00001111 //red
			out SPDR,r21
			Wait_Transmit14:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit14	
		ret

		sendcyan:
			ldi r21, 0b00001111 //green
			out SPDR,r21
			Wait_Transmit15:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit15


			ldi r21, 0b00001111 //blue
			out SPDR,r21
			Wait_Transmit16:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit16	

			ldi r21, 0b00000000 //red
			out SPDR,r21
			Wait_Transmit17:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit17	
		ret


		sendmagenta:
			ldi r21, 0b00000000 //green
			out SPDR,r21
			Wait_Transmit18:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit18


			ldi r21, 0b00001111 //blue
			out SPDR,r21
			Wait_Transmit19:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit19	

			ldi r21, 0b00001111 //red
			out SPDR,r21
			Wait_Transmit20:
			; Wait for transmission complete
			in r21, SPSR
			sbrs r21, SPIF
			rjmp Wait_Transmit20
		ret

#include "wait.asm" ; AVR Assembler v.2	
 

