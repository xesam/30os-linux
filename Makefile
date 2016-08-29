default:
	make run

ipl.bin : ipl.nas
	nasm ipl.nas -o ipl.bin -l ipl.lst

helloos.img : ipl.bin
	$(warning 'heihei')
	./tools/edimg ipl.bin helloos.img

img : helloos.img
	make -r helloos.img

run : img
	qemu-system-i386 helloos.img

clean:
	rm ipl.bin
	rm ipl.lst
	rm helloos.img
