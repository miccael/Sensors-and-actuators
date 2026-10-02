/*
 * 74HC595.c
 *
 * Created: 2017-05-04 02:13:02
 * Author : Mikael Glans
 * 
 */ 
#define F_CPU 128000UL
#include <avr/io.h>
#include <util/delay.h>
void PWM_init(void);
void ADC_Init(void);
void SPI_MasterInit(void);
void SPI_MasterTransmit(char spiData);
char spiDATA;



int main(void)
{
	PRR = (0<<PRADC)|(0<<PRSPI);   //Power Reduction Register
	//PWM_init();
	ADC_Init();
	 /*1. OBS only single conversion init,
	 you must write 1 to ADSC every time
	 you need a conversion.
	 2. How to change the CKDIV8 option?
	 3. Think about the sample rate!*/ 
                               
	SPI_MasterInit();

  
    while (1) 
    {
		ADCSRA = (1<<ADEN)|(1<<ADSC)|(0<<ADATE)|(1<<ADIF)|(0<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
		while(!(ADCSRA & (1<<ADIF)))
		;
	
		
		spiDATA = ADCH;
		_delay_ms(200);
		SPI_MasterTransmit(spiDATA);
		_delay_ms(200);
		
		
    }
}

void PWM_init(void){
	
	PORTD = (1<<PD6);
	DDRD = (1<<PD6);
	TCCR0A = (0<<COM0A1)|(1<<COM0A0)|(0<<WGM01)|(1<<WGM00);
	//Toggle OC0A on Compare Match
	TCCR0B = (1<<WGM02)|(0<<CS02)|(0<<CS01)|(1<<CS00);
	//clkIO/(No prescaling)
	OCR0A = 0x00;


	PORTB = (1<<PB1);
	DDRB = (1<<PB1);
	TCCR1A = (0<<COM1A1)|(1<<COM1A0)|(0<<WGM11)|(1<<WGM10);
	//
	TCCR1B = (1<<WGM13)|(0<<WGM12)|(0<<CS12)|(0<<CS11)|(1<<CS10);
	//clkIO/1(No prescaling)
	OCR1AL = 0x80;
	OCR1AH = 0x80;	
	
}

void ADC_Init(void) {
	
	ADMUX = (0<<REFS1)|(1<<REFS0)|(1<<ADLAR)|(0<<MUX3)|(0<<MUX2)|(0<<MUX1)|(0<<MUX0);
	//AVcc with external
	//capacitor at the AREF pin
	//left adjusted result
	//ADC0, PC0 single ended input.
	DIDR0 = (1<<ADC0D); //disable digital input buffer on ADC0.
	ADCSRA = (1<<ADEN)|(0<<ADSC)|(0<<ADATE)|(1<<ADIF)|(0<<ADPS2)|(0<<ADPS1)|(1<<ADPS0);
	//enable ADC, start single conversion, no auto triggering,
	//clear ADIF flag, division factor 2 (=ADC freq 64kHz if CKDIV8 is cleared)
	//(ADC frequency not recommended higher than 200kHz).
	ADCSRB = (0<<ACME)|(0<<ADTS2)|(0<<ADTS1)|(0<<ADTS0);
	//ACME used for Analog Comparator ADMUX purposes, deactivated
	//Free Running mode change with ADATE.
	
}

void SPI_MasterInit(void) {
	
	DDRB = (1<<PB5)|(0<<PB4)|(1<<PB3)|(1<<PB2); //PB5 [SCK], PB3 [MOSI]
	//PB2 [~SS] output
	//PB4 [MISO] input
	//OBS! crucial to do this
	//pin direction step!
	
	
	/* Enable SPI, MSB first, Master, set clock rate fosc/128 */
	SPCR = (1<<SPE)|(0<<DORD)|(1<<MSTR)|(0<<CPOL)|(0<<CPHA)|(1<<SPR1)|(1<<SPR0);
	SPSR = (0<<SPI2X);
}


void SPI_MasterTransmit(char spiData) {
	
	/* Start transmission */
	SPDR = spiData;
	/* Wait for transmission complete */
	while(!(SPSR & (1<<SPIF)))
	;
}

