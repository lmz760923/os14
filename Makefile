default:
	make haribote.img
haribote.img:	mbr/ipl10.bin osbody/haribote.sys app/hellow.hrb
	dd if=/dev/zero of=./haribote.img bs=512 count=2880
	dd if=mbr/ipl10.bin conv=notrunc of=haribote.img bs=512 count=1
	#dd if=osbody/haribote.sys conv=notrunc of=haribote.img bs=512 seek=33
	mount -o loop -t vfat haribote.img /mnt/image
	cp osbody/haribote.sys /mnt/image
	cp app/hellow.hrb /mnt/image
	cp app/hellow.s /mnt/image
	cp app/test.txt /mnt/image
	umount /mnt/image
	
	
osbody/haribote.sys:	osheader/asmhead.bin osbody/osbody.hrb
	cat $^ > $@

osheader/asmhead.bin:
	make -B -C osheader

osbody/osbody.hrb:
	make -B -C osbody

mbr/ipl10.bin:
	make -B -C mbr

app/hellow.hrb:
	make -B -C app

clean:
	rm haribote.img -f
	rm osbody/haribote.sys -f
	make -C mbr clean
	make -C osheader clean
	make -C osbody clean
	make -C app clean

