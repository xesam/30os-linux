; hello-os
; TAB=4

; FAT32 format

ORG 0X7C00 ; 引导记录被加载到内存 0000:7c00

	JMP entry
	DB 0x90 ; 空指令 NOP

	DB		"HELLOIPL"		; 可自由写入引导扇区的名称，实际是厂商名称，最多8个字节
	DW		512				; 每扇区(sector)字节数:512
	DB		1				; 每簇(cluster)扇区数:1
	DW		1				; 引导记录占据扇区数:1
	DB		2				; FAT 表个数:2，为了保险 FAT 系统中存在两个 FAT 表
	DW		224				; 根目录区最大文件数:224，因 FAT 目录项为定长记录，所以可以计算出来。
	DW		2880			; 扇区总数(16位)：2880, 2880 * 512 = 1474560，就是一张 1.44M 软盘的总容量
	DB		0xf0			; 介质描述符(must be 0xf0)
	DW		9				; FAT 表占据扇区数: 9，因此两个 FAT 表共占用 9 * 2 = 18 扇区
	DW		18				; 每磁道扇区数：18
	DW		2				; 磁头数：2
	DD		0				; 隐藏扇区数：0
	DD		2880			; 扇区总数(32位)
	DB		0,0,0x29		; 依次是磁盘中断服务(INT 13)的驱动器号(第1,2 软磁盘驱动器号：0,1。硬盘驱动器号从 0x80 开始)，保留字节，及扩展引导标记(0x29)
	DD		0xffffffff		; 卷序列号，这里直接写成 0xffffffff
	DB		"HELLO-OS   "	; 磁盘名称(卷标)，根据 FAT 系统 8.3 文件名规范，共11字节
	DB		"FAT12   "		; 文件系统类型描述：8字节
	TIMES 18 DB 0

entry:

	MOV		AX,0
	MOV		SS,AX
	MOV		SP,0x7c00
	MOV		DS,AX
	MOV		ES,AX

	MOV		SI,msg

putloop:
		MOV		AL,[SI]
		ADD		SI,1			;
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; 显示一个文字
		MOV		BX,15			; 指定字符颜色
		INT		0x10			; 调用显卡BIOS
		JMP		putloop
fin:
		HLT						; cpu 停止，等待指令
		JMP		fin

msg:

	DB		0x0a, 0x0a		;
	DB		"hello, world"
	DB		0x0a			;
	DB		0

	TIMES 0x1fe-($-$$) DB 0

	DB		0x55, 0xaa
