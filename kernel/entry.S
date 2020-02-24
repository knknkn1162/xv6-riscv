#include "kernel/param.h"

	# qemu -kernel starts at 0x1000. the instructions
        # there seem to be provided by qemu, as if it
        # were a ROM. the code at 0x1000 jumps to
        # 0x8000000, the _start function here,
        # in machine mode. each CPU starts here.
.section .data
.align 16
.globl stack0
stack0:
  .zero 4096*NCPU

# in S-mode
.section .text
.globl _entry
_entry:
	# set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + (hartid * 4096)
        la sp, stack0
        li a1, 1024*4
    # from riscv-pk, a0: hart_id, a1: dtb(unused)
    # In S-mode, cpu-id use $tp resiter as hart-id
    mv tp, a0
    addi a0, a0, 1
    mul a1, a1, a0
    add sp, sp, a1
    call main
junk:
        j junk
