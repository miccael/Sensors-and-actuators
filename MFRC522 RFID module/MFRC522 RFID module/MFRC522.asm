;
; MFRC522 RFID module.asm
;
; Created: 2019-11-23 12:07:08
; Author : Mikael Glans
;


/*
Programmera och PoC testa mfrc522 rfid module. 
1.Testa skriv 12 Bytes till FIFO, testa kommando MFAuthent=1110, 
Testa läs MFCrypto1On bit=1 om kommandot lyckades. 
2. Testa läs VersionReg register (37h) och Version[7:0]. 
3. Testa eventuellt kommando Transceive=1100; 
efter kommandot skriv till StartSend bit i BitFramingReg 
för att starta transmission. 
4. Prova eventuellt fler kommandon 
++++Stödjande exempelkod finns Example code 1 och 
Example code 2 på electrokits hemsida++++
*/


.dseg
DUMMY_PAGE_1: .BYTE 1 ; reserve 1 byte to DUMMY_PAGE_1
SERIAL0: .BYTE 1
SERIAL1: .BYTE 1
SERIAL2: .BYTE 1
SERIAL3: .BYTE 1
CHECKBYTE4: .BYTE 1
CRC_H: .BYTE 1
CRC_L: .BYTE 1
.cseg


//---------System Clock init----------------
  #define F_CPU 20000000 //
 //---------System Clock init----------------
 


		.def COMMAND = r19
		.def DATA = r20
		.def DATA1 = r21 //
		.def DATA2 = r22 //
		.def DATA3 = r23 //
		.def ADDR0 = r24

		

		
		/*
		//------------SCL speed 50kHz @ 20MHz ATmega328p-----------
		ldi r16, 0xC0
		sts TWBR, r16 //50kHz TWI (400 kHz max in MAX30105)
		ldi r16, (0<<TWPS1)|(0<<TWPS0) //Prescaler 1
		sts TWSR, r16
		 //--------------------------------------------
	*/

		//********************SPI init*********************************************
	
	//clock division factor 256
	ldi r16, (1<<CLKPS3)|(0<<CLKPS2)|(0<<CLKPS1)|(0<<CLKPS0)
	sts CLKPR, r16
	ldi r16, 0b00101100 //PB5 [SCK], PB3 [MOSI], PB2 [~SS] output, PB4 [MISO] input
	out DDRB, r16
 
	ldi r16, 0b00100000 //[SCK] high to begin with
	out PORTB, r16

	/* Enable SPI, MSB first, Master, CPOL=0 sck low idle, set clock rate fck/128 */
	ldi r16, (1<<SPE)|(0<<DORD)|(1<<MSTR)|(0<<CPOL)|(0<<CPHA)|(1<<SPR1)|(1<<SPR0)
	out SPCR, r16
	ldi r16, (0<<SPI2X)
	out SPSR, r16
	
	//*******************End of SPI init******************************************



//---------------init of MFRC522------------------------------------
//-----------------------------------------------------------------
		rcall MFRC522_settings
		ldi r16, 200
		rcall	WaitMiliseconds //wait 200ms
//---------------init of MFRC522------------------------------------
//-----------------------------------------------------------------
 
 rcall LCD


					/**********FIFO and FIFOLevel test*********/
					/*
					ldi COMMAND, 0x0A //FIFOLevelReg register 
					ldi DATA, 0b10000000 //Flush buffer[7]=1
					rcall MFRC522Write 

					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0x52 //PICC_REQIDL
					rcall MFRC522Write

					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0x52 //PICC_REQIDL
					rcall MFRC522Write

					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0x52 //PICC_REQIDL
					rcall MFRC522Write

					ldi COMMAND, 0x09 //
					rcall MFRC522Read ;output in DATA
					mov DATA1, DATA //
					*/
					/**********FIFO and FIFOLevel test*********/
					
					/******Soft reset clears FIFO even if vcc active****/
					/*
					ldi COMMAND, 0x01 //CommandReg register
					ldi DATA, 0b00001111 //SoftReset
					rcall MFRC522Write
					*/
					/******Soft reset clears FIFO even if vcc active****/








					/*
					ldi COMMAND, 0x0d //BitFramingReg register
					ldi DATA, 0b00000000 //
					rcall MFRC522Write

					
					ldi COMMAND, 0x02 //ComIEnReg register
					ldi DATA, 0b11110111 //
					rcall MFRC522Write 

					ldi COMMAND, 0x04 //ComIrqReg register
					ldi DATA, 0b10000000 //
					rcall MFRC522Write 
					*/

					


; Replace with your application code
main:
	
		ldi r16, 1
		rcall	WaitMiliseconds //wait
				
					
					
					/******CRC Calculation******/
					/*
					ldi COMMAND, 0x05 //DivIrqReg register 
					ldi DATA, 0b00000000 //CRCIRq[2]=0
					rcall MFRC522Write 

					ldi COMMAND, 0x0A //FIFOLevelReg register 
					ldi DATA, 0b10000000 //Flush buffer[7]=1
					rcall MFRC522Write 

					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0x26 //PICC_REQIDL
					rcall MFRC522Write

					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0x02 //Block Adress
					rcall MFRC522Write

					
					ldi COMMAND, 0x01 //CommandReg register
					ldi DATA, 0b00000011 //RcvOff[5]=0, Command[3:0]=0011: CalcCRC
					rcall MFRC522Write 
					
					
					
					wait_crcirq:
					ldi COMMAND, 0x05 //DivIrqReg register
					rcall MFRC522Read ;output in DATA
					sbrs DATA,2 //Is CRCIrq set? otherwise wait
					rjmp wait_crcirq
					
					

					ldi r16, 10
					rcall	WaitMiliseconds //wait

					ldi COMMAND, 0x01 //CommandReg register
					ldi DATA, 0b00000000 //RcvOff[5]=0, Command[3:0]=0000: Idle
					rcall MFRC522Write

					ldi COMMAND, 0x21 //CRCResultReg (higher bits) register
					rcall MFRC522Read ;output in DATA
					mov DATA1, DATA //

					ldi COMMAND, 0x22 //CRCResultReg (lower bits) register
					rcall MFRC522Read ;output in DATA
					mov DATA2, DATA //
					*/
					/******CRC Calculation******/
					


					

					/*******MFRC522 Request******************/
					ldi COMMAND, 0x0A //FIFOLevelReg register 
					ldi DATA, 0b10000000 //Flush buffer[7]=1
					rcall MFRC522Write 

					ldi COMMAND, 0x01 //CommandReg register
					ldi DATA, 0b00000000 //RcvOff[5]=0, Command[3:0]=0000: Idle
					rcall MFRC522Write

					
					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0x26 //PICC_REQIDL
					rcall MFRC522Write

					
					ldi COMMAND, 0x01 //CommandReg register
					ldi DATA, 0b00001100 //RcvOff[5]=0, Command[3:0]=1100: Transceive
					rcall MFRC522Write 
					
					
					ldi COMMAND, 0x0d //BitFramingReg register
					ldi DATA, 0b10000111 //StartSend[7]=1
					rcall MFRC522Write
					

					ldi r16, 25
					rcall	WaitMiliseconds //wait

					
					
					ldi COMMAND, 0x0d //BitFramingReg register
					ldi DATA, 0b00000000 //StartSend[7]=0
					rcall MFRC522Write
					 

					 /*
					 ldi COMMAND, 0x0a //FIFOLevelReg register
					rcall MFRC522Read ;output in DATA
					mov DATA1, DATA //
					*/
					
					
					ldi COMMAND, 0x09 //
					rcall MFRC522Read ;output in DATA
					mov DATA1, DATA //
					 //rcall LCDwrite
					ldi COMMAND, 0x09 //
					rcall MFRC522Read ;output in DATA
					mov DATA2, DATA //
					 //rcall LCDwrite
					/*******MFRC522 Request******************/
					 





					 /*******MFRC522 Anti-collision******************/
					 
					ldi COMMAND, 0x0A //FIFOLevelReg register 
					ldi DATA, 0b10000000 //Flush buffer[7]=1
					rcall MFRC522Write 

					ldi COMMAND, 0x01 //CommandReg register
					ldi DATA, 0b00000000 //RcvOff[5]=0, Command[3:0]=0000: Idle
					rcall MFRC522Write

					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0x93 //PICC_ANTICOLL
					rcall MFRC522Write
					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0x20 //
					rcall MFRC522Write

					ldi COMMAND, 0x01 //CommandReg register
					ldi DATA, 0b00001100 //RcvOff[5]=0, Command[3:0]=1100: Transceive
					rcall MFRC522Write 
					
					ldi COMMAND, 0x0d //BitFramingReg register
					ldi DATA, 0b10000000 //StartSend[7]=1
					rcall MFRC522Write
					
					ldi r16, 25
					rcall	WaitMiliseconds //wait
					
					ldi COMMAND, 0x0d //BitFramingReg register
					ldi DATA, 0b00000000 //StartSend[7]=0
					rcall MFRC522Write


					ldi COMMAND, 0x09 //First read byte in SPI reading is a "dummy byte"
					rcall MFRC522Read ;output in DATA
					sts SERIAL0, DATA //
					 //rcall LCDwrite
					ldi COMMAND, 0x09 //
					rcall MFRC522Read ;output in DATA
					sts SERIAL0, DATA //
					 //rcall LCDwrite
					ldi COMMAND, 0x09 //
					rcall MFRC522Read ;output in DATA
					sts SERIAL1, DATA //
					 //rcall LCDwrite
					ldi COMMAND, 0x09 //
					rcall MFRC522Read ;output in DATA
					sts SERIAL2, DATA //
					 //rcall LCDwrite
					ldi COMMAND, 0x09 //
					rcall MFRC522Read ;output in DATA
					sts SERIAL3, DATA //
					 //rcall LCDwrite
					ldi COMMAND, 0x09 //
					rcall MFRC522Read ;output in DATA
					sts CHECKBYTE4, DATA //
					 //rcall LCDwrite


					//ldi r16, 60
					//rcall	WaitMiliseconds //wait
					 
					  /*******MFRC522 Anti-collision******************/





					  /*******MFRC522 Select tag******************/
					  
							  /******CRC Calculation******/
							
							ldi COMMAND, 0x0A //FIFOLevelReg register 
							ldi DATA, 0b10000000 //Flush buffer[7]=1
							rcall MFRC522Write 

							
							ldi COMMAND, 0x09 //FIFO
							ldi DATA, 0x93 //PICC_SElECTTAG
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							ldi DATA, 0x70 //
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							lds DATA, SERIAL0 //SERIAL0
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							lds DATA, SERIAL1 //SERIAL1
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							lds DATA, SERIAL2 //SERIAL2
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							lds DATA, SERIAL3 //SERIAL3
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							lds DATA, CHECKBYTE4 //CHECKBYTE4
							rcall MFRC522Write
							

					
							ldi COMMAND, 0x01 //CommandReg register
							ldi DATA, 0b00000011 //RcvOff[5]=0, Command[3:0]=0011: CalcCRC
							rcall MFRC522Write 
					
							ldi r16, 10
							rcall	WaitMiliseconds //wait

							ldi COMMAND, 0x01 //CommandReg register
							ldi DATA, 0b00000000 //RcvOff[5]=0, Command[3:0]=0000: Idle
							rcall MFRC522Write

							ldi COMMAND, 0x00 //First read byte in SPI reading is a "dummy byte"
							rcall MFRC522Read ;output in DATA
							sts CRC_H, DATA //

							ldi COMMAND, 0x21 //CRCResultReg (higher bits) register
							rcall MFRC522Read ;output in DATA
							sts CRC_H, DATA //

							ldi COMMAND, 0x22 //CRCResultReg (lower bits) register
							rcall MFRC522Read ;output in DATA
							sts CRC_L, DATA //

							
							/******CRC Calculation******/

					/*
					ldi COMMAND, 0x0A //FIFOLevelReg register 
					ldi DATA, 0b10000000 //Flush buffer[7]=1
					rcall MFRC522Write 

					ldi COMMAND, 0x01 //CommandReg register
					ldi DATA, 0b00000000 //RcvOff[5]=0, Command[3:0]=0000: Idle
					rcall MFRC522Write


								//ldi COMMAND, 0x09 //FIFO
								//ldi DATA, 0b01100001 //SERIAL0, LSB first
								//rcall MFRC522Write
								//ldi COMMAND, 0x09 //FIFO
								//ldi DATA, 0b10110011 //SERIAL1, LSB first
								//rcall MFRC522Write
								//ldi COMMAND, 0x09 //FIFO
								//ldi DATA, 0b11001010 //SERIAL2, LSB first
								//rcall MFRC522Write
								//ldi COMMAND, 0x09 //FIFO
								//ldi DATA, 0b10000011 //SERIAL3, LSB first
								//rcall MFRC522Write
								//ldi COMMAND, 0x09 //FIFO
								//ldi DATA,  0b10011011//CHECKBYTE4, LSB first
								//rcall MFRC522Write

							
							ldi COMMAND, 0x09 //FIFO
							ldi DATA, 0x93 //PICC_SElECTTAG
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							ldi DATA, 0x70 //
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							lds DATA, SERIAL0 // SERIAL0
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							lds DATA, SERIAL1 //SERIAL1
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							lds DATA, SERIAL2 //SERIAL2
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							lds DATA, SERIAL3 //SERIAL3
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							lds DATA, CHECKBYTE4 //CHECKBYTE4
							rcall MFRC522Write

								//ldi r16, 60
								//rcall WaitMiliseconds //wait
							ldi COMMAND, 0x09 //FIFO
							ldi DATA, 0b00110100//0b00101100 CRC_L LSB first according to ISO/IEC 14443-3:2001(E) datasheet
							rcall MFRC522Write
							ldi COMMAND, 0x09 //FIFO
							ldi DATA, 0b01001101//0b10110010 CRC_H LSB first according to ISO/IEC 14443-3:2001(E) datasheet
							rcall MFRC522Write
							

					ldi COMMAND, 0x01 //CommandReg register
					ldi DATA, 0b00001100 //RcvOff[5]=0, Command[3:0]=1100: Transceive
					rcall MFRC522Write 
					
					ldi COMMAND, 0x0d //BitFramingReg register
					ldi DATA, 0b10000000 //StartSend[7]=1
					rcall MFRC522Write
					
					ldi r16, 30 //wait min 25ms (or too long time: smart card goes back to sleep?)
					rcall	WaitMiliseconds //wait
					
					ldi COMMAND, 0x0d //BitFramingReg register
					ldi DATA, 0b00000000 //StartSend[7]=0
					rcall MFRC522Write





						

					ldi COMMAND, 0x09 // SAK response
					rcall MFRC522Read ;output in DATA
					mov DATA1, DATA //
					 //rcall LCDwrite
					ldi COMMAND, 0x09 //
					rcall MFRC522Read ;output in DATA
					mov DATA2, DATA //
					 //rcall LCDwrite
					ldi COMMAND, 0x09 //
					rcall MFRC522Read ;output in DATA
					mov DATA3, DATA //
					 //rcall LCDwrite
					
					*/
					
					  /*******MFRC522 Select tag******************/

						
							

					 /*******MFRC522 Authentication******************/
					/*
					ldi COMMAND, 0x0A //FIFOLevelReg register 
					ldi DATA, 0b10000000 //Flush buffer[7]=1
					rcall MFRC522Write 

					ldi COMMAND, 0x01 //CommandReg register
					ldi DATA, 0b00000000 //RcvOff[5]=0, Command[3:0]=0000: Idle
					rcall MFRC522Write

					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0x60 //Authentication command code
					rcall MFRC522Write
					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0x0B //Block adress=11 in the interval from 0~63
					rcall MFRC522Write
					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0b11111111 //Sector key byte 0
					rcall MFRC522Write
					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0b11111111 //Sector key byte 1
					rcall MFRC522Write
					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0b11111111 //Sector key byte 2
					rcall MFRC522Write
					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0b11111111 //Sector key byte 3
					rcall MFRC522Write
					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0b11111111 //Sector key byte 4
					rcall MFRC522Write
					ldi COMMAND, 0x09 //FIFO
					ldi DATA, 0b11111111 //Sector key byte 5
					rcall MFRC522Write




							//ldi COMMAND, 0x09 //FIFO
							//ldi DATA, 0b01100001 //SERIAL0, LSB first
							//rcall MFRC522Write
							//ldi COMMAND, 0x09 //FIFO
							//ldi DATA, 0b10110011 //SERIAL1, LSB first
							//rcall MFRC522Write
							//ldi COMMAND, 0x09 //FIFO
							//ldi DATA, 0b11001010 //SERIAL2, LSB first
							//rcall MFRC522Write
							//ldi COMMAND, 0x09 //FIFO
							//ldi DATA, 0b10000011 //SERIAL3, LSB first
							//rcall MFRC522Write
					




					
					ldi COMMAND, 0x09 //FIFO
					lds DATA, SERIAL0 //Card serial number byte 0
					rcall MFRC522Write
					ldi COMMAND, 0x09 //FIFO
					lds DATA, SERIAL1 //Card serial number byte 1
					rcall MFRC522Write
					ldi COMMAND, 0x09 //FIFO
					lds DATA, SERIAL2 //Card serial number byte 2
					rcall MFRC522Write
					ldi COMMAND, 0x09 //FIFO
					lds DATA, SERIAL3 //Card serial number byte 3
					rcall MFRC522Write
					

					
					ldi COMMAND, 0x01 //CommandReg register
					ldi DATA, 0b00001100 //RcvOff[5]=0, Command[3:0]=1100: Transceive
					rcall MFRC522Write

					ldi COMMAND, 0x0d //BitFramingReg register
					ldi DATA, 0b10000000 //StartSend[7]=1
					rcall MFRC522Write

						ldi r16, 25
						rcall	WaitMiliseconds //wait

					ldi COMMAND, 0x0d //BitFramingReg register
					ldi DATA, 0b00000000 //StartSend[7]=0
					rcall MFRC522Write 
					*/
					/*******MFRC522 Authentication******************/	



					/*******Read MFCrypto1On bit in Status2Reg******/
					/*
						ldi r16, 50
						rcall	WaitMiliseconds //wait

						ldi COMMAND, 0x08 //Status2Reg register
						rcall MFRC522Read ;output in DATA
						mov DATA3, DATA // Read Status2Reg Data byte with MFCrypto1On[3], ModemState[2:0]
						//rcall LCDwrite
					*/
					/*******Read MFCrypto1On bit in Status2Reg******/

			
		ldi r16, 1
		rcall	WaitMiliseconds //wait
	
rjmp main





MFRC522_settings:



ldi COMMAND, 0x01 //CommandReg register
ldi DATA, 0b00001111 //SoftReset
rcall MFRC522Write 



		ldi r16, 1
		rcall	WaitMiliseconds //wait


/*
ldi COMMAND, 0x2A //TModeReg register
ldi DATA, 0b10001101 //
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait

ldi COMMAND, 0x2B //TPrescalerReg register
ldi DATA, 0b00111110 //
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait

ldi COMMAND, 0x2D //TReloadReg register (lower bits)
ldi DATA, 0b00110000 //
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait


ldi COMMAND, 0x2C //TReloadReg register (higher bits)
ldi DATA, 0b00000000 //
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait

*/

ldi COMMAND, 0x15 //TxASKReg register
ldi DATA, 0b01000000 //
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait

ldi COMMAND, 0x11 //ModeReg register
ldi DATA, 0b00011101 //
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait


ldi COMMAND, 0x14 //TxControlReg register
ldi DATA, 0b01001001 //Antenna on
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait









/*
ldi COMMAND, 0x01 //CommandReg register
ldi DATA, 0b00000111 //RcvOff[5]=0, Command[3:0]=0111: NoCmdChange
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait	

ldi COMMAND, 0x0A //FIFOLevelReg register
ldi DATA, 0b10000000 //FlushBuffer[7]=1
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait

//ldi COMMAND, 0x0D //BitFramingReg register
//ldi DATA, 0b10000000 //StartSend[7]=1 (Use with Transceive command)
//rcall MFRC522Write 

		//ldi r16, 1
		//rcall	WaitMiliseconds //wait

//ldi COMMAND, 0x14 //TxControlReg register
//ldi DATA, 0b00000011 //InvTx2RFOn=0, InvTx1RFOn=0, InvTx2RFOff=0, InvTx1RFOff=0, Tx2CW=0, Tx2RFEn=1, Tx1RFEn=1
//rcall MFRC522Write 

		//ldi r16, 1
		//rcall	WaitMiliseconds //wait

//ldi COMMAND, 0x15 //TxASKReg register
//ldi DATA, 0b00000000 //Force100ASK[6]=0 do not force a 100% ASK modulation
					//independent of the ModGsPReg register setting
//rcall MFRC522Write 

		//ldi r16, 1
		//rcall	WaitMiliseconds //wait


ldi COMMAND, 0x16 //TxSelReg register
ldi DATA, 0b00010000 //Bit[5:4]=DriverSel[1:0]=01 modulation signal (envelope) from
					//the internal encoder, Miller pulse encoded
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait

ldi COMMAND, 0x17 //RxSelReg register
ldi DATA, 0b10000000 //Bit[7:6]=UARTSel[1:0]=10 modulated signal from
					//the internal analog module, default
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait


ldi COMMAND, 0x24 //ModWidthReg register
ldi DATA, 0b00001111 //ModWidth[7:0]=00001111 defines the width of the Miller modulation 
					//as multiples of the carrier
					//frequency (ModWidth + 1 / fclk)
					//the maximum value is half the bit period
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait

ldi COMMAND, 0x26 //RFCfgReg register
ldi DATA, 0b01000000 //Bit[6:4]=RxGain[2:0]=100 33dB
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait


ldi COMMAND, 0x27 //GsNReg register
ldi DATA, 0b00000111 //Bit[3:0]=ModGsN[3:0]=0111 defines the conductance of the output n-driver during periods without
					 //modulation which can be used to regulate the modulation index
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait


ldi COMMAND, 0x29 //ModGsPReg register
ldi DATA, 0b00000111 //Bit[5:0]=ModGsP[5:0]=000111 defines the conductance of the p-driver output during modulation
					 //which can be used to regulate the modulation index
rcall MFRC522Write 

		ldi r16, 1
		rcall	WaitMiliseconds //wait

//ldi COMMAND, 0x2A //TxModeReg register
//ldi DATA, 0b10000000 //Bit[7]=TAuto=1 timer starts automatically at the end of the transmission in
					 //all communication modes at all speeds
//rcall MFRC522Write 

		//ldi r16, 1
		//rcall	WaitMiliseconds //wait

//ldi COMMAND, 0x2B //TPrescalerReg register
//ldi DATA, 0b11111111 //TPrescaler_Lo[7:0]=11111111
//rcall MFRC522Write 

		//ldi r16, 1
		//rcall	WaitMiliseconds //wait


//ldi COMMAND, 0x2C //TReloadReg (higher bits) register
//ldi DATA, 0b11111111 //TReloadVal_Hi[7:0]=11111111
//rcall MFRC522Write 

		//ldi r16, 1
		//rcall	WaitMiliseconds //wait

//ldi COMMAND, 0x2D //TReloadReg (lower bits) register
//ldi DATA, 0b11111111 //TReloadVal_Lo[7:0]=11111111
//rcall MFRC522Write 

		//ldi r16, 1
		//rcall	WaitMiliseconds //wait

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


lsr DATA1 //
lsr DATA1 //
andi DATA1, 0b00111100 //masking data

 

;ldi DATA, 0b00111100
ori DATA1, 0b10000000
	mov r18, DATA1 //format RS:E:D7:D6:D5:D4:N/A:N/A
	;ldi r18, 0b10010000
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds


ori DATA1, 0b11000000
	mov r18, DATA1 //format RS:E:D7:D6:D5:D4:N/A:N/A
	;ldi r18, 0b11010000
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds

andi DATA1, 0b00111100
ori DATA1, 0b10000000
	mov r18, DATA1 //format RS:E:D7:D6:D5:D4:N/A:N/A
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


lsr DATA2
lsr DATA2
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


lsr DATA3
lsr DATA3
andi DATA3, 0b00111100 //this mask is for reading 1x seconds on ds1307

 



;ldi DATA, 0b00111100
ori DATA3, 0b10000000
	mov r18, DATA3 //format RS:E:D7:D6:D5:D4:N/A:N/A
	;ldi r18, 0b10010000
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds


ori DATA3, 0b11000000
	mov r18, DATA3 //format RS:E:D7:D6:D5:D4:N/A:N/A
	;ldi r18, 0b11010000
	rcall DAC
		ldi r16, 10
		rcall	WaitMiliseconds


andi DATA3, 0b00111100
ori DATA3, 0b10000000
	mov r18, DATA3 //format RS:E:D7:D6:D5:D4:N/A:N/A
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





;writes two bytes with the selected start register
MFRC522Write://(byte command, byte data){
 cbi PORTB, PB2 //clear ~SS
  //Obs!
	lsl COMMAND
	ori COMMAND, 0b00000000 //MSB=0 write, LSB=0 always
    mov r16, COMMAND //ex. COMMAND
	out SPDR, r16

	//while (!(SPSR & (1<<SPIF)))
    ;
    wait1:
	in r16,SPSR
	sbrs r16,SPIF
	rjmp wait1

	mov r16, DATA //ex. DATA
	out SPDR, r16
    
    //while (!(SPSR & (1<<SPIF)))
    ;
    wait2:
	in r16,SPSR
	sbrs r16,SPIF
	rjmp wait2
 sbi PORTB, PB2 //set ~SS
ret




;reads two bytes with the selected start register
MFRC522Read://(byte command){
 cbi PORTB, PB2 //clear ~SS
	mov ADDR0,COMMAND
	lsl ADDR0
	ori ADDR0, 0b10000000 //MSB=1 read, LSB=0 always
	mov r16, ADDR0 //ex. COMMAND or address 1
	out SPDR, r16

	//while (!(SPSR & (1<<SPIF)))
    ;
	
	
    wait3:
	in r16,SPSR
	sbrs r16,SPIF
	rjmp wait3
	
	

	in r16, SPDR //ex. dummy DATA or X don´t care read
	movw DATA, r16

	/*
	
	 //Obs!
	mov r16, COMMAND //ex. COMMAND or address 1
	out SPDR, r16

	//while (!(SPSR & (1<<SPIF)))
    ;
	
    wait4:
	in r16,SPSR
	sbrs r16,SPIF
	rjmp wait4
	

	in r16, SPDR //ex. DATA or data 0 read
	mov DATA, r16

	*/



	//or is a read like this?? slave config
	/*
	mov r16, COMMAND //ex. COMMAND or address 
	sts SPDR, r16

	
    wait5:
	lds r16,SPSR
	sbrs r16,SPIF
	rjmp wait5


	ldi r16, 0b00010000 //only PB4 [MISO] output SPI Slave
	sts DDRB, r16

	ldi r16, (1<<SPE)|(0<<MSTR) //init Slave SPI mode
	sts SPCR, r16

	 wait6:
	lds r16,SPSR
	sbrs r16,SPIF
	rjmp wait6

	lds r16, SPDR
	mov DATA, r16
	*/
 sbi PORTB, PB2 //set ~SS
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
	ldi		XH, HIGH(DVUS(1))//M?ste Kalibreras
	ldi		XL, LOW(DVUS(1))//M?ste Kalibreras
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
	ldi		XH, HIGH(DVUS(1)) //M?ste kalibreras
	ldi		XL, LOW(DVUS(1)) //M?ste kalibreras
	sbi		OW_DDR, OW_DQ
	rcall	Wait4xCycles
	cbi		OW_DDR, OW_DQ
	ldi		XH, HIGH(DVUS(1)) //1.5 kohm optimal pull-up. Kalibrera s? att sampling inte sker f?rsent, 1us-2us tRD - READ VALID, pga oexakta tider, oscilloskop!
	ldi		XL, LOW(DVUS(1)) //1.5 kohm optimal pull-up. Kalibrera s? att sampling inte sker f?rsent,  1us-2us tRD - READ VALID, pga oexakta tider, oscilloskop!
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
	ldi		XH, HIGH(DVUS(8)) //Kolla s? att sampling inte sker f?rsent, max 15us tRD - READ VALID, pga oexakta tider, oscilloskop!
	ldi		XL, LOW(DVUS(8)) //Kolla s? att sampling inte sker f?rsent, max 15us tRD - READ VALID, pga oexakta tider, oscilloskop!
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


