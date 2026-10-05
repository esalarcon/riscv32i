# 0 "ejemplo.c"
# 1 "/home/juan/Descargas/riscv32i_ra10-main/software//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "ejemplo.c"




# 1 "/usr/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint.h" 1 3 4
# 34 "/usr/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint.h" 3 4

# 34 "/usr/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint.h" 3 4
typedef signed char int8_t;


typedef short int int16_t;


typedef long int int32_t;


typedef long long int int64_t;


typedef unsigned char uint8_t;


typedef short unsigned int uint16_t;


typedef long unsigned int uint32_t;


typedef long long unsigned int uint64_t;




typedef signed char int_least8_t;
typedef short int int_least16_t;
typedef long int int_least32_t;
typedef long long int int_least64_t;
typedef unsigned char uint_least8_t;
typedef short unsigned int uint_least16_t;
typedef long unsigned int uint_least32_t;
typedef long long unsigned int uint_least64_t;



typedef int int_fast8_t;
typedef int int_fast16_t;
typedef int int_fast32_t;
typedef long long int int_fast64_t;
typedef unsigned int uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned int uint_fast32_t;
typedef long long unsigned int uint_fast64_t;




typedef int intptr_t;


typedef unsigned int uintptr_t;




typedef long long int intmax_t;
typedef long long unsigned int uintmax_t;
# 6 "ejemplo.c" 2

# 6 "ejemplo.c"
uint32_t leds = 1;
uint32_t espera;

void desplaza_led(void)
{
 if(leds >= 0x80) leds = 1;
 else leds <<= 1;
}

int main(void)
{
 volatile int *puerto_salida = (volatile int*)(0x2000);
 espera = (3);
 while(1)
 {
  *puerto_salida = leds;
  if(!--espera)
  {
   espera = (3);
   desplaza_led();
  }






  asm("wfi");
 }
 return 0;
}
