; hello-os
; TAB=4

; FAT32 format

	CYLS EQU 10

	ORG 0X7C00 ; 引导记录被加载到内存 0000:7c00

	JMP entry
	DB 0x90 ; 空指令 NOP

	DB		"HARIBOTE"		; 可自由写入引导扇区的名称，实际是厂商名称，必须是8个字节，不足以空填充
	DW		512				; 每扇区(sector)字节数:512
	DB		1				; 每簇(cluster)扇区数:1
	DW		1				; 引导记录占据扇区数:1
	DB		2				; FAT 表个数:2，为了保险 FAT 系统中存在两个 FAT 表
	DW		224				; 根目录区最大文件数:224，因 FAT 目录项为定长记录，所以可以计算出来。
	DW		2880			; 逻辑扇区总数(16位)：2880, 2880 * 512 = 1474560，就是一张 1.44M 软盘的总容量
	DB		0xf0			; 介质描述符(must be 0xf0)
	DW		9				; FAT 表占据扇区数: 9，因此两个 FAT 表共占用 9 * 2 = 18 扇区
	DW		18				; 每磁道扇区数：18
	DW		2				; 磁头数：2
	DD		0				; 隐藏扇区数：0
	DD		2880			; 扇区总数(32位)
	DB		0       ; INT13 的驱动器号(第1,2 软磁盘驱动器号：0,1。硬盘驱动器号从 0x80 开始)
	DB		0	      ; 保留字节
	DB		0x29    ; 扩展引导标记(0x29)
	DD		0xffffffff		; 卷序列号，这里直接写成 0xffffffff
	DB		"HELLO-OS   "	; 磁盘名称(卷标)，根据 FAT 系统 8.3 文件名规范，必须是11字节，不足填充空格
	DB		"FAT12   "		; 文件系统类型描述：必须是8个字节，不足填充空格
	TIMES 18 DB 0

entry:
		MOV		AX,0			; 初始化
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX
		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0			; 柱面0
		MOV		DH,0			; 磁头0
		MOV		CL,2			; 扇区2

readloop:
		MOV		SI,0			; SI 重试次数记录

retry:
		MOV		AH,0x02		; AH=0x02 : 读盘
		MOV		AL,1			; 每次读取一个扇区
		MOV		BX,0
		MOV		DL,0x00		; 驱动器号 为 0
		INT		0x13			;
		JNC		next			; 没有错误就接着读下一个扇区
		ADD		SI,1			;
		CMP		SI,5			;
		JAE		error1		;
		MOV		AH,0x00   ; 重置
		MOV		DL,0x00
		INT		0x13			;
		JMP		retry

next:
		MOV		AX,ES			;
		ADD		AX,0x0020
		MOV		ES,AX			; 段寄存器增加 0x20
		ADD		CL,1			; 扇区增加1
		CMP		CL,18			;
		JBE		readloop	; CL <= 18
		MOV		CL,1
		ADD		DH,1			; 下一个磁头
		CMP		DH,2
		JB		readloop	; DH < 2
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop

fin:
		HLT						; cpu 停止，等待指令
		JMP		fin

error1:
		MOV		SI,msg1
		jmp   putloop

error2:
		MOV		SI,msg2
		jmp   putloop

putloop:
		MOV		AL,[SI]
		ADD		SI,1			;
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e		; 
		MOV		BX,15			;
		INT		0x10			;
		JMP		putloop

msg1:
		DB		0x0a, 0x0a;
		DB		"load error1"
		DB		0x0a			;
		DB		0

msg2:
		DB		0x0a, 0x0a;
		DB		"load error2"
		DB		0x0a			;
		DB		0

	TIMES 0x1fe-($-$$) DB 0		;
	DB		0x55, 0xaa
