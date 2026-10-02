/*
 MCP23008 I2C BCD to 7-segment
*/



//------ATmega 328 pins----------
//#define SDA 27
//#define SCL 28
//-----------------------------

byte SLA_W = 0x40; //slave adress, 0x20 and W=0
byte START = 0x08;
byte MT_SLA_ACK = 0x18;
byte MT_DATA_ACK = 0x28;


void setup(){
  
  //------------SCL speed-----------
  TWBR = 0xFF;
  TWSR = (1<<TWPS1)|(1<<TWPS0); //Prescaler 64
  //--------------------------------



delay(50);                                                   
transmit(0x00,0x0F); //MCP23008 IODIR, GP7~GP4 output,
                     //GP3~GP0 inputs
delay(50);
delay(50);                                                   
transmit(0x05,0x04); //MCP23008 IOCON, INT pin Open-drain output
delay(50);
delay(50);                                                   
transmit(0x06,0x0F); //MCP23008 GPPU, GP3~GP0 pull-ups.
delay(50);




}

void loop(){
  //do other stuff here
delay(500);                                                   
transmit(0x09,0b00000000); //MCP23008 GPIO
delay(500);

delay(500);                                                   
transmit(0x09,0b00010000); //MCP23008 GPIO
delay(500);

delay(500);                                                   
transmit(0x09,0b00100000); //MCP23008 GPIO
delay(500);

delay(500);                                                   
transmit(0x09,0b00110000); //MCP23008 GPIO
delay(500);

delay(500);                                                   
transmit(0x09,0b01000000); //MCP23008 GPIO
delay(500);

delay(500);                                                   
transmit(0x09,0b01010000); //MCP23008 GPIO
delay(500);

delay(500);                                                   
transmit(0x09,0b01100000); //MCP23008 GPIO
delay(500);

delay(500);                                                   
transmit(0x09,0b01110000); //MCP23008 GPIO
delay(500);

delay(500);                                                   
transmit(0x09,0b10000000); //MCP23008 GPIO
delay(500);

delay(500);                                                   
transmit(0x09,0b10010000); //MCP23008 GPIO
delay(500);
   
}

void ERROR(){
}

void transmit(byte adr, byte d0) {
  
TWCR = (1<<TWINT)|(1<<TWSTA)|(1<<TWEN); //START bit

while (!(TWCR&(1<<TWINT)));

if ((TWSR&0xF8)!= START)
ERROR();


TWDR = SLA_W;
TWCR = (1<<TWINT)|(1<<TWEN);

while (!(TWCR&(1<<TWINT)));

if ((TWSR&0xF8)!=MT_SLA_ACK)
ERROR();

//---------------------
TWDR = adr; //
TWCR = (1<<TWINT)|(1<<TWEN);

while (!(TWCR&(1<<TWINT)));

if ((TWSR&0xF8)!=MT_DATA_ACK)
ERROR();
//-------------------------

//---------------------
TWDR = d0; //
TWCR = (1<<TWINT)|(1<<TWEN);

while (!(TWCR&(1<<TWINT)));

if ((TWSR&0xF8)!=MT_DATA_ACK)
ERROR();
//-------------------------


TWCR = (1<<TWINT)|(1<<TWEN)|(1<<TWSTO); //STOP bit

}



