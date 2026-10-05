	.file	"ejemplo.c"
	.option nopic
	.attribute arch, "rv32i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/juan/Descargas/riscv32i_ra10-main/software" "ejemplo.c"
	.globl	leds
	.section	.sdata,"aw"
	.align	2
	.type	leds, @object
	.size	leds, 4
leds:
	.word	1
	.globl	espera
	.section	.sbss,"aw",@nobits
	.align	2
	.type	espera, @object
	.size	espera, 4
espera:
	.zero	4
	.text
	.align	2
	.globl	desplaza_led
	.type	desplaza_led, @function
desplaza_led:
.LFB0:
	.file 1 "ejemplo.c"
	.loc 1 10 1
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	ra,12(sp)
	sw	s0,8(sp)
	.cfi_offset 1, -4
	.cfi_offset 8, -8
	addi	s0,sp,16
	.cfi_def_cfa 8, 0
	.loc 1 11 10
	lui	a5,%hi(leds)
	lw	a4,%lo(leds)(a5)
	.loc 1 11 4
	li	a5,127
	bleu	a4,a5,.L2
	.loc 1 11 24 discriminator 1
	lui	a5,%hi(leds)
	li	a4,1
	sw	a4,%lo(leds)(a5)
	.loc 1 13 1
	j	.L4
.L2:
	.loc 1 12 12
	lui	a5,%hi(leds)
	lw	a5,%lo(leds)(a5)
	slli	a4,a5,1
	lui	a5,%hi(leds)
	sw	a4,%lo(leds)(a5)
.L4:
	.loc 1 13 1
	nop
	lw	ra,12(sp)
	.cfi_restore 1
	lw	s0,8(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 16
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE0:
	.size	desplaza_led, .-desplaza_led
	.align	2
	.globl	main
	.type	main, @function
main:
.LFB1:
	.loc 1 16 1
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sw	ra,28(sp)
	sw	s0,24(sp)
	.cfi_offset 1, -4
	.cfi_offset 8, -8
	addi	s0,sp,32
	.cfi_def_cfa 8, 0
	.loc 1 17 16
	li	a5,8192
	sw	a5,-20(s0)
	.loc 1 18 9
	lui	a5,%hi(espera)
	li	a4,3
	sw	a4,%lo(espera)(a5)
.L7:
	.loc 1 21 18
	lui	a5,%hi(leds)
	lw	a5,%lo(leds)(a5)
	mv	a4,a5
	lw	a5,-20(s0)
	sw	a4,0(a5)
	.loc 1 22 7
	lui	a5,%hi(espera)
	lw	a5,%lo(espera)(a5)
	addi	a4,a5,-1
	.loc 1 22 5
	lui	a5,%hi(espera)
	sw	a4,%lo(espera)(a5)
	.loc 1 22 7
	lui	a5,%hi(espera)
	lw	a5,%lo(espera)(a5)
	.loc 1 22 5
	bne	a5,zero,.L6
	.loc 1 24 11
	lui	a5,%hi(espera)
	li	a4,3
	sw	a4,%lo(espera)(a5)
	.loc 1 25 4
	call	desplaza_led
.L6:
	.loc 1 33 3
 #APP
# 33 "ejemplo.c" 1
	wfi
# 0 "" 2
	.loc 1 21 18
 #NO_APP
	j	.L7
	.cfi_endproc
.LFE1:
	.size	main, .-main
.Letext0:
	.file 2 "/usr/lib/gcc/riscv64-unknown-elf/14.2.0/include/stdint.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0xdc
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.uleb128 0x3
	.4byte	.LASF13
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	.Ldebug_line0
	.uleb128 0x1
	.byte	0x1
	.byte	0x6
	.4byte	.LASF2
	.uleb128 0x1
	.byte	0x2
	.byte	0x5
	.4byte	.LASF3
	.uleb128 0x1
	.byte	0x4
	.byte	0x5
	.4byte	.LASF4
	.uleb128 0x1
	.byte	0x8
	.byte	0x5
	.4byte	.LASF5
	.uleb128 0x1
	.byte	0x1
	.byte	0x8
	.4byte	.LASF6
	.uleb128 0x1
	.byte	0x2
	.byte	0x7
	.4byte	.LASF7
	.uleb128 0x4
	.4byte	.LASF14
	.byte	0x2
	.byte	0x34
	.byte	0x19
	.4byte	0x5c
	.uleb128 0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF8
	.uleb128 0x1
	.byte	0x8
	.byte	0x7
	.4byte	.LASF9
	.uleb128 0x5
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x6
	.4byte	0x6a
	.uleb128 0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF10
	.uleb128 0x2
	.4byte	.LASF11
	.byte	0x6
	.4byte	0x50
	.uleb128 0x5
	.byte	0x3
	.4byte	leds
	.uleb128 0x2
	.4byte	.LASF12
	.byte	0x7
	.4byte	0x50
	.uleb128 0x5
	.byte	0x3
	.4byte	espera
	.uleb128 0x7
	.4byte	.LASF15
	.byte	0x1
	.byte	0xf
	.byte	0x5
	.4byte	0x6a
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xc7
	.uleb128 0x8
	.4byte	.LASF16
	.byte	0x1
	.byte	0x11
	.byte	0x10
	.4byte	0xc7
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.4byte	0x71
	.uleb128 0xa
	.4byte	.LASF17
	.byte	0x1
	.byte	0x9
	.byte	0x6
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 10
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x1f
	.uleb128 0x1b
	.uleb128 0x1f
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.4byte	0x1c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	0
	.4byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF5:
	.string	"long long int"
.LASF10:
	.string	"unsigned int"
.LASF8:
	.string	"long unsigned int"
.LASF17:
	.string	"desplaza_led"
.LASF9:
	.string	"long long unsigned int"
.LASF13:
	.string	"GNU C17 14.2.0 -mabi=ilp32 -misa-spec=20191213 -march=rv32i -g -O0 -ffreestanding"
.LASF6:
	.string	"unsigned char"
.LASF15:
	.string	"main"
.LASF14:
	.string	"uint32_t"
.LASF4:
	.string	"long int"
.LASF7:
	.string	"short unsigned int"
.LASF2:
	.string	"signed char"
.LASF12:
	.string	"espera"
.LASF16:
	.string	"puerto_salida"
.LASF3:
	.string	"short int"
.LASF11:
	.string	"leds"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/juan/Descargas/riscv32i_ra10-main/software"
.LASF0:
	.string	"ejemplo.c"
	.ident	"GCC: (14.2.0+19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
