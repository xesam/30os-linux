default:
	make img

ipl.bin : ipl.nas
	nasm ipl.nas -o ipl.bin -l ipl.lst

helloos.img : ipl.bin
	$(warning 'heihei')

img : helloos.img
	make -r helloos.img

clean:
	rm ipl.bin
	rm ipl.lst
	rm helloos.img
