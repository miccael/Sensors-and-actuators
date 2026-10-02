;
; I2C RGB Color Sensor_TCS34725.asm
;
; Created: 2017-05-08 15:19:27
; Author : Mikael Glans
;

.dseg
CDATAL:    .BYTE 1            ; reserve 1 byte to CDATAL 
CDATAH:    .BYTE 1            ; reserve 1 byte to CDATAH
RDATAL:    .BYTE 1            ; reserve 1 byte to RDATAL 
RDATAH:    .BYTE 1            ; reserve 1 byte to RDATAH 
GDATAL:    .BYTE 1            ; reserve 1 byte to GDATAL 
GDATAH:    .BYTE 1            ; reserve 1 byte to GDATAH 
BDATAL:    .BYTE 1            ; reserve 1 byte to BDATAL 
BDATAH:    .BYTE 1            ; reserve 1 byte to BDATAH 

.cseg


//---------System Clock init----------------
  #define F_CPU 20000000 //
 //---------System Clock init----------------
 
 
 rcall LCD

	

	
	//---------------I2C definitions and init----------------------
	//-------------------------------------------------------------
	
	.def COMMAND = r19
	.def DATA = r20
	.def DATA_MSB = r21
	.def DATA_LSB = r22
	.equ SLA_W = 0x52 //0x52 slave adress, 0x29 and R/W=0
	.equ SLA_R = 0x53 //0x53 slave adress, 0x29 and R/W=1 
	.equ START = 0x08
	.equ R_START = 0x10
	.equ MT_SLA_ACK = 0x18
	.equ MR_SLA_ACK = 0x40
	.equ MT_DATA_ACK = 0x28
	.equ MR_DATA_ACK = 0x50
	.equ MR_DATA_NOACK = 0x58



	//------------SCL speed-----------
	ldi r16, 0xFF
	sts TWBR, r16
	ldi r16, (1<<TWPS1)|(1<<TWPS0) //Prescaler 64
	sts TWSR, r16
	 //--------------------------------

	 //Must be written to enable 2-wire serial interface
	 ldi r16, (0<<PRTWI)
	 sts PRR, r16
	 //---------------------------

	 ldi r16, (0<<DDC4) //PC4 SDA [27] input
	 out DDRC, r16		//PC4 SDA [27] input
	 
	//---------------I2C definitions and init----------------------
	//-------------------------------------------------------------

	//---------------SPI definitions and init----------------------
	//-------------------------------------------------------------
	ldi r16, (1<<PB5)|(0<<PB4)|(1<<PB3)|(1<<PB2) //PB5 [SCK], PB3 [MOSI]
	out DDRB, r16
	//PB2 [~SS] output
	//PB4 [MISO] input
	//OBS! crucial to do this
	//pin direction step!
	
	
	/* Enable SPI, MSB first, Master, set clock rate fosc/16 OBS! CHECK DORD!*/
	ldi r16, (1<<SPE)|(0<<DORD)|(1<<MSTR)|(0<<CPOL)|(0<<CPHA)|(0<<SPR1)|(1<<SPR0)
	out SPCR, r16
	ldi r16, (0<<SPI2X)
	out SPSR, r16
	//---------------SPI definitions and init----------------------
	//-------------------------------------------------------------


; Replace with your application code
main:


		ldi r16, 20
		rcall	WaitMiliseconds //wait
		ldi r16, 20
		rcall	WaitMiliseconds
		ldi r16, 20
		rcall	WaitMiliseconds //
		ldi r16, 20
		rcall	WaitMiliseconds
		
ldi COMMAND, 0b10000000 //Start in the enable register
ldi DATA, 0b00001011 //WEN = 1, AEN = 1, PON = 1
rcall TCS34725Write

		ldi r16, 20
		rcall	WaitMiliseconds //wait
		ldi r16, 20
		rcall	WaitMiliseconds
		ldi r16, 20
		rcall	WaitMiliseconds //
		ldi r16, 20
		rcall	WaitMiliseconds

ldi COMMAND, 0b10000011 //Wait Time Register
ldi DATA, 0xFF //Wait Time counts 1 = 2.4 ms
rcall TCS34725Write

		ldi r16, 20
		rcall	WaitMiliseconds //wait
		ldi r16, 20
		rcall	WaitMiliseconds
		ldi r16, 20
		rcall	WaitMiliseconds //
		ldi r16, 20
		rcall	WaitMiliseconds

ldi COMMAND, 0b10000001 //RGBC Timing Register
ldi DATA, 0xC0 //ATIME = 0xC0
rcall TCS34725Write

		ldi r16, 20
		rcall	WaitMiliseconds //wait
		ldi r16, 20
		rcall	WaitMiliseconds
		ldi r16, 20
		rcall	WaitMiliseconds //
		ldi r16, 20
		rcall	WaitMiliseconds

ldi COMMAND, 0b10001111 //Control Register
ldi DATA, 0x03 //AGAIN[1:0] = 11, 60 x gain
 rcall TCS34725Write

		ldi r16, 20
		rcall	WaitMiliseconds //wait
		ldi r16, 20
		rcall	WaitMiliseconds
		ldi r16, 20
		rcall	WaitMiliseconds //
		ldi r16, 20
		rcall	WaitMiliseconds
		
 ldi COMMAND, 0b10110100 //Start to read from CDATA Register; reads Clear data low byte, Clear data high byte
 rcall TCS34725Read

 sts CDATAL, DATA_LSB
 sts CDATAH, DATA_MSB
		
		ldi r16, 200
		rcall	WaitMiliseconds //wait
		ldi r16, 200
		rcall	WaitMiliseconds
		ldi r16, 200
		rcall	WaitMiliseconds //
		ldi r16, 200
		rcall	WaitMiliseconds

ldi COMMAND, 0b10110110 //Start to read from RDATA Register; reads Red data low byte, Red data high byte
 rcall TCS34725Read

 sts RDATAL, DATA_LSB
 sts RDATAH, DATA_MSB
		
		ldi r16, 200
		rcall	WaitMiliseconds //wait
		ldi r16, 200
		rcall	WaitMiliseconds
		ldi r16, 200
		rcall	WaitMiliseconds //
		ldi r16, 200
		rcall	WaitMiliseconds

ldi COMMAND, 0b10111000 //Start to read from GDATA Register; reads Green data low byte, Green data high byte
 rcall TCS34725Read

 sts GDATAL, DATA_LSB
 sts GDATAH, DATA_MSB
		
		ldi r16, 200
		rcall	WaitMiliseconds //wait
		ldi r16, 200
		rcall	WaitMiliseconds
		ldi r16, 200
		rcall	WaitMiliseconds //
		ldi r16, 200
		rcall	WaitMiliseconds

ldi COMMAND, 0b10111010 //Start to read from BDATA Register; reads Blue data low byte, Blue data high byte
 rcall TCS34725Read

 sts BDATAL, DATA_LSB
 sts BDATAH, DATA_MSB
	
		ldi r16, 200
		rcall	WaitMiliseconds //wait
		ldi r16, 200
		rcall	WaitMiliseconds
		ldi r16, 200
		rcall	WaitMiliseconds //
		ldi r16, 200
		rcall	WaitMiliseconds

rcall LCDwrite 

		ldi r16, 200
		rcall	WaitMiliseconds //wait
		ldi r16, 200
		rcall	WaitMiliseconds
		ldi r16, 200
		rcall	WaitMiliseconds //
		ldi r16, 200
		rcall	WaitMiliseconds

rcall APA102C

		ldi r16, 200
		rcall	WaitMiliseconds //wait
		ldi r16, 200
		rcall	WaitMiliseconds
		ldi r16, 200
		rcall	WaitMiliseconds //
		ldi r16, 200
		rcall	WaitMiliseconds

    rjmp main


#include "wait.asm" ; AVR Assembler v.2

 ;------------------------------------------------------------------------------
; 1-wire definitions
;------------------------------------------------------------------------------
.equ	OW_PORT	= PORTD
.equ	OW_PIN	= PIND
.equ	OW_DDR	= DDRD
.equ	OW_DQ	= PD4

.def	OWCount = r17
;------------------------------------------------------------------------------
; 1-wire definitions
;------------------------------------------------------------------------------


LCDwrite:
	ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A Clear Display
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b01000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b01000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds



		ldi r18, 0b10010000 //format RS:E:D7:D6:D5:D4:N/A:N/A "J"
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b11010000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10010000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10101000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b11101000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10101000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds

	ldi r18, 0b10011000 //format RS:E:D7:D6:D5:D4:N/A:N/A "e"
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b11011000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10011000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10010100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b11010100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10010100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds

	ldi r18, 0b10011100 //format RS:E:D7:D6:D5:D4:N/A:N/A "s"
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b11011100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10011100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b11001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds

	ldi r18, 0b10011100 //format RS:E:D7:D6:D5:D4:N/A:N/A "u"
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b11011100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10011100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10010100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b11010100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10010100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds

	
		ldi r18, 0b10011100 //format RS:E:D7:D6:D5:D4:N/A:N/A "s"
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b11011100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10011100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b11001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds




	ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A Clear Display
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b01000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b01000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds


	ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b11001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds

		lds DATA, CDATAH
		lsl DATA //use only bits [11:8]
		lsl DATA
		andi DATA, 0b00111111
		
	ldi r16, 0b10000000
	or r16, DATA
	mov r18, r16 //format RS:E:D7:D6:D5:D4:N/A:N/A 
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r16, 0b11000000
	or r16, DATA
	mov r18, r16 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
	ldi r16, 0b10000000
	or r16, DATA
	mov r18, r16 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds


		
ret



ERROR1:
;rcall LCD
ret

;writes two bytes with the selected start register
TCS34725Write://(byte command, byte data){
  
 
    //TWCR = (1<<TWINT)|(1<<TWSTA)|
    //(1<<TWEN);
	ldi r16, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
	sts TWCR, r16
    
    //while (!(TWCR & (1<<TWINT)))
    ;
    wait1:
	lds r16,TWCR
	sbrs r16,TWINT
	rjmp wait1

    //if ((TWSR & 0xF8) != START)
    //ERROR();
    lds r16,TWSR
	andi r16, 0xF8
	cpi r16, START
	brne ERROR1

	
    //TWDR = SLA_W;
    //TWCR = (1<<TWINT) |
    //(1<<TWEN);
	ldi r16, SLA_W
	sts TWDR, r16
	ldi r16, (1<<TWINT)|(1<<TWEN)
	sts TWCR, r16
    
	
    //while (!(TWCR & (1<<TWINT)))
    //;
	wait2:
	lds r16,TWCR
	sbrs r16,TWINT
	rjmp wait2

    
    //if ((TWSR & 0xF8) !=
    //MT_SLA_ACK)
    //ERROR();
	lds r16,TWSR
	andi r16, 0xF8
	cpi r16, MT_SLA_ACK
	brne ERROR1

    
	

    //---------------------
    //TWDR = command; //
    //TWCR = (1<<TWINT) |
    //(1<<TWEN);
    mov r16, COMMAND //ex. COMMAND
	sts TWDR, r16
	ldi r16, (1<<TWINT)|(1<<TWEN)
	sts TWCR, r16

	
    //while (!(TWCR & (1<<TWINT)))
    //;
	wait3:
	lds r16,TWCR
	sbrs r16,TWINT
	rjmp wait3
    
	
    //if ((TWSR & 0xF8) !=
    //MT_DATA_ACK)
    //ERROR();
	lds r16,TWSR
	andi r16, 0xF8
	cpi r16, MT_DATA_ACK
	brne ERROR2
	//---------------------

    //---------------------
    //TWDR = data_msb; //
    //TWCR = (1<<TWINT) |
    //(1<<TWEN);
    mov r16, DATA //ex. DATA
	sts TWDR, r16
	ldi r16, (1<<TWINT)|(1<<TWEN)
	sts TWCR, r16

	
    //while (!(TWCR & (1<<TWINT)))
    //;
	wait4:
	lds r16,TWCR
	sbrs r16,TWINT
	rjmp wait4
    
	
    //if ((TWSR & 0xF8) !=
    //MT_DATA_ACK)
    //ERROR();
	lds r16,TWSR
	andi r16, 0xF8
	cpi r16, MT_DATA_ACK
	brne ERROR2
	//---------------------


    //TWCR = (1<<TWINT)|(1<<TWEN)|
    //(1<<TWSTO);
	ldi r16,(1<<TWINT)|(1<<TWEN)|(1<<TWSTO)
	sts TWCR, r16

ret


ERROR2: 
;rcall LCD
ret

;reads two bytes with the selected start register
TCS34725Read://(byte command){


      //byte data;  
       
      //TWCR = (1<<TWINT)|(1<<TWSTA)|
      //(1<<TWEN); //Start Condition
	  ldi r16, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
	  sts TWCR, r16
      
      //while (!(TWCR & (1<<TWINT)))
      //;
	  wait6:
	  lds r16,TWCR
	  sbrs r16,TWINT
	  rjmp wait6

      
      //if ((TWSR & 0xF8) != START)
      //ERROR();
	  lds r16,TWSR
	  andi r16, 0xF8
	  cpi r16, START
	  brne ERROR2
      

	  
      //TWDR = SLA_W;
      //TWCR = (1<<TWINT) |
      //(1<<TWEN);
	  ldi r16, SLA_W
	  sts TWDR, r16
	  ldi r16, (1<<TWINT)|(1<<TWEN)
	  sts TWCR, r16
      
	  
      //while (!(TWCR & (1<<TWINT)))
      //;
      wait7:
	  lds r16,TWCR
	  sbrs r16,TWINT
	  rjmp wait7

	 
      //if ((TWSR & 0xF8) !=
      //MT_SLA_ACK)
      //ERROR();
	  lds r16,TWSR
	  andi r16, 0xF8
	  cpi r16, MT_SLA_ACK
	  brne ERROR2
      
	  //---------------------
    //TWDR = command; //
    //TWCR = (1<<TWINT) |
    //(1<<TWEN);
    mov r16, COMMAND //ex. COMMAND
	sts TWDR, r16
	ldi r16, (1<<TWINT)|(1<<TWEN)
	sts TWCR, r16

	
    //while (!(TWCR & (1<<TWINT)))
    //;
	wait8:
	lds r16,TWCR
	sbrs r16,TWINT
	rjmp wait8
    
	
    //if ((TWSR & 0xF8) !=
    //MT_DATA_ACK)
    //ERROR();
	lds r16,TWSR
	andi r16, 0xF8
	cpi r16, MT_DATA_ACK
	brne ERROR2
	//---------------------

     
	 
      //TWCR = (1<<TWINT)|(1<<TWSTA)|
      //(1<<TWEN); //Repeated Start Condition
      ldi r16, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
	  sts TWCR, r16
	  
	  
      //while (!(TWCR & (1<<TWINT)))
      //;
      wait9:
	  lds r16,TWCR
	  sbrs r16,TWINT
	  rjmp wait9

	  
      //if ((TWSR & 0xF8) != R_START)
      //ERROR();
	  lds r16,TWSR
	  andi r16, 0xF8
	  cpi r16, R_START
	  brne ERROR3
      
      
      //TWDR = SLA_R;
      //TWCR = (1<<TWINT) |
      //(1<<TWEN);
      ldi r16, SLA_R
	  sts TWDR, r16
	  ldi r16, (1<<TWINT)|(1<<TWEN)
	  sts TWCR, r16

	  
      //while (!(TWCR & (1<<TWINT)))
      //;
	  wait10:
	  lds r16,TWCR
	  sbrs r16,TWINT
	  rjmp wait10
      
	 
      //if ((TWSR & 0xF8) !=
      //MR_SLA_ACK)
      //ERROR();
	  lds r16,TWSR
	  andi r16, 0xF8
	  cpi r16, MR_SLA_ACK
	  brne ERROR3
      


	   //TWCR = (1<<TWINT) |
      //(1<<TWEA)|(1<<TWEN); //Data byte will be received and 
                            //ACK TWEA=1 will be returned
      ldi r16, (1<<TWINT)|(1<<TWEA)|(1<<TWEN)
	  sts TWCR, r16
	  
	  
      //while (!(TWCR & (1<<TWINT)))
      //;
	  wait11:
	  lds r16,TWCR
	  sbrs r16,TWINT
	  rjmp wait11
      
	  
      //if ((TWSR & 0xF8) !=
      //MR_DATA_NOACK)
      //ERROR();
	  lds r16,TWSR
	  andi r16, 0xF8
	  cpi r16, MR_DATA_ACK
	  brne ERROR3
      
     
      //data_msb = TWDR; //read data byte
      lds r16,TWDR
	  mov DATA_LSB,r16



      
      //TWCR = (1<<TWINT) |
      //(0<<TWEA)|(1<<TWEN); //Data byte will be received and 
                            //NOT ACK TWEA=0 will be returned
      ldi r16, (1<<TWINT)|(0<<TWEA)|(1<<TWEN)
	  sts TWCR, r16
	  
	  
      //while (!(TWCR & (1<<TWINT)))
      //;
	  wait12:
	  lds r16,TWCR
	  sbrs r16,TWINT
	  rjmp wait12
      
	  
      //if ((TWSR & 0xF8) !=
      //MR_DATA_NOACK)
      //ERROR();
	  lds r16,TWSR
	  andi r16, 0xF8
	  cpi r16, MR_DATA_NOACK
	  brne ERROR3
      
     
      //data_lsb = TWDR; //read data byte
      lds r16,TWDR
	  mov DATA_MSB,r16

      
      //TWCR = (1<<TWINT)|(1<<TWEN)|
      //(1<<TWSTO); // Send a Stop Condition
      ldi r16, (1<<TWINT)|(1<<TWEN)|(1<<TWSTO)
	  sts TWCR, r16

	  
      //return data;

ret

ERROR3:
;rcall LCD
ret

APA102C:
	ldi r16, 0x00          //Start Frame
	 rcall SPI_MasterTransmit
	 ldi r16, 0x00
	 rcall SPI_MasterTransmit
	 ldi r16, 0x00
	 rcall SPI_MasterTransmit
	 ldi r16, 0x00
	 rcall SPI_MasterTransmit

	 ldi r16, 0b11101000 //Global brightness setting 01000
	 rcall SPI_MasterTransmit
	 lds r16, BDATAH      //Blue frame
	 andi r16, 0b11111111
	
	 //ldi r16, 0x00
	 rcall SPI_MasterTransmit
	 lds r16, GDATAH      //Green frame
	 andi r16, 0b11111111
	
	 //ldi r16, 0x00
	 rcall SPI_MasterTransmit
	 lds r16, RDATAH     //Red frame
	 andi r16, 0b11111111
	
	 //ldi r16, 0x0f
	 rcall SPI_MasterTransmit

	  ldi r16, 0xFF        //End Frame
	 rcall SPI_MasterTransmit
	 ldi r16, 0xFF
	 rcall SPI_MasterTransmit
	 ldi r16, 0xFF
	 rcall SPI_MasterTransmit
	 ldi r16, 0xFF
	 rcall SPI_MasterTransmit
ret

SPI_MasterTransmit: //(char spiData) 
	
	/* Start transmission */
	out SPDR, r16
	/* Wait for transmission complete */
    wait13:
	in r16, SPSR
	sbrs r16, SPIF
	rjmp wait13

ret





LCD:
	ldi r16, 20
	rcall	WaitMiliseconds

   //-----------------START OF LCD init-----------------
ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A Control Sequence 8-bit interface
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
	ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds

ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A Control Sequence 8-bit interface
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00001000 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01001000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00001000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds

ldi r18, 0b00001000 //format RS:E:D7:D6:D5:D4:N/A:N/A 4-bit Mode
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01001000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00001000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00100000 //format RS:E:D7:D6:D5:D4:N/A:N/A Function set: N:1 2 line, F:0 5x8
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01100000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00100000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds

ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A Display ON/OFF control
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00111100 //format RS:E:D7:D6:D5:D4:N/A:N/A D display on, C cursor on, B blinking on
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00111100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds

ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A Entry Mode
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00011000 //format RS:E:D7:D6:D5:D4:N/A:N/A I/D increament, S no display shift
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01011000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00011000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds

ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A Clear Display
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00000000 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b01000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
ldi r18, 0b00000100 //format RS:E:D7:D6:D5:D4:N/A:N/A
rcall DAC
	ldi r16, 20
	rcall	WaitMiliseconds
//-----------------END OF LCD init-----------------

	ldi r16, 20
	rcall	WaitMiliseconds
ret



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




