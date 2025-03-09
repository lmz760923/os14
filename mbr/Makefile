default:
	make -r ipl10.bin
ipl10.bin:	ipl10
	objcopy -j .text -O binary $< $@
ipl10: ipl10.o
	ld  -o $@ -T $@.lds $^
ipl10.o: ipl10.s
	as --32 -o $@ $^
clean:
	rm ipl10 ipl10.bin ipl10.o
	
	
	
	
