.section .data
    format: .string	"sqrt(%2d) = %2d\n"

.section .text
.globl main

main:
	pushq	%rbp
	movq	%rsp, %rbp
    subq    $4, %rsp
    movl    $0, -4(%rbp)

    # n = 0
    movl    $0, %ecx

    compare:
    # n += 1
    movl    -4(%rbp), %edi
    call isqrt
    movl    -4(%rbp), %edi
    movl    %eax, %esi
    call print

    addl    $1, -4(%rbp)
    cmpl $20, -4(%rbp)
    jle compare

	xorq	%rax, %rax
    addq    $4, %rsp
	popq	%rbp
	ret

print:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%esi, %edx
	movl	%edi, %esi
	leaq	format, %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	popq	%rbp
	ret

isqrt:
	pushq	%rbp
	movq	%rsp, %rbp
    subq    $8, %rsp
    # c = 0
    movl    $0, -4(%rbp)
    # s = 1
    movl    $1, -8(%rbp)

    while:
    # c++
    addl    $1, -4(%rbp)
    movl    -4(%rbp), %ecx
    # 2 * c
    imull   $2, %ecx
    # +1
    addl    $1, %ecx

    # s += 2*c +1
    addl    %ecx, -8(%rbp)


    # s - n
    cmpl %edi, -8(%rbp)
    jle while


    # return result
    movl    -4(%rbp), %eax

    addq    $8, %rsp
	popq	%rbp
	ret
