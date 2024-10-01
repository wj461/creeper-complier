.LC0:
	.string	"ans = %d\n"

.globl main


main:
	pushq	%rbp
	movq	%rsp, %rbp
    # 4+6
    movl    $4, %r8d
    addl    $6, %r8d    # r8 += 6
    movl    %r8d, %edi
    call print

    # 21 * 2
    movl    $21, %r8d
    imul    $2, %r8d    # r8 *= 2
    movl    %r8d, %edi
    call print

    # 4 + 7 / 2
    movl    $2, %r8d
    movl    $7, %eax
    idivl   %r8d         # eax /= 2
    addl    $4, %eax    # eax += 4
    movl    %eax, %edi
    call print

    #  3 - 6 * (10 / 5)
    movl    $5, %r8d
    movl    $10, %eax
    idivl   %r8d         # eax /= 5
    imul    $6, %eax    # eax *= 6
    movl    $3, %r8d
    subl    %eax, %r8d    # 3 -= eax
    movl    %r8d, %edi
    call print



	xorq	%rax, %rax
	popq	%rbp
	ret

print:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, %esi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	popq	%rbp
	ret
