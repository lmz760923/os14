OUTPUT_FORMAT(elf32-i386)
OUTPUT_ARCH(i386)
ENTRY(mystart)
SECTIONS	{
	.text 0x280000: {start.obj(.mysection);
					*(.text)}

	
	. = 0x380000;
	
	
	
	. = ALIGN(4);
	_data_begin = .; 
	.rodata  :AT (ADDR(.text) + SIZEOF(.text))  {*(.rodata)}
	.rodata.str1.1 ALIGN(4)	:	{*(.rodata.str1.1)}
	.eh_frame ALIGN(4)	:	{*(.eh_frame)}
	.data ALIGN(4)	:	{*(.data)}
	. = ALIGN(4);
	__bss_start = .;
	.bss : {*(.bss) *(COMMON)}
	__bss_end = .;
	
	_data_end = .;
	_move_count = SIZEOF(.rodata) + SIZEOF(.rodata.str1.1) + SIZEOF(.eh_frame) + SIZEOF(.data) + 0x2000;
	_move_source =LOADADDR(.rodata);
	
}


