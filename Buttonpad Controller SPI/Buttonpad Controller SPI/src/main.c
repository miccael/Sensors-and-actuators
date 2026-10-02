/**
 * \file
 *
 * \brief Empty user application template
 *
 */

/**
 * \mainpage User Application template doxygen documentation
 *
 * \par Empty user application template
 *
 * Bare minimum empty user application template
 *
 * \par Content
 *
 * -# Include the ASF header files (through asf.h)
 * -# "Insert system clock initialization code here" comment
 * -# Minimal main function that starts with a call to board_init()
 * -# "Insert application code here" comment
 *
 */

/*
 * Include header files for all drivers that have been imported from
 * Atmel Software Framework (ASF).
 */
#include <asf.h>
#include <avr/io.h>
#define F_CPU 128000UL
#include <util/delay.h>
#include <stdio.h>

#define SS 2
#define SCK 5

int j=0;
int rxdata[64];
int startdata[] =
{0x00,0x00,0x00,0x00,0x0F,0x0F,0x0F,0x0F,0x0F,0x0F,0x0F,0x0F,0x08,0x08,0x08,0x08, //Red Frame
 0x0F,0x0F,0x0F,0x0F,0x0F,0x0F,0x0F,0x0F,0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x00, //Blue Frame
 0x0F,0x0F,0x0F,0x0F,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x08,0x08,0x08,0x08, //Green Frame
 0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01  //Button Frame
};

int txdata[64];



void SPI_MasterTransmit(int tx[]);


int main (void)
{
	
	// Insert system clock initialization code here (sysclk_init()).

	board_init();
	
	//********************SPI init*********************************************
	
	//clock division factor 256
	CLKPR= (1<<CLKPS3)|(0<<CLKPS2)|(0<<CLKPS1)|(0<<CLKPS0);
	DDRB = DDRB | 0b00101100; //PB5 [SCK], PB3 [MOSI]
	PORTB &= ~(1<<PB4);
	//PB2 [~SS] output
	//PB4 [MISO] input
	PORTB |= (1<<SCK); // [SCK] high to begin with
	
	/* Enable SPI, LSB first, Master, CPOL=1 high idle, set clock rate fck/64 */
	SPCR = (1<<SPE)|(1<<DORD)|(1<<MSTR)|(1<<CPOL)|(1<<CPHA)|(1<<SPR1)|(0<<SPR0);
	SPSR = (0<<SPI2X);
	
	//*******************End of SPI init******************************************
	
	
	
	// Use this function from delay.h to delay for 4 seconds
	_delay_ms(40);
	PORTB |= (1<<SS); // [~SS] high transmission begins
	// Use this function from delay.h to delay for 4 seconds
	_delay_ms(40);
	
	SPI_MasterTransmit(startdata);
	
	// Use this function from delay.h to delay for 4 seconds
	_delay_ms(40);
	PORTB &= ~(1<<SS);// [~SS] low transmission stops
	// Use this function from delay.h to delay for 4 seconds
	_delay_ms(8000);
	
	
	
	while (true)
	{
		
		
		
		// Use this function from delay.h to delay for 4 seconds
		_delay_ms(40);
		PORTB |= (1<<SS); // [~SS] high transmission begins
		// Use this function from delay.h to delay for 4 seconds
		_delay_ms(40);
		
		SPI_MasterTransmit(txdata);
		
		// Use this function from delay.h to delay for 4 seconds
		_delay_ms(40);
		PORTB &= ~(1<<SS);// [~SS] low transmission stops
		// Use this function from delay.h to delay for 4 seconds
		_delay_ms(40);
		
		j++;
		
		if (j==26)
		{
			for(int i=0;i<65;i++){
				txdata[i]=0x00;
			}
			j=0;
		}
		
		for (int i=48;i<64;i++)
		{
			if(rxdata[i]==0x00)
			{
				int r = i-48;
				int b = i-32;
				int g = i-16;
				txdata[r]=0x0F;
				txdata[b]=0x00;
				txdata[g]=0x0F;
			}
		}
		
		
	}
	

	return 1;
	

	// Insert application code here, after the board has been initialized.
}


void SPI_MasterTransmit(int tx[]) {
	
	for(int i=0;i<65;i++){
		
		
		/* Start transmission */
		SPDR = tx[i];
		/* Wait for transmission complete */
		while(!(SPSR & (1<<SPIF)))
		;
		
		rxdata[i]=SPDR;
		
		/*if ((rxdata[i]==0x00) && (i>=48))
		{
			txdata[i-16]=0xFF;
		}
		*/
		
	}
	
	
	
}

