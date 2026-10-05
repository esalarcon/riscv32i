ENTRY(_start)

MEMORY
{
    RAM   : ORIGIN = 0x00000000, LENGTH = 128	/* RAM  size  4KB */
    FLASH : ORIGIN = 0x80000000, LENGTH = 256 	/* FLASH size 8KB */
}

SECTIONS
{
	_start_ram = ORIGIN(RAM);
	_stack_ptr = ORIGIN(RAM) + LENGTH(RAM);
	.text 	: 
	{ 	. = ALIGN(4);
    		*(.text*)    
	} > FLASH
	
	.rodata : 
	{ 	. = ALIGN(4);
		*(.rodata*) 
		. = ALIGN(4);
    		_etext = .; 
    		_rdata = _etext;       
	} > FLASH
	
		
	.data 	: 
	{ 
	  	. = ALIGN(4);
    		_sdata = .;        
		*(.data) 
		*(.sdata) 
	  	. = ALIGN(4);
    		_edata = .;        
		
	} > RAM AT > FLASH
		
	. = ALIGN(4);
	.bss 	: 
	{ 
	  	. = ALIGN(4);
    		_sbss = .;        
		*(.bss)  
		*(.sbss) 
		. = ALIGN(4);
    		_ebss = .;        
	} > RAM AT > FLASH
 }
