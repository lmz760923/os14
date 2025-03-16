default:
	make osbody.hrb
osbody.hrb:	osbody
	objcopy osbody -R .eh_frame -R .comment -R symtab -R .strtab -R .shstrtab -S -g osbody.hrb -O binary


osbody:	start.obj  bootpack.obj naskfunc.obj hankaku.obj utils.obj dsctbl.obj graphic.obj int.obj fifo.obj   keyboard.obj memory.obj mouse.obj  sheet.obj  timer.obj mtask.obj
	ld  -nostdlib -nostartfile -T bootpack.lds  -Ttext 0x00280000 -m elf_i386  -o osbody $^ 
%.s:	%.c 
	
	gcc -I . -S -m32 -std=c99 -Os  -fno-builtin -nostdinc -o $*.s $*.c

%.obj:	%.s
	as --32 -o $*.obj $*.s 

	
clean:
	rm -f *.obj osbody osbody.hrb 
