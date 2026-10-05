#define PUERTO		(0x2000)
#define __wfi()	asm("wfi")

#define TICS_ESPERA	(3)
#include <stdint.h>
uint32_t leds = 1;
uint32_t espera;

void desplaza_led(void)
{
	if(leds >= 0x80) leds = 1;
	else leds <<= 1;	
}

int main(void)
{
	volatile int *puerto_salida  = (volatile int*)PUERTO;
	espera = TICS_ESPERA;
	while(1)
	{
		*puerto_salida = leds;
		if(!--espera)
		{
			espera = TICS_ESPERA;
			desplaza_led();		
		}
		/*
		 *	Duermo el procesador hasta que se ponga en uno
		 *	el pin wake_up. Eso sucede periodicamente.
		 *	uso wfi o cualquier instrucción especial 
		 *	(ecall, ebreak, etc).
		 */
		__wfi();
	}
	return 0;
}

