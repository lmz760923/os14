default:
	make hellow.hrb
hellow.hrb:	hellow
	objcopy hellow -R .eh_frame -R .comment -R symtab -R .strtab -R .shstrtab -S -g hellow.hrb -O binary


hellow:	hellow.obj
	ld  -nostdlib -nostartfile -T hellow.lds   -m elf_i386  -o hellow $^ 
%.s:	%.c 
	
	gcc -I . -S -m32 -std=c99 -Os  -fno-builtin -nostdinc -o $*.s $*.c

%.obj:	%.s
	as --32 -o $*.obj $*.s 

	
clean:
	rm -f *.obj hellow hellow.hrb 
