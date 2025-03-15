default:
	make -r asmhead.bin
asmhead.bin:	asmhead
	objcopy -j .text -O binary $< $@
asmhead:	asmhead.obj
	ld  -T asmhead.lds -o $@ $^
asmhead.obj:	asmhead.s
	as --32 -o $@  $^
clean:
	rm -f  asmhead.bin asmhead.obj asmhead
