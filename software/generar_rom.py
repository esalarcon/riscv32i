def leer_word(fname, n_bytes):
	opcodes = []
	f = open(fname,'rb')
	while True:
		data = f.read(n_bytes)
		if len(data)<n_bytes:
			return opcodes
		else:
			i_data = 0
			for i,v in enumerate(data):
				i_data += v<<(i*8)
			opcodes.append('{:08x}'.format(i_data))
	f.close()

import math as m

def imprimir_codigo(programa, min_bits_len, n_bytes, valor_por_defecto = '00000013'):
	nbits = m.ceil(m.log2(len(programa)))
	if nbits<min_bits_len:
		nbits = min_bits_len
	len_cuadrado = 2**nbits
	espacios = len(str(len(programa)))
	len_palabra = n_bytes*8

	print('library IEEE;')
	print('use IEEE.STD_LOGIC_1164.ALL;')
	print('use IEEE.NUMERIC_STD.ALL;')
	print('entity programa is')
	print('   Port ( clk   : in    STD_LOGIC;')
	print('          addra : in    STD_LOGIC_VECTOR ({0:2} downto 0);'.format(nbits-1))
	print('          addrb : in    STD_LOGIC_VECTOR ({0:2} downto 0);'.format(nbits-1))
	print('          douta : out   STD_LOGIC_VECTOR ({0:2} downto 0);'.format(len_palabra-1))
	print('          doutb : out   STD_LOGIC_VECTOR ({0:2} downto 0));'.format(len_palabra-1))
	print('end programa;')
	print('')
	print('architecture Behavioral of programa is')
	print('   type memoria_rom is array (natural range <>) of std_logic_vector({0:2} downto 0);'.format(len_palabra-1))
	print('   function inicializar_rom return memoria_rom is')
	print('      variable ret : memoria_rom({0} downto 0) := (others => x"{1}");'.format(len_cuadrado-1,valor_por_defecto))
	print('   begin')
	
	for i,v in enumerate(programa):
		str_memoria = '      ret({0: >' + str(espacios) + '}) := x"{1}";'
		print(str_memoria.format(i,v))	
	print('      return ret;')	
	print('   end inicializar_rom;')
	print('   signal rom : memoria_rom({0} downto 0) := inicializar_rom;'.format(len_cuadrado-1))	
	print('begin')
	print('   process(clk)')
	print('      variable ia : natural range 0 to {0};'.format(len_cuadrado-1))
	print('      variable ib : natural range 0 to {0};'.format(len_cuadrado-1))
	print('   begin')
	print('      if(rising_edge(clk)) then')
	print('         ia := to_integer(unsigned(addra));')
	print('         ib := to_integer(unsigned(addrb));')
	print('         douta <= rom(ia);')
	print('         doutb <= rom(ib);')
	print('      end if;')
	print('   end process;')
	print('end Behavioral;')
 
import sys
archivo = sys.argv[1]
#ruta = 'C:/Users/Usuario/Downloads/juan/riscv32i_ra10/software/'
#archivo = ruta + 'ejemplo.bin'
#salida =  ruta + 'programa.vhd'
#sys.stdout = open(salida, 'w')
n_bytes = 4						# Cantidad de bytes por instrucción (core rv32i)
min_bits = 11					# Tamanio minimo del bus de la memoria de programa
valor_por_defecto='00000013' 	# addi x0,x0,0
imprimir_codigo(leer_word(archivo, n_bytes), min_bits, n_bytes, valor_por_defecto)
#sys.stdout.close()
