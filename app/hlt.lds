OUTPUT_FORMAT(elf32-i386)
OUTPUT_ARCH(i386)
ENTRY(mystart)
SECTIONS	{
	.text :  {*(.text)}

}
