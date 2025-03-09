[BITS 32]						

		GLOBAL	io_hlt, io_cli, io_sti, io_stihlt
		GLOBAL	io_in8,  io_in16,  io_in32
		GLOBAL	io_out8, io_out16, io_out32
		GLOBAL	io_load_eflags, io_store_eflags
		GLOBAL	load_gdtr, load_idtr
		GLOBAL	load_cr0, store_cr0
		GLOBAL	load_tr
		GLOBAL	asm_inthandler20, asm_inthandler21
		GLOBAL	asm_inthandler2c, asm_inthandler0c
		GLOBAL	asm_inthandler0d, asm_end_app
		GLOBAL  asm_inthandler27
		GLOBAL	memtest_sub
		GLOBAL	farjmp, farcall
		GLOBAL	asm_hrb_api, start_app
		EXTERN	inthandler20, inthandler21
		EXTERN	inthandler2c, inthandler0d
		EXTERN	inthandler0c, inthandler27
		EXTERN	hrb_api

[SECTION .text]

io_hlt:	; void io_hlt(void);
		HLT
		RET

io_cli:	; void io_cli(void);
		CLI
		RET

io_sti:	; void io_sti(void);
		STI
		RET

io_stihlt:	; void io_stihlt(void);
		STI
		HLT
		RET

io_in8:	; int io_in8(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AL,DX
		RET

io_in16:	; int io_in16(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AX,DX
		RET

io_in32:	; int io_in32(int port);
		MOV		EDX,[ESP+4]		; port
		IN		EAX,DX
		RET

io_out8:	; void io_out8(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		AL,[ESP+8]		; data
		OUT		DX,AL
		RET

io_out16:	; void io_out16(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,AX
		RET

io_out32:	; void io_out32(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,EAX
		RET

io_load_eflags:	; int io_load_eflags(void);
		PUSHFD		; PUSH EFLAGS
		POP		EAX
		RET

io_store_eflags:	; void io_store_eflags(int eflags);
		MOV		EAX,[ESP+4]
		PUSH	EAX
		POPFD		; POP EFLAGS
		RET

load_gdtr:		; void load_gdtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LGDT	[ESP+6]
		RET

load_idtr:		; void load_idtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LIDT	[ESP+6]
		RET

load_cr0:		; int load_cr0(void);
		MOV		EAX,CR0
		RET

store_cr0:		; void store_cr0(int cr0);
		MOV		EAX,[ESP+4]
		MOV		CR0,EAX
		RET

load_tr:		; void load_tr(int tr);
		LTR		[ESP+4]			; tr
		RET

asm_inthandler20:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler20
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler21:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler21
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler2c:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler2c
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler0c:
		STI
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		;CALL	inthandler0c
		CMP		EAX,0
		JNE		asm_end_app
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		ADD		ESP,4			; 在INT 0x0c中也需要这句
		IRETD

asm_inthandler0d:
		STI
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		;CALL	inthandler0d
		CMP		EAX,0		
		JNE		asm_end_app		
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		ADD		ESP,4			; INT 0x0d需要这句
		IRETD

memtest_sub:	; unsigned int memtest_sub(unsigned int start, unsigned int end)
		PUSH	EDI						; （由于还要使用EBX, ESI, EDI）
		PUSH	ESI
		PUSH	EBX
		MOV		ESI,0xaa55aa55			; pat0 = 0xaa55aa55;
		MOV		EDI,0x55aa55aa			; pat1 = 0x55aa55aa;
		MOV		EAX,[ESP+12+4]			; i = start;
mts_loop:
		MOV		EBX,EAX
		ADD		EBX,0xffc				; p = i + 0xffc;
		MOV		EDX,[EBX]				; old = *p;
		MOV		[EBX],ESI				; *p = pat0;
		XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
		CMP		EDI,[EBX]				; if (*p != pat1) goto fin;
		JNE		mts_fin
		XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
		CMP		ESI,[EBX]				; if (*p != pat0) goto fin;
		JNE		mts_fin
		MOV		[EBX],EDX				; *p = old;
		ADD		EAX,0x1000				; i += 0x1000;
		CMP		EAX,[ESP+12+8]			; if (i <= end) goto mts_loop;
		JBE		mts_loop
		POP		EBX
		POP		ESI
		POP		EDI
		RET
mts_fin:
		MOV		[EBX],EDX				; *p = old;
		POP		EBX
		POP		ESI
		POP		EDI
		RET

farjmp:		; void farjmp(int eip, int cs);
		JMP		FAR	[ESP+4]				; eip, cs
		RET

farcall:		; void farcall(int eip, int cs);
		CALL	FAR	[ESP+4]				; eip, cs
		RET

asm_hrb_api:
		STI
		PUSH	DS
		PUSH	ES
		PUSHAD			; 用于保存的PUSH
		PUSHAD			; 用于向hrb_api传值的PUSH
		MOV		AX,SS
		MOV			DS,AX ; 将操作系统用段地址存入DS和ES
		MOV		ES,AX
		;CALL	hrb_api
		CMP			EAX,0 ; 当EAX不为0时程序结束
		JNE		asm_end_app
		ADD		ESP,32
		POPAD
		POP		ES
		POP		DS
		IRETD
asm_end_app:
; EAX为tss.esp0的地址
		MOV		ESP,[EAX]
		MOV		DWORD [EAX+4],0
		POPAD
		RET			; 返回cmd_app

start_app:		; void start_app(int eip, int cs, int esp, int ds, int *tss_esp0);
		PUSHAD								; 将32位寄存器的值全部保存起来
		MOV			EAX,[ESP+36]	; 应用程序用EIP
		MOV			ECX,[ESP+40]	; 应用程序用CS
		MOV			EDX,[ESP+44]	; 应用程序用ESP
		MOV			EBX,[ESP+48]	; 应用程序用DS/SS
		MOV			EBP,[ESP+52]	; tss.esp0的地址
		MOV			[EBP ],ESP		; 保存操作系统用ESP
		MOV			[EBP+4],SS		; 保存操作系统用SS
		MOV		ES,BX
		MOV		DS,BX
		MOV		FS,BX
		MOV		GS,BX
; 下面调整栈，以免用RETF跳转到应用程序
		OR			ECX,3 				; 将应用程序用段号和3进行OR运算
		OR      EBX,3 				; 将应用程序用段号和3进行OR运算
		PUSH		EBX						; 应用程序的SS
		PUSH		EDX						; 应用程序的ESP
		PUSH		ECX						; 应用程序的CS
		PUSH		EAX						; 应用程序的EIP
		RETF
; 应用程序结束后不会回到这里
asm_inthandler27:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler27
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD