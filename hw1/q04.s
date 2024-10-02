.section .data
    x: .long 2
    y: .long 0
    format: .string	"%d\n"

.section .text
.globl main

main:
	pushq	%rbp
	movq	%rsp, %rbp

    movl x, %eax
    imull %eax, %eax
    addl x, %eax
    movl %eax, y
    movl y, %edi

    call print

	xorq	%rax, %rax
	popq	%rbp
	ret

print:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, %esi
	leaq	format, %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	popq	%rbp
	ret
