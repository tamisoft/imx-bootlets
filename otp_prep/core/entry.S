/*
 * linux_prep entry code.
 *
 * Entered twice:
 *
 * - Before loading Linux kernel image to SDRAM to check
 *   if CPU is being taken out of standby mode and resume
 *   sleeping kernel.
 *
 * - After loading Linux kernel image to prepare Linux boot
 *   paramteters and jump to the kernel
 *
 * Vladislav Buzov <vbuzov@embeddedalley.com>
 *
 * Copyright 2008 SigmaTel, Inc
 * Copyright 2008 Embedded Alley Solutions, Inc
 *
 * This file is licensed under the terms of the GNU General Public License
 * version 2.  This program  is licensed "as is" without any warranty of any
 * kind, whether express or implied.
 */
#include <arch/platform.h>

#undef DEBUG

	.code 32
	.section ".start", "ax"

	.global _start, _fail_reason
_start:
	stmdb	sp!, {r4-r12, lr}

	/* Check entry counter */
/*	ldr	r4, entry_count
	cmp	r4, #0
*/
    bl	start_kernel

	/*
	 * We may not return from there if system is resuming
	 * from standby mode
	 */

	/* Return to ROM */
	ldmia	sp!, {r4-r12, lr}
	bx	lr

	.pool

entry_count:
	.long	0x00
_fail_reason:
	.long 	0x00

start_kernel:
	bl	clear_bss

	/* Initialize HW modules relevant for linux_prep */
	bl	hw_init

	mov	r0, #0
stop: b stop    @infinite loop

/*
 * This function initializes all HW modules anebled in
 * current configuration. It goes throgh .hwinitcall section
 * containing addresses of HW initialization routines.
 */
hw_init:
	stmdb	sp!, {r4-r6, lr}
	ldr	r4, =_hwinit_start
	ldr	r5, =_hwinit_end
1:	ldr	r6, [r4], #4
	mov	lr, pc
	mov	pc, r6
	cmp	r4, r5
	blo	1b
	ldmia	sp!, {r4-r6, lr}
	mov	pc, lr

	.pool
/*
 * This function clears out the .bss section.
 */
clear_bss:
	ldr	r0, =_bss_start
	ldr	r1, =_bss_end
	mov	r2, #0
1:	str	r2, [r0], #4
	cmp	r0, r1
	blo	1b
	mov	pc, lr

	.pool
/*
 * ARM EABI toolchain needs divide by zero handler to be implemented
 * externally.
 */
	.globl	__div0
__div0:
	mov	pc, lr
	.globl	__aeabi_unwind_cpp_pr0
__aeabi_unwind_cpp_pr0:
	mov	pc, lr
	.globl	raise
raise:
	mov	pc, lr
