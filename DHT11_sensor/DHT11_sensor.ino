//mono saw out with 44.1kHz sampling rate
//by Amanda Ghassaei
//Nov 2012
//http://www.instructables.com/id/Stereo-Audio-with-Arduino/

/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
*/

// Install the interrupt routine.
ISR(INT0_vect) {
  digitalWrite(8,HIGH);
  delay(20000);
  // activate the interrupt routine, we get a clear signal.
  //value = digitalRead(2);
  
}

void setup(){
  
  
  //-------------System Clock---------------
  CLKPR=B10000000;
  CLKPR=B00000011; //Prescaler 8
  //----------------------------------------
  
  //-------------Interrupt INT0 init-------------
 pinMode(2, INPUT); //INT0
 EICRA = (1<<ISC01)|(1<<ISC00); // interrupt on rising edge,INT0
                                   //
// SREG = B10000000;             // Global interrupt enable
 EIMSK = (1<<INT0);            // Enable interrupt on INT0
 
//------------------------------------
 
 pinMode(8, OUTPUT);
  digitalWrite(8,LOW); 
  }



void loop(){
  //do other stuff here
  //-------------Timer0 start-------------
 TCCR0A = (0<<COM0A1)|(0<<COM0A0)|(1<<WGM01)|(0<<WGM00); //Normal port operation
                                   //CTC mode
                                   //
 TCCR0B = (0<<FOC0A)|(0<<FOC0B)|(0<<WGM02)|(0<<CS02)|(0<<CS01)|(1<<CS00);
                                    //clkI/O (No prescaler)
 TCNT0=0x00;
 OCR0A=0x28; //40us
 //TOP = 0xFF;
//------------------------------------

//-------------Timer0 stop-------------
 
 TCCR0B = (0<<FOC0A)|(0<<FOC0B)|(0<<WGM02)|(0<<CS02)|(0<<CS01)|(0<<CS00);
                                    //No clock source Timer/Counter stopped
 
//------------------------------------

digitalWrite(8,HIGH);
     //-------------Timer0 start-------------
 TCCR0A = (0<<COM0A1)|(0<<COM0A0)|(1<<WGM01)|(0<<WGM00); //Normal port operation
                                   //CTC mode
                                   //
 TCCR0B = (0<<FOC0A)|(0<<FOC0B)|(0<<WGM02)|(0<<CS02)|(0<<CS01)|(1<<CS00);
                                    //clkI/O (No prescaler)
 TCNT0=0x00;
 OCR0A=0x28; //40us
 //TOP = 0xFF;
//------------------------------------

//-------------Timer0 stop-------------
 
 TCCR0B = (0<<FOC0A)|(0<<FOC0B)|(0<<WGM02)|(0<<CS02)|(0<<CS01)|(0<<CS00);
                                    //No clock source Timer/Counter stopped
 
//------------------------------------

     digitalWrite(8,LOW); 
     
   }





