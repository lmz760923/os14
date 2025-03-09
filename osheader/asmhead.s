
.code16

.equ VBEMODE,	0x105			


.equ BOTPAK,    	0x280000		
.equ DSKCAC,		0x100000		
.equ DSKCAC0,		0x8000		


.equ CYLS,		0xff0			
.equ LEDS,		0xff1
.equ VMODE,		0xff2			
.equ SCRNX,		0xff4			
.equ SCRNY, 	0xff6			
.equ VRAM,		0xff8

.section		.text
.global 		mystart	
	mystart:
		

		MOVW	$0x9000,	%AX
		MOVW	%AX,   		%ES
		MOVW	$0,			%DI
		MOVW	$0x4f00,	%AX
		INT		$0x10
		CMPW 	$0x004f,		%AX
		JNE		scrn320

		

		MOVW	%ES:4(%DI),%AX 
		CMPW	$0x0200,	 %AX
		JB		scrn320			

	

		MOVW	$VBEMODE,%CX
		MOVW	$0x4f01,%AX
		INT		$0x10
		CMPW	$0x004f,%AX
		JNE		scrn320


		CMPB	$8,%ES:0x19(%DI)
		JNE		scrn320
		CMPB	$4,%ES:0x1b(%DI)
		JNE		scrn320
		MOVW	%ES:(%DI),%AX
		ANDW	$0x0080,%AX
		JZ		scrn320	

	

		MOVW	$(VBEMODE+0x4000),%BX
		MOVW	$0x4f02,%AX
		INT		$0x10
		MOVB	$8,VMODE
		MOVW	%ES:0x12(%DI),%AX
		MOVW	%AX,SCRNX
		MOVW	%ES:0x14(%DI),%AX
		MOVW	%AX,SCRNY
		MOVL	%ES:0x28(%DI),%EAX
		MOVL	%EAX,VRAM
		
		
		
		JMP		keystatus
		
		

scrn320:
		movb	$0x13,%AL
		movb	$0x00,%AH
		INT		$0x10
		movb	$8,(VMODE)
		MOVW	$320,SCRNX
		MOVW	$200,SCRNY
		MOVl	$0x000a0000,VRAM


keystatus:
		
		MOVB	$0x02,%AH
		
		INT		$0x16 
		
		
		MOVB	%AL,LEDS

		

		MOVB 	$0xff,%AL
		OUTB	%AL,$0x21
		NOP						
		OUTB	%AL,$0xa1

		CLI						



		CALL	waitkbdout
		MOVB	$0xd1,%AL
		OUTB	%AL,$0x64
		CALL	waitkbdout
		MOVB	$0xdf,%AL
		OUTB	%AL,$0x60
		CALL	waitkbdout
		
		
		
		jmp 	code32_st
		
error:
		movw	$0x15, %bx
	    movb	$0x0e, %ah
		movb 	$0x45,%al /*display char*/
	    int	$0x10		/* display a byte */
fin:
		HLT						
		JMP		fin				
  
		

		

		
code32_st:
		
		
		LGDT	GDTR0
		
		
		
		MOVL	%CR0,%EAX
		ANDL	$0x7fffffff	,%EAX
		ORL		$0x00000001,%EAX
		MOVL	%EAX,%CR0
		
	
		
		
		JMP		pipelineflush
pipelineflush:	
		MOVW	$8,%AX
		MOVW	%AX,%DS
		MOVW	%AX,%ES
		MOVW	%AX,%FS
		MOVW	%AX,%GS
		MOVW	%AX,%SS



		lea	 	bootpack,%ESI
		MOVL	$BOTPAK,%EDI
		MOVL	$(512*1024/4),%ECX
		CALL	memcpy



		MOVL	$0x7c00,%ESI
		MOVL	$DSKCAC,%EDI
		MOVL	$(512/4),%ECX
		CALL	memcpy



		MOVL	$(DSKCAC0+512),%ESI
		MOVL	$(DSKCAC+512),%EDI
		MOVL	$0,%ECX
		MOVB	CYLS,%CL
		IMULL	$(512*18*2/4),%ECX
		SUBL	$(512/4),%ECX
		CALL	memcpy


		MOVL	$BOTPAK,%EBX
		MOVL	16(%EBX),%ECX
		ADDL	$3,%ECX
		SHRL	$2,%ECX
		JZ		skip
		MOVL	20(%EBX),%ESI
		ADDL	%EBX,%ESI
		MOVL	12(%EBX),%EDI
		CALL	memcpy
skip:
		MOVL	12(%EBX),%ESP
				
		LJMP	$16,$0x0

waitkbdout:
		INB		 $0x64,%AL
		ANDB	 $0x02,%AL
		JNZ		 waitkbdout	
		RET

memcpy:
		MOVL	(%ESI),%EAX
		ADDL	$4,%ESI
		MOVL	%EAX,(%EDI)
		ADDL	$4,%EDI
		SUBL	$1,%ECX
		JNZ		memcpy			
		RET


		.align 16
GDT0:
		.space	8,0				
		.byte	0xff,0xff,0x00,0x00,0x00,0x92,0xcf,0x00
		.byte	0xff,0xff,0x00,0x00,0x28,0x9a,0x47,0x00	

		.short	0
GDTR0:
		.short	8*3-1
		.long	GDT0

		.align 16
		
bootpack:
