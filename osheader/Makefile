default:
	make -r asmhead.bin
asmhead.bin:	asmhead
	objcopy -j .text -O binary $< $@
asmhead:	asmhead.o
	ld  -T asmhead.lds -o $@ $^
asmhead.o:	asmhead.s
	as --32 -o $@  $^
clean:
	rm -f  asmhead.bin asmhead.o asmhead
