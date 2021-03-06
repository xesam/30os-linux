; hello-os
; TAB=4

; FAT32 format

		DB		0xeb, 0x4e, 0x90
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
		;RESB	18				; 预留 18 字节
		TIMES 18 DB 0

; 以下是引导记录的程序体

		DB		0xb8, 0x00, 0x00, 0x8e, 0xd0, 0xbc, 0x00, 0x7c
		DB		0x8e, 0xd8, 0x8e, 0xc0, 0xbe, 0x74, 0x7c, 0x8a
		DB		0x04, 0x83, 0xc6, 0x01, 0x3c, 0x00, 0x74, 0x09
		DB		0xb4, 0x0e, 0xbb, 0x0f, 0x00, 0xcd, 0x10, 0xeb
		DB		0xee, 0xf4, 0xeb, 0xfd

; show info

		DB		0x0a, 0x0a		;
		DB		"hello, world"
		DB		0x0a			;
		DB		0

		;RESB	0x1fe-$			; set 0x00 util 0x1fe
		TIMES 0x1fe-($-$$) DB 0

		DB		0x55, 0xaa

;启动区以外

		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		;RESB	4600
		TIMES 4600 DB 0
		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		;RESB	1469432
		TIMES 1469432 DB 0
