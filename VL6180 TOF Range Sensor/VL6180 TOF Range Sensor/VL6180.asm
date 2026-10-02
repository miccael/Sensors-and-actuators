;
; VL6180 TOF Range Sensor.asm
;
; Created: 2018-05-12 14:39:56
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
	
	.def INDEX_HI = r19
	.def INDEX_LO = r20
	.def DATA	  = r21
	clr DATA
	.equ SLA_W = 0x52 //0x52 slave adress, 0x29 and R/W=0
	.equ SLA_R = 0x53 //0x53 slave adress, 0x29 and R/W=1 
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

	//**********************OBS OBS OBS OBS********************************************************
	//This step below for SCL Speed 100 kHz TWI is crucial, it won´t work at all in any other case
	//Even Thou I2C it´s VERY time critical (Below 100kHz TWI won´t work. 
	//Comment on 2018-05-19 after days on troubleshooting.
	//------------SCL speed 400kHz @ 20MHz ATmega328p-----------
	ldi r16, 0x11
	sts TWBR, r16 //400kHz TWI
	ldi r16, (0<<TWPS1)|(0<<TWPS0) //Prescaler 1
	sts TWSR, r16
	 //--------------------------------------------
	 //**********************OBS OBS OBS OBS********************************************************

// enable twi module, acks, and twi interrupt
ldi r16, (1<<TWEN) | (1<<TWIE) | (1<<TWEA)
sts TWCR, r16
	 
	//---------------I2C definitions and init----------------------
	//-------------------------------------------------------------

		



//---------------init of VL6180------------------------------------
//-----------------------------------------------------------------
rcall VL6180_settings
		
		ldi r16, 200
		rcall	WaitMiliseconds //wait 1s
		ldi r16, 200
		rcall	WaitMiliseconds
		ldi r16, 200
		rcall	WaitMiliseconds //
		ldi r16, 200
		rcall	WaitMiliseconds
		ldi r16, 200
		rcall	WaitMiliseconds
		ldi r16, 200
		rcall	WaitMiliseconds

//---------------init of VL6180------------------------------------
//-----------------------------------------------------------------
 rcall LCD




; Replace with your application code
main:


		ldi r16, 100
		rcall	WaitMiliseconds //wait
/*


		
		
 wait0_1:

ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x4D //RESULT__RANGE_STATUS{0x4D}; 
//if [0] = 1 then 
//Device Ready. When set to 1, indicates the device mode and
//configuration can be changed and a new start command will be accepted
rcall VL6180Read ;output in DATA



mov r16,DATA
sbrs r16,0
rjmp wait0_1
*/


		ldi r16, 100
		rcall	WaitMiliseconds //wait
		


ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x14 //
ldi DATA, 0x04
rcall VL6180Write




		ldi r16, 100
		rcall	WaitMiliseconds //wait
		


ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x18 //SYSRANGE_START{0x18}; [1] Ranging Mode Single-Shot, [0] starts a single measurement
ldi DATA, 0x01
rcall VL6180Write



		ldi r16, 100
		rcall	WaitMiliseconds //wait
		

wait0_0:
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x4F //RESULT__INTERRUPT_STATUS_GPIO{0x4F}; if [2] = 1 then New Sample Ready threshold event
rcall VL6180Read; output in DATA




mov r16,DATA
sbrs r16,2
rjmp wait0_0



//Why won´t the while-loop work and why is for example 0x4F reg and 0x10A always empty?
//Why won´t single shot ranging work?
//Try to change between Repeated Start and Stop---->Start in VL6180Read
//Does it require any other register settings in VL6180?
//Lägg till de övriga inställningarna 'Additional settings defaults from community'



		ldi r16, 100
		rcall	WaitMiliseconds //wait
		



ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x62 //RESULT__RANGE_VAL{0x62}
rcall VL6180Read ;output in DATA

rcall LCDwrite


		ldi r16, 100
		rcall	WaitMiliseconds //wait
	


ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x15 //SYSTEM__INTERRUPT_CLEAR{0x15}; [2] = 1 Clear Error Int, [1] = 1 Clear ALS Int, [0] = 1 Clear Range Int
ldi DATA, 0x07
rcall VL6180Write


		ldi r16, 100
		rcall	WaitMiliseconds //wait
	




		

rjmp main





VL6180_settings:

		ldi r16, 200
		rcall	WaitMiliseconds //
/*
wait0_2:
		
		
//SYSTEM__FRESH_OUT_OF_RESET {0x16}, check if bit 0 = 1
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x16 //
rcall VL6180Read; output in DATA

mov r16,DATA
sbrs r16,0
rjmp wait0_2
*/

		ldi r16, 200
		rcall	WaitMiliseconds //

		

//------------Private registers-------------
//WriteByte(0x0207, 0x01);
ldi INDEX_HI, 0x02 //
ldi INDEX_LO, 0x07 //
ldi DATA, 0x01
rcall VL6180Write
//WriteByte(0x0208, 0x01);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x02 //
ldi INDEX_LO, 0x08 //
ldi DATA, 0x01
rcall VL6180Write
//WriteByte(0x0096, 0x00);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x96 //
ldi DATA, 0x00
rcall VL6180Write
//WriteByte(0x0097, 0xfd);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x97 //
ldi DATA, 0xfd
rcall VL6180Write
//WriteByte(0x00e3, 0x00);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xe3 //
ldi DATA, 0x00
rcall VL6180Write
//WriteByte(0x00e4, 0x04);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xe4 //
ldi DATA, 0x04
rcall VL6180Write
//WriteByte(0x00e5, 0x02);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xe5 //
ldi DATA, 0x02
rcall VL6180Write
//WriteByte(0x00e6, 0x01);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xe6 //
ldi DATA, 0x01
rcall VL6180Write
//WriteByte(0x00e7, 0x03);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xe7 //
ldi DATA, 0x03
rcall VL6180Write
//WriteByte(0x00f5, 0x02);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xf5 //
ldi DATA, 0x02
rcall VL6180Write
//WriteByte(0x00d9, 0x05);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xd9 //
ldi DATA, 0x05
rcall VL6180Write
//WriteByte(0x00db, 0xce);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xdb //
ldi DATA, 0xce
rcall VL6180Write
//WriteByte(0x00dc, 0x03);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xdc //
ldi DATA, 0x03
rcall VL6180Write
//WriteByte(0x00dd, 0xf8);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xdd //
ldi DATA, 0xf8
rcall VL6180Write
//WriteByte(0x009f, 0x00);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x9f //
ldi DATA, 0x00
rcall VL6180Write
//WriteByte(0x00a3, 0x3c);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xa3 //
ldi DATA, 0x3c
rcall VL6180Write
//WriteByte(0x00b7, 0x00);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xb7 //
ldi DATA, 0x00
rcall VL6180Write
//WriteByte(0x00bb, 0x3c);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xbb //
ldi DATA, 0x3c
rcall VL6180Write
//WriteByte(0x00b2, 0x09);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xb2 //
ldi DATA, 0x09
rcall VL6180Write
//WriteByte(0x00ca, 0x09);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xca //
ldi DATA, 0x09
rcall VL6180Write
//WriteByte(0x0198, 0x01);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x01 //
ldi INDEX_LO, 0x98 //
ldi DATA, 0x01
rcall VL6180Write
//WriteByte(0x01b0, 0x17);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x01 //
ldi INDEX_LO, 0xb0 //
ldi DATA, 0x17
rcall VL6180Write
//WriteByte(0x01ad, 0x00);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x01 //
ldi INDEX_LO, 0xad //
ldi DATA, 0x00
rcall VL6180Write
//WriteByte(0x00ff, 0x05);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0xff //
ldi DATA, 0x05
rcall VL6180Write
//WriteByte(0x0100, 0x05);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x01 //
ldi INDEX_LO, 0x00 //
ldi DATA, 0x05
rcall VL6180Write
//WriteByte(0x0199, 0x05);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x01 //
ldi INDEX_LO, 0x99 //
ldi DATA, 0x05
rcall VL6180Write
//WriteByte(0x01a6, 0x1b);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x01 //
ldi INDEX_LO, 0xa6 //
ldi DATA, 0x1b
rcall VL6180Write
//WriteByte(0x01ac, 0x3e);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x01 //
ldi INDEX_LO, 0xac //
ldi DATA, 0x3e
rcall VL6180Write
//WriteByte(0x01a7, 0x1f);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x01 //
ldi INDEX_LO, 0xa7 //
ldi DATA, 0x1f
rcall VL6180Write
//WriteByte(0x0030, 0x00);
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x30 //
ldi DATA, 0x00
rcall VL6180Write
//------------Private registers------------


//----------Public registers--------------
//WriteByte(0x0011, 0x10);Enables polling for ‘New Sample ready’ when measurement completes
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x11 //
ldi DATA, 0x10
rcall VL6180Write
//WriteByte(0x010a, 0x30); // Set the averaging sample period (compromise between lower noise and increased execution time)
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x01 //
ldi INDEX_LO, 0x0a //
ldi DATA, 0x30
rcall VL6180Write
//WriteByte(0x003f, 0x46); // Sets the light and dark gain (upper nibble). Dark gain should not be changed.
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x3f //
ldi DATA, 0x46
rcall VL6180Write
//WriteByte(0x0031, 0xFF); // sets the # of range measurements after which auto calibration of system is performed
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x31 //
ldi DATA, 0xFF
rcall VL6180Write
//WriteByte(0x0040, 0x63); // Set ALS integration time to 100ms
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x40 //
ldi DATA, 0x63
rcall VL6180Write
//WriteByte(0x002e, 0x01); // perform a single temperature calibration of the ranging sensor
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x2e //
ldi DATA, 0x01
rcall VL6180Write
//WriteByte(0x001b, 0x09); // Set default ranging inter-measurement period to 100ms
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x1b //
ldi DATA, 0x09
rcall VL6180Write
//WriteByte(0x003e, 0x31); // Set default ALS inter-measurement period to 500ms
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x3e //
ldi DATA, 0x31
rcall VL6180Write
//WriteByte(0x0014, 0x24); // Configures interrupt on ‘New Sample Ready threshold event’
		ldi r16, 20
		rcall	WaitMiliseconds
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x14 //
ldi DATA, 0x24
rcall VL6180Write
		ldi r16, 20
		rcall	WaitMiliseconds
//----------Public registers--------------


//Additional settings defaults from community
 // VL6180x_setRegister(VL6180X_SYSRANGE_MAX_CONVERGENCE_TIME, 0x32);
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x1C //
ldi DATA, 0x32
rcall VL6180Write
		ldi r16, 20
		rcall	WaitMiliseconds
// VL6180x_setRegister(VL6180X_SYSRANGE_RANGE_CHECK_ENABLES, 0x10 | 0x01);??????Two Values?
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x2D //
ldi DATA, 0x11
rcall VL6180Write
		ldi r16, 20
		rcall	WaitMiliseconds
/*
//VL6180x_setRegister16bit(VL6180X_SYSRANGE_EARLY_CONVERGENCE_ESTIMATE, 0x7B);
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x22 //
ldi DATA, 0x7B
rcall VL6180Write
		ldi r16, 20
		rcall	WaitMiliseconds
//VL6180x_setRegister16bit(VL6180X_SYSALS_INTEGRATION_PERIOD, 0x64);
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x40 //
ldi DATA, 0x64
rcall VL6180Write
		ldi r16, 20
		rcall	WaitMiliseconds
*/
//VL6180x_setRegister(VL6180X_READOUT_AVERAGING_SAMPLE_PERIOD,0x30);
ldi INDEX_HI, 0x01 //
ldi INDEX_LO, 0x0A //
ldi DATA, 0x30
rcall VL6180Write
		ldi r16, 20
		rcall	WaitMiliseconds
//VL6180x_setRegister(VL6180X_SYSALS_ANALOGUE_GAIN,0x40);
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x3F //
ldi DATA, 0x40
rcall VL6180Write
		ldi r16, 20
		rcall	WaitMiliseconds
//VL6180x_setRegister(VL6180X_FIRMWARE_RESULT_SCALER,0x01);
ldi INDEX_HI, 0x01 //
ldi INDEX_LO, 0x20 //
ldi DATA, 0x01
rcall VL6180Write
		ldi r16, 20
		rcall	WaitMiliseconds
  

/*
 //SYSTEM__FRESH_OUT_OF_RESET {0x16}, write 0x00
ldi INDEX_HI, 0x00 //
ldi INDEX_LO, 0x16 //
ldi DATA, 0x00
rcall VL6180Write
		ldi r16, 20
		rcall	WaitMiliseconds
*/		


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



// Write result in Range Value to the LCD display
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

lsr DATA
lsr DATA
andi DATA, 0b00111100

ldi r16, 0b10000000
or DATA, r16
	mov r18, DATA //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds

ldi r16, 0b11000000
or DATA, r16
	mov r18, DATA //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds

ldi r16, 0b10000000
or DATA, r16
	mov r18, DATA //format RS:E:D7:D6:D5:D4:N/A:N/A
	rcall DAC
		ldi r16, 20
		rcall	WaitMiliseconds
// Write result in Range Value to the LCD display




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
VL6180Write://(byte index_hi, byte index_lo, byte data){
  
 
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
    //TWDR = index_hi; //
    //TWCR = (1<<TWINT) |
    //(1<<TWEN);
    mov r16, INDEX_HI //ex. INDEX_HI
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
    //TWDR = index_lo; //
    //TWCR = (1<<TWINT) |
    //(1<<TWEN);
    mov r16, INDEX_LO //ex. INDEX_LO
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
VL6180Read://(byte index_hi, index_lo){


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
    //TWDR = index_hi; //
    //TWCR = (1<<TWINT) |
    //(1<<TWEN);
    mov r16, INDEX_HI //ex. INDEX_HI
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

	 //---------------------
    //TWDR = index_lo; //
    //TWCR = (1<<TWINT) |
    //(1<<TWEN);
    mov r16, INDEX_LO //ex. INDEX_LO
	sts TWDR, r16
	ldi r16, (1<<TWINT)|(1<<TWEN)
	sts TWCR, r16

	
    //while (!(TWCR & (1<<TWINT)))
    //;
	wait9:
	lds r16,TWCR
	sbrs r16,TWINT
	rjmp wait9
    
	
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
      //(1<<TWEN); //Repeated Start Condition OBS!! Will Repeated Start Work? See p.38 in VL6180 datasheet.
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
      
     
      //data_lsb = TWDR; //read data byte
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

