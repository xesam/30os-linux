TOOL_PATH = ./tools

default:
	make run

ipl.bin : ipl.nas
	nasm ipl.nas -o ipl.bin -l ipl.lst

helloos.img : ipl.bin
	$(TOOL_PATH)/edimg ipl.bin helloos.img

img : helloos.img
	make -r helloos.img

run : img
	qemu-system-i386 -fda helloos.img

clean:
	rm ipl.bin
	rm ipl.lst
	rm helloos.img
