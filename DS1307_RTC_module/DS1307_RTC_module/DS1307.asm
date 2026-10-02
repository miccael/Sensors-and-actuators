;
; DS1307_RTC_module.asm
;
; Created: 2018-06-02 19:27:12
; Author : Mikael Glans
;



.dseg
PAGE_START_OLED: .BYTE 1 ; reserve 1 byte to PAGE_START_OLED
PAGE_END_OLED: .BYTE 1 ; reserve 1 byte to PAGE_START_OLED
COLUMN_START_OLED: .BYTE 1 ; reserve 1 byte to COLUMN_START_OLED 
COLUMN_END_OLED: .BYTE 1 ; reserve 1 byte to COLUMN_START_OLED 

.cseg


//---------System Clock init----------------
  #define F_CPU 20000000 //
 //---------System Clock init----------------
 
		



	
	//---------------I2C definitions and init----------------------
	//-------------------------------------------------------------
	
	.def COMMAND = r19
	.def DATA = r20
	.def DATA2 = r21
	.equ SLA_W = 0xD0 //0xD0 slave adress, 0x68 and R/W=0
	.equ SLA_R = 0xD1 //0xD1 slave adress, 0x68 and R/W=1 
	.equ START = 0x08
	.equ R_START = 0x10
	.equ MT_SLA_ACK = 0x18
	.equ MR_SLA_ACK = 0x40
	.equ MT_DATA_ACK = 0x28
	.equ MR_DATA_ACK = 0x50
	.equ MT_DATA_NOACK = 0x30
	.equ MR_DATA_NOACK = 0x58

	ldi r16, 100
	rcall	WaitMiliseconds //wait .1s

	// deactivate internal pullups for twi.
	ldi r16, (0<<PC4)|(0<<PC5)
	sts DDRC, r16

	
	//------------SCL speed 50kHz @ 20MHz ATmega328p-----------
	ldi r16, 0xC0
	sts TWBR, r16 //50kHz TWI (100 kHz max in DS1307)
	ldi r16, (0<<TWPS1)|(0<<TWPS0) //Prescaler 1
	sts TWSR, r16
	 //--------------------------------------------
	

// enable twi module, acks, and twi interrupt
ldi r16, (1<<TWEN) | (1<<TWIE) | (1<<TWEA)
sts TWCR, r16
	 
	//---------------I2C definitions and init----------------------
	//-------------------------------------------------------------

		



//---------------init of DS1307------------------------------------
//-----------------------------------------------------------------
rcall DS1307_settings
		
		ldi r16, 200
		rcall	WaitMiliseconds //wait 200ms


//---------------init of VL6180------------------------------------
//-----------------------------------------------------------------
 rcall LCD




; Replace with your application code
main:
;clr DATA

		ldi r16, 1
		rcall	WaitMiliseconds //wait
		

ldi COMMAND, 0x00 //read seconds
rcall DS1307Read ;output in DATA

rcall LCDwrite


		ldi r16, 1
		rcall	WaitMiliseconds //wait

	

rjmp main





DS1307_settings:

		ldi r16, 100
		rcall	WaitMiliseconds //wait

ldi COMMAND, 0x00 //seconds
ldi DATA, 0b00000000 //CH=0 osc enable, 00s
rcall DS1307Write ;

		ldi r16, 100
		rcall	WaitMiliseconds //wait	

ldi COMMAND, 0x01 //minutes
ldi DATA, 0b01010111 //5x10minutes, 7xminutes
rcall DS1307Write ;

		ldi r16, 100
		rcall	WaitMiliseconds //wait	

ldi COMMAND, 0x02 //hours
ldi DATA, 0b01110001 //12hour mode, PM, 1x10hours, 1xhours
rcall DS1307Write ;

		ldi r16, 100
		rcall	WaitMiliseconds //wait	

ldi COMMAND, 0x03 //day
ldi DATA, 0b00000110 //day 6
rcall DS1307Write ;

		ldi r16, 100
		rcall	WaitMiliseconds //wait	

ldi COMMAND, 0x04 //date
ldi DATA, 0b00000011 //0x10DATE,3xDATE; 3rd
rcall DS1307Write ;

		ldi r16, 100
		rcall	WaitMiliseconds //wait	

ldi COMMAND, 0x05 //month
ldi DATA, 0b00000110 //0x10MONTH,6xMONTH; 6th (june)
rcall DS1307Write ;

		ldi r16, 100
		rcall	WaitMiliseconds //wait	

ldi COMMAND, 0x06 //year
ldi DATA, 0b00011000 //1x10YEAR,8xYEAR; 18 (2018)
rcall DS1307Write ;

		ldi r16, 100
		rcall	WaitMiliseconds //wait

ldi COMMAND, 0x07 //control register
ldi DATA, 0b00010000 //OUT[7]=0, SQWE[4]=1 enable osc output, RS1[1]=0,RS0[0]=0; 1Hz SQW OUTPUT FREQUENCY
rcall DS1307Write ;

		ldi r16, 100
		rcall	WaitMiliseconds //wait	

ret




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







mov DATA2, DATA



//**************************************************************************************
// Write result in Range Value to the LCD display
ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds
	ldi r18, 0b11001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds
	ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds


lsr DATA
lsr DATA
andi DATA, 0b00011100 //this mask is for reading 10x seconds on ds1307

 



;ldi DATA, 0b00111100
ori DATA, 0b10000000
	mov r18, DATA //format RS:E:D7:D6:D5:D4:N/A:N/A
	;ldi r18, 0b10010000
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds


ori DATA, 0b11000000
	mov r18, DATA //format RS:E:D7:D6:D5:D4:N/A:N/A
	;ldi r18, 0b11010000
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds


andi DATA, 0b00011100
ori DATA, 0b10000000
	mov r18, DATA //format RS:E:D7:D6:D5:D4:N/A:N/A
	;ldi r18, 0b10010000
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds
// Write result in Range Value to the LCD display
//********************************************************************************************






//**************************************************************************************
// Write result in Range Value to the LCD display
ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A 
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds
	ldi r18, 0b11001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds
	ldi r18, 0b10001100 //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds


lsl DATA2
lsl DATA2
andi DATA2, 0b00111100 //this mask is for reading 1x seconds on ds1307

 



;ldi DATA, 0b00111100
ori DATA2, 0b10000000
	mov r18, DATA2 //format RS:E:D7:D6:D5:D4:N/A:N/A
	;ldi r18, 0b10010000
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds


ori DATA2, 0b11000000
	mov r18, DATA2 //format RS:E:D7:D6:D5:D4:N/A:N/A
	;ldi r18, 0b11010000
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds


andi DATA2, 0b00111100
ori DATA2, 0b10000000
	mov r18, DATA2 //format RS:E:D7:D6:D5:D4:N/A:N/A
	;ldi r18, 0b10010000
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds
// Write result in Range Value to the LCD display
//********************************************************************************************




/*
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
*/

		
ret



ERROR1:
;rcall LCD
ret

;writes two bytes with the selected start register
DS1307Write://(byte command, byte data){
  
 
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
    //TWDR = data; //
    //TWCR = (1<<TWINT) |
    //(1<<TWEN);
    mov r16, DATA //ex. DATA
	sts TWDR, r16
	ldi r16, (1<<TWINT)|(1<<TWEN)
	sts TWCR, r16

	
    //while (!(TWCR & (1<<TWINT)))
    //;
	wait5:
	lds r16,TWCR
	sbrs r16,TWINT
	rjmp wait5
    
	
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
DS1307Read://(byte command){


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

	
     




/*
	 //TWCR = (1<<TWINT)|(1<<TWEN)|
    //(1<<TWSTO);
	ldi r16,(1<<TWINT)|(1<<TWEN)|(1<<TWSTO)
	sts TWCR, r16


		ldi r16, 20
		rcall	WaitMiliseconds //wait
		ldi r16, 20
		rcall	WaitMiliseconds
		ldi r16, 20
		rcall	WaitMiliseconds //
		ldi r16, 20
		rcall	WaitMiliseconds


	//TWCR = (1<<TWINT)|(1<<TWSTA)|
    //(1<<TWEN);
	ldi r16, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
	sts TWCR, r16

	//while (!(TWCR & (1<<TWINT)))
      //;
	  wait6_1:
	  lds r16,TWCR
	  sbrs r16,TWINT
	  rjmp wait6_1

      
      //if ((TWSR & 0xF8) != START)
      //ERROR();
	  lds r16,TWSR
	  andi r16, 0xF8
	  cpi r16, START
	  brne ERROR3
*/





	  
      //TWCR = (1<<TWINT)|(1<<TWSTA)|
      //(1<<TWEN); //Repeated Start Condition 
      ldi r16, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
	  sts TWCR, r16
	  
	  
      //while (!(TWCR & (1<<TWINT)))
      //;
      wait10:
	  lds r16,TWCR
	  sbrs r16,TWINT
	  rjmp wait10

	  
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
	  wait11:
	  lds r16,TWCR
	  sbrs r16,TWINT
	  rjmp wait11
      
	 
      //if ((TWSR & 0xF8) !=
      //MR_SLA_ACK)
      //ERROR();
	  lds r16,TWSR
	  andi r16, 0xF8
	  cpi r16, MR_SLA_ACK
	  brne ERROR3

      
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
	  cpi r16, MR_DATA_NOACK//MR_DATA_NOACK
	  brne ERROR3
      
     
      //data = TWDR; //read data byte
      lds r16,TWDR
	  mov DATA,r16

      
      //TWCR = (1<<TWINT)|(1<<TWEN)|
      //(1<<TWSTO); // Send a Stop Condition
      ldi r16, (1<<TWINT)|(1<<TWEN)|(1<<TWSTO)
	  sts TWCR, r16

	  
      //return data;

ret

ERROR3:
;rcall LCD
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

