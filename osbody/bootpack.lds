OUTPUT_FORMAT(elf32-i386)
OUTPUT_ARCH(i386)
ENTRY(mystart)
SECTIONS	{
	.text 0x280000: {start.obj(.mysection);
					*(.text)}

	
	. = 0x290000;
	
	
	
	. = ALIGN(4);
	_data_begin = .; 
	.rodata  : {*(.rodata)}
	.rodata.str1.1 ALIGN(4)	:	{*(.rodata.str1.1)}
	.eh_frame ALIGN(4)	:	{*(.eh_frame)}
	.data ALIGN(4)	:	{*(.data)}
	. = ALIGN(4);
	__bss_start = .;
	.bss : {*(.bss)}
	__bss_end = .;
	/DISCARD/ : {*(.comment)}
	
	_data_end = .;
	_move_count = _data_end - _data_begin ;
	_move_source =LOADADDR(.rodata);
	
}


