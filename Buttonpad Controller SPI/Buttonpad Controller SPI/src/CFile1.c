/*
 * CFile1.c
 *
 * Created: 2014-07-06 00:46:44
 *  Author: Mikael
 */ 

#include <avr/io.h>

int main(void)
{
	// Set Port B pins as all outputs
	DDRB = 0xff;

	// Set all Port B pins as HIGH
	PORTB = 0xff;

	return 1;
}