.equ CYLS,		20	
.code16		
.section .text
.global mystart
mystart:
		JMP		entry
		
		.byte		0x90
		.ascii		"HARIBOTE"		
		.short		512				
		.byte		1				
		.short		1				
		.byte		2				
		.short		224				
		.short		2880			
		.byte		0xf0			
		.short		9				
		.short		18				
		.short		2				
		.long		0				
		.long		2880			
		.byte		0,0,0x29		
		.long		0xffffffff		
		.ascii		"HARIBOTEOS "	
		.ascii		"FAT12   "		
		.space      18,0
entry:
		movw	$0,%AX			
		movw	%AX,%SS
		movw	$0x7c00,%SP
		movw	%AX,%DS
		
		movw	$0x0820,%AX
		movw	%AX,%ES
		movb	$0,%CH			
		movb	$0,%DH		
		movb	$2,%CL		
		
readloop:
		movb	$0x02,%AH			
		movb	$1,%AL	
		movw	$0,%BX
		movb	$0x00,%DL	
		INT		$0x13			
		JC		error			
		movw	%ES,%AX			
		addw	$0x0020,%AX
		movw	%AX,%ES			
		addb	$1,%CL			
		cmpb	$18,%CL			
		jbe		readloop		
		movb	$1,%CL
		addb	$1,%DH
		cmpb	$2,%DH
		jb		readloop		
		movb	$0,%DH
		addb	$1,%CH
		cmpb	$CYLS,%CH
		JB		readloop		
		movb	%CH,0x0ff0		
		jmp		0xc200
error:
		movw	$(msg+14),%SI
		
		movb	%AH,%AL
		movb	$10,%BL
		movb	$48,%DL
toasci:
		xorb	%AH,%AH
		diVB	%BL
		movb	%AH,(%si)
		addb	%DL,(%SI)
		decw	%SI
		cmpb	$10,%AL
		JGE		toasci
		movb	%AL,(%SI)
		addb	%DL,(%SI)
		
		movw	$msg,%SI
putloop:
		movb	(%SI),%AL
		addw	$1,%SI			
		cmpb	$0,%AL
		JE		fin
		movb	$0x0e,%AH			
		movw	$15,%BX			
		INT		$0x10			
		JMP		putloop
fin:
		HLT						
		JMP		fin				
msg:
		.byte		0x0a, 0x0a		
		.ascii		"int13:     "
		.byte		0x0a			
		.byte		0
		.=510+ mystart
		.byte		0x55, 0xaa
