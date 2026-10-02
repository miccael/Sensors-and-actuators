
 
// Pin 13 has an LED connected on most Arduino boards.
// give it a name:
//int led = 13;

void USART_Init( void );
void SpeakJetInit(void);
void USART_Transmit_MSA( int data );
void USART_Transmit_SCM( char letter );
void USART_Program_EEPROM_addr(char a0, char a1, char w0, char w1);

// the setup routine runs once when you press reset:
void setup() {     


 USART_Init();
SpeakJetInit();

USART_Transmit_SCM('T');//Start Enunciating

 USART_Transmit_SCM('\\');
 USART_Transmit_SCM('1');
 USART_Transmit_SCM('0');
 USART_Transmit_SCM('H');
 USART_Transmit_SCM('0');
 USART_Transmit_SCM('J');
 USART_Transmit_SCM('5');
 USART_Transmit_SCM('0');
 USART_Transmit_SCM('0');
 USART_Transmit_SCM('N');
// 
 USART_Transmit_SCM('0');
 USART_Transmit_SCM('H');
 USART_Transmit_SCM('1');
 USART_Transmit_SCM('J');
 USART_Transmit_SCM('1');
 USART_Transmit_SCM('0');
 USART_Transmit_SCM('0');
 USART_Transmit_SCM('0');
 USART_Transmit_SCM('N');
//
 USART_Transmit_SCM('0');
 USART_Transmit_SCM('H');
 USART_Transmit_SCM('8');
 USART_Transmit_SCM('J');
 USART_Transmit_SCM('6');
 USART_Transmit_SCM('6');
 USART_Transmit_SCM('N');
//
 USART_Transmit_SCM('0');
 USART_Transmit_SCM('H');
 USART_Transmit_SCM('1');
 USART_Transmit_SCM('1');
 USART_Transmit_SCM('J');
 USART_Transmit_SCM('2');
 USART_Transmit_SCM('0');
 USART_Transmit_SCM('N');
 
  USART_Transmit_SCM('X');//Exit
 
 delay(1000);

 
//  delay(100);
//  USART_Transmit_MSA( 31 );//Reset Defaults
  
//  delay(100);
//  USART_Transmit_MSA( 165 );
// delay(100);
// USART_Transmit_MSA( 128 );
// delay(100);
// USART_Transmit_MSA( 188 );
// delay(100);
// USART_Transmit_MSA( 139 );
// delay(100);
// USART_Transmit_MSA( 187 );
// delay(100);
//
// USART_Transmit_MSA( 20 );
// delay(100);
//  USART_Transmit_MSA( 96 );
// delay(100);
//
// USART_Transmit_MSA( 250 );
// delay(100);



 /*
//Goto Phrase, X (Call adress pointer in EEPROM)
delay(100);
  USART_Transmit_MSA( 29 ); 
 delay(100);
 USART_Transmit_MSA( 2 );
 delay(100);
 */
 
   
  // initialize the digital pin as an output.
 // pinMode(led, OUTPUT);     
}

// the loop routine runs over and over again forever:
void loop() {
 
  delay(1000);               // wait for a second
}

void USART_Init( void ) //configured for 9600 baud @ fosc 16 MHz
{
  UBRR0=0;

/* Setting the XCKn port pin as output, enables master mode. */
DDRD |= (1<<DDD4);
/* Synchronous USART, no parity, 1 stop bit, 8 bit character size, LSB first
(if MSPIM activated)*/
//UCSR0C = (0<<UMSEL01)|(1<<UMSEL00)|(1<<UDORD0)|(1<<UCPHA0)|(0<<UCPOL0);
UCSR0C = (0<<UMSEL01)|(0<<UMSEL00)|(0<<UPM01)|(0<<UPM00)|(0<<USBS0);
/* Enable receiver and transmitter. */
UCSR0B = (1<<RXEN0)|(1<<TXEN0);
/* Set baud rate. */
/* IMPORTANT: The Baud Rate must be set after the transmitter is enabled
*/
//UBRR0=832;
UBRR0=103;


}


void SpeakJetInit(void)
{
  
//The SpeakJet has 64-byte input buffer, SCP har 16-byte input buffer 



/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = '\\';//Enter Serial Control Mode to use Serial Control Protocol
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = '0';//Enter Serial Control Mode to use Serial Control Protocol
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = 'R';//Clear Buffer
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = 'V';//
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = 'S';//Stop Enunciating, VERY IMPORTANT IN SpeakJetINIT!
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = '0'; //Store Memory Type, Write a synthesizer register's value.
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = 'H'; //Store Memory Type, Write a synthesizer register's value
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = '7';//Store Memory Address, Master Volume 0~255
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = 'J'; //Store Memory Address, Master Volume 0~255
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = '1'; //Store Memory
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = '0';//Store Memory
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = '0';//Store Memory
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = 'N'; //Store Memory
delay(10);





////*****************VIKTIGT*******************************
////DÅ EEPROM adress ska skrivas så skrivs de i 2-siffrors hex characters. 
////Till exempel om jag vill skriva Sound Allophone code 128 till
////EEPROM address 16, så måste jag först översätta code till hex 80.
////Sedan kan jag sända characters (UDR0=*X') enligt
//// '1' '6' 'J' '3' '2' 'H' '8' '0' 'N'
////******************************************************
//
////*****************************************************
////Detta gäller inte då du skriver till det 16 byte stora Synthesizer Registers
////Då Används SCP, '0' 'H' som minnestyp, och du skriver i dec characters
//// till exempel '1' '2' '3'.
//
//
//
//// EEPROM REG 237
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '7'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'J'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'H'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '7'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '1'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'N'; 
//delay(10);
//
////EEPROM REG 238
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '8'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'J'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'H'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'F'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'N'; 
//delay(10);
//
//
////EEPROM REG 239
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '9'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'J'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'H'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );//Will respond on SCP Node 1
///* Put data into buffer, sends the data */
//UDR0 = '9'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );//Will respond on SCP Node 1
///* Put data into buffer, sends the data */
//UDR0 = 'F'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'N'; 
//delay(10);
//
//
////EEPROM REG 240 Event input E0 Low to High Transitions
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '4'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '0'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'J'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'H'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'N'; 
//delay(10);
//
//
////EEPROM REG 241 Event input E0 High to Low Transitions
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '4'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '1'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'J'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'H'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'N'; 
//delay(10);
//
//
//
////EEPROM REG 242 Event input E1 Low to High Transitions
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '4'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'J'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'H'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '1'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'N'; 
//delay(10);
//
//
////EEPROM REG 243 Event input E1 High to Low Transitions
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '4'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'J'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'H'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '1'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'N'; 
//delay(10);
//
//
//
//
////EEPROM Reg 1
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '1';
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'J';
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3';
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2';
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'H'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2'; //adr dec 40
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '8'; //adr dec 40
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'N'; 
//delay(10);
//
//
//USART_Program_EEPROM_addr('4', '0', '8', 'C');
//USART_Program_EEPROM_addr('4', '1', '9', 'B');
//USART_Program_EEPROM_addr('4', '2', '0', '0');
//USART_Program_EEPROM_addr('4', '3', 'C', '5');
//USART_Program_EEPROM_addr('4', '4', '0', '1');
//USART_Program_EEPROM_addr('4', '5', '9', 'F');
//USART_Program_EEPROM_addr('4', '6', 'F', 'F');
//
//
//
//
////EEPROM Reg 0 EEPROM Address Pointer Area
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '0';
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'J';
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3';
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2';
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'H'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '1'; //adr dec 20
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '4'; //adr dec 20
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'N'; //adr dec 20
//delay(10);
//
//USART_Program_EEPROM_addr('2', '0', 'A', '5');
//USART_Program_EEPROM_addr('2', '1', '8', '0');
//USART_Program_EEPROM_addr('2', '2', 'B', 'C');
//USART_Program_EEPROM_addr('2', '3', '8', 'B');
//USART_Program_EEPROM_addr('2', '4', 'B', 'B');
//USART_Program_EEPROM_addr('2', '5', 'F', 'F');
//
////EEPROM Reg 2
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2';
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'J';
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '3';
//delay(100);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '2';
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'H'; 
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = '1'; //adr dec 22
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'E'; //adr dec 30
//delay(10);
///* Wait for empty transmit buffer */
//while ( !( UCSR0A & (1<<UDRE0)) );
///* Put data into buffer, sends the data */
//UDR0 = 'N'; //adr dec 30
//delay(10);
//
//USART_Program_EEPROM_addr('3', '0', '8', '3');
//USART_Program_EEPROM_addr('3', '1', 'A', '5');
//USART_Program_EEPROM_addr('3', '2', '8', '0');
//USART_Program_EEPROM_addr('3', '3', '9', '5');
//USART_Program_EEPROM_addr('3', '4', '8', '0');
//USART_Program_EEPROM_addr('3', '5', '0', '1');
//USART_Program_EEPROM_addr('3', '6', 'A', 'B');
//USART_Program_EEPROM_addr('3', '7', '0', '1');
//USART_Program_EEPROM_addr('3', '8', 'F', 'F');
  
}

//000-255 direct to MSA
void USART_Transmit_MSA( int data )
{
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = data;
}

void USART_Transmit_SCM( char letter )
{
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = letter;
delay(10);
}

void USART_Program_EEPROM_addr(char a0, char a1, char w0, char w1)
{
//EEPROM Reg a0a1
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = a0;
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = a1;
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = 'J';
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = '3';
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = '2';
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = 'H'; 
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = w0; 
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = w1; 
delay(10);
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE0)) );
/* Put data into buffer, sends the data */
UDR0 = 'N'; 
delay(10);
}
