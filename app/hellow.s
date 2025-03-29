.code32
.section .text
.global _start

_start:
    movl $msg, %ecx    # Load address of msg into ECX
    movl $1, %edx      # EDX = 1 (likely file descriptor or print function)

putloop:
    movb %cs:(%ecx), %al  # Load byte at CS:ECX into AL
    cmpb $0, %al           # Compare AL with 0
    je fin                 # If zero (end of string), jump to fin
    int $0x40              # Call interrupt 0x40
    addl $1, %ecx          # Increment ECX
    jmp putloop            # Repeat loop

fin:
    retf                   # Far return

msg:
    .asciz "hello"         # Null-terminated string