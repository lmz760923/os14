.global io_hlt, io_cli, io_sti, io_stihlt
.global io_in8, io_in16, io_in32
.global io_out8, io_out16, io_out32
.global io_load_eflags, io_store_eflags
.global load_gdtr, load_idtr
.global load_cr0, store_cr0
.global load_tr
.global asm_inthandler20, asm_inthandler21
.global asm_inthandler2c, asm_inthandler0c
.global asm_inthandler0d, asm_end_app
.global asm_inthandler27
.global memtest_sub
.global farjmp, farcall
.global asm_hrb_api, start_app

.extern inthandler20, inthandler21
.extern inthandler2c, inthandler0d
.extern inthandler0c, inthandler27
.extern hrb_api

.section .text

io_hlt:  # void io_hlt(void);
    hlt
    ret

io_cli:  # void io_cli(void);
    cli
    ret

io_sti:  # void io_sti(void);
    sti
    ret

io_stihlt:  # void io_stihlt(void);
    sti
    hlt
    ret

io_in8:  # int io_in8(int port);
    movl 4(%esp), %edx  # port
    xorl %eax, %eax
    inb %dx, %al
    ret

io_in16:  # int io_in16(int port);
    movl 4(%esp), %edx  # port
    xorl %eax, %eax
    inw %dx, %ax
    ret

io_in32:  # int io_in32(int port);
    movl 4(%esp), %edx  # port
    inl %dx, %eax
    ret

io_out8:  # void io_out8(int port, int data);
    movl 4(%esp), %edx  # port
    movb 8(%esp), %al   # data
    outb %al, %dx
    ret

io_out16:  # void io_out16(int port, int data);
    movl 4(%esp), %edx  # port
    movw 8(%esp), %ax   # data
    outw %ax, %dx
    ret

io_out32:  # void io_out32(int port, int data);
    movl 4(%esp), %edx  # port
    movl 8(%esp), %eax  # data
    outl %eax, %dx
    ret

io_load_eflags:  # int io_load_eflags(void);
    pushfl
    popl %eax
    ret

io_store_eflags:  # void io_store_eflags(int eflags);
    movl 4(%esp), %eax
    pushl %eax
    popfl
    ret

load_gdtr:  # void load_gdtr(int limit, int addr);
    movw 4(%esp), %ax  # limit
    movw %ax, 6(%esp)
    lgdt 6(%esp)
    ret

load_idtr:  # void load_idtr(int limit, int addr);
    movw 4(%esp), %ax  # limit
    movw %ax, 6(%esp)
    lidt 6(%esp)
    ret

load_cr0:  # int load_cr0(void);
    movl %cr0, %eax
    ret

store_cr0:  # void store_cr0(int cr0);
    movl 4(%esp), %eax
    movl %eax, %cr0
    ret

load_tr:  # void load_tr(int tr);
    ltr 4(%esp)  # tr
    ret

asm_inthandler20:
    pushl %es
    pushl %ds
    pushal
    movl %esp, %eax
    pushl %eax
    movw %ss, %ax
    movw %ax, %ds
    movw %ax, %es
    call inthandler20
    popl %eax
    popal
    popl %ds
    popl %es
    iretl

asm_inthandler21:
    pushl %es
    pushl %ds
    pushal
    movl %esp, %eax
    pushl %eax
    movw %ss, %ax
    movw %ax, %ds
    movw %ax, %es
    call inthandler21
    popl %eax
    popal
    popl %ds
    popl %es
    iretl

asm_inthandler2c:
    pushl %es
    pushl %ds
    pushal
    movl %esp, %eax
    pushl %eax
    movw %ss, %ax
    movw %ax, %ds
    movw %ax, %es

    call inthandler2c
    popl %eax
    popal
    popl %ds
    popl %es
    iretl

asm_inthandler0c:
    sti
    pushl %es
    pushl %ds
    pushal
    movl %esp, %eax
    pushl %eax
    movw %ss, %ax
    movw %ax, %ds
    movw %ax, %es
    # call inthandler0c
    cmpl $0, %eax
    jne asm_end_app
    popl %eax
    popal
    popl %ds
    popl %es
    addl $4, %esp  # 在INT 0x0c中也需要这句
    iretl

asm_inthandler0d:
    sti
    pushl %es
    pushl %ds
    pushal
    movl %esp, %eax
    pushl %eax
    movw %ss, %ax
    movw %ax, %ds
    movw %ax, %es
    # call inthandler0d
    cmpl $0, %eax
    jne asm_end_app
    popl %eax
    popal
    popl %ds
    popl %es
    addl $4, %esp  # INT 0x0d需要这句
    iretl

memtest_sub:  # unsigned int memtest_sub(unsigned int start, unsigned int end)
    pushl %edi
    pushl %esi
    pushl %ebx
    movl $0xaa55aa55, %esi  # pat0 = 0xaa55aa55
    movl $0x55aa55aa, %edi  # pat1 = 0x55aa55aa
    movl 16(%esp), %eax  # i = start
mts_loop:
    movl %eax, %ebx
    addl $0xffc, %ebx  # p = i + 0xffc
    movl (%ebx), %edx  # old = *p
    movl %esi, (%ebx)  # *p = pat0
    xorl $0xffffffff, (%ebx)  # *p ^= 0xffffffff
    cmpl %edi, (%ebx)  # if (*p != pat1) goto fin
    jne mts_fin
    xorl $0xffffffff, (%ebx)  # *p ^= 0xffffffff
    cmpl %esi, (%ebx)  # if (*p != pat0) goto fin
    jne mts_fin
    movl %edx, (%ebx)  # *p = old
    addl $0x1000, %eax  # i += 0x1000
    cmpl 20(%esp), %eax  # if (i <= end) goto mts_loop
    jbe mts_loop
    popl %ebx
    popl %esi
    popl %edi
    ret
mts_fin:
    movl %edx, (%ebx)  # *p = old
    popl %ebx
    popl %esi
    popl %edi
    ret

farjmp:  # void farjmp(int eip, int cs);
    ljmp *4(%esp)  # eip, cs
    ret

farcall:  # void farcall(int eip, int cs);
    lcall *4(%esp)  # eip, cs
    ret

asm_hrb_api:
    sti
    pushl %ds
    pushl %es
    pushal  # 用于保存的PUSH
    pushal  # 用于向hrb_api传值的PUSH
    movw %ss, %ax
    movw %ax, %ds  # 将操作系统用段地址存入DS和ES
    movw %ax, %es
    # call hrb_api
    cmpl $0, %eax  # 当EAX不为0时程序结束
    jne asm_end_app
    addl $32, %esp
    popal
    popl %es
    popl %ds
    iretl

asm_end_app:
    # EAX为tss.esp0的地址
    movl (%eax), %esp
    movl $0, 4(%eax)
    popal
    ret  # 返回cmd_app

start_app:  # void start_app(int eip, int cs, int esp, int ds, int *tss_esp0);
    pushal  # 将32位寄存器的值全部保存起来
    movl 36(%esp), %eax  # 应用程序用EIP
    movl 40(%esp), %ecx  # 应用程序用CS
    movl 44(%esp), %edx  # 应用程序用ESP
    movl 48(%esp), %ebx  # 应用程序用DS/SS
    movl 52(%esp), %ebp  # tss.esp0的地址
    movl %esp, (%ebp)  # 保存操作系统用ESP
    movw %ss, 4(%ebp)  # 保存操作系统用SS
    movw %bx, %es
    movw %bx, %ds
    movw %bx, %fs
    movw %bx, %gs
    # 下面调整栈，以免用RETF跳转到应用程序
    orl $3, %ecx  # 将应用程序用段号和3进行OR运算
    orl $3, %ebx  # 将应用程序用段号和3进行OR运算
    pushl %ebx  # 应用程序的SS
    pushl %edx  # 应用程序的ESP
    pushl %ecx  # 应用程序的CS
    pushl %eax  # 应用程序的EIP
    lret

asm_inthandler27:
    pushl %es
    pushl %ds
    pushal
    movl %esp, %eax
    pushl %eax
    movw %ss, %ax
    movw %ax, %ds
    movw %ax, %es
    call inthandler27
    popl %eax
    popal
    popl %ds
    popl %es
    iretl
