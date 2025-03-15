default:
	make -r ipl10.bin
ipl10.bin:	ipl10
	objcopy -j .text -O binary $< $@
ipl10: ipl10.obj
	ld  -o $@ -T $@.lds $^
ipl10.obj: ipl10.s
	as --32 -o $@ $^
clean:
	rm -f ipl10 ipl10.bin ipl10.obj
	
	
	
	
