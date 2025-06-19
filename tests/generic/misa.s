.section .data
.align 3
.globl tohost
tohost: .dword 0

.section .text
.align 3
.globl _start
_start:
    csrr a0, misa
    fence
    la t0, tohost
    sw a0, 0(t0)
    fence

_forever_loop:
    j _forever_loop
