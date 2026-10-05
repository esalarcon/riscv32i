RISCV_TOOLS_PREFIX = riscv64-unknown-elf-

CC      = $(RISCV_TOOLS_PREFIX)gcc
AS      = $(RISCV_TOOLS_PREFIX)as
LD      = $(RISCV_TOOLS_PREFIX)ld
OBJCOPY = $(RISCV_TOOLS_PREFIX)objcopy
OBJDUMP = $(RISCV_TOOLS_PREFIX)objdump
SIZE    = $(RISCV_TOOLS_PREFIX)size

# Arquitectura
ARCH = rv32i
ABI  = ilp32

# Compilación
CCFLAGS = -march=$(ARCH) -mabi=$(ABI) \
          -g -ffreestanding -O0 \
          -nostdlib -nostartfiles

# Linker
LDFLAGS = -Wl,-T,micro_juan.ld

ejemplo:
	$(CC) $(CCFLAGS) -E ejemplo.c -o ejemplo.i

	$(CC) $(CCFLAGS) -S ejemplo.c -o ejemplo.s

	$(CC) $(CCFLAGS) -c ejemplo.c -o ejemplo.o

	$(CC) $(CCFLAGS) $(LDFLAGS) \
		start_juan.s ejemplo.o \
		-o ejemplo.out

	$(OBJDUMP) -d -M no-aliases \
		ejemplo.out > ejemplo.lst

	$(OBJCOPY) -O binary \
		ejemplo.out ejemplo.bin

	python3 generar_rom.py ejemplo.bin > ejemplo.vhd

	$(SIZE) ejemplo.out

clean:
	rm -f *.o
	rm -f *.out
	rm -f *.bin
	rm -f *.vhd
	rm -f *.i
	rm -f *.s
	rm -f *.lst
