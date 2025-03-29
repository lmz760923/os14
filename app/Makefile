default:
	make hlt.hrb
hlt.hrb:	hlt
	objcopy hlt -R .eh_frame -R .comment -R symtab -R .strtab -R .shstrtab -S -g hlt.hrb -O binary


hlt:	hlt.obj
	ld  -nostdlib -nostartfile -T hlt.lds   -m elf_i386  -o hlt $^ 
%.s:	%.c 
	
	gcc -I . -S -m32 -std=c99 -Os  -fno-builtin -nostdinc -o $*.s $*.c

%.obj:	%.s
	as --32 -o $*.obj $*.s 

	
clean:
	rm -f *.obj hlt hlt.hrb 
