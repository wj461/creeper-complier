.section .data
    format: .string	"%d\n"

.section .text
.globl main

main:
	pushq	%rbp
	movq	%rsp, %rbp

    # x = 3 
    subq    $12, %rsp
    movl    $3, -4(%rbp)
    movl    -4(%rbp), %edi
    imull   %edi, %edi
    call print

    # y = x + x
    movl    -4(%rbp), %edi
    addl   %edi, %edi
    movl    %edi, -8(%rbp)
    # y *= x
    imull   -4(%rbp), %edi
    # save y result to y
    movl    %edi, -8(%rbp)

    # z = x + 3
    movl    -4(%rbp), %edi
    addl   $3, %edi
    movl    %edi, -12(%rbp)
    # z /= z
    movl    %edi, %eax
    divl    %edi
    movl    %eax, %edi
    # add z result and y
    addl    -8(%rbp), %edi
    call print

	xorq	%rax, %rax
    addq    $12, %rsp
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
