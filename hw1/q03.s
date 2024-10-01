.LC0:
	.string	"%d\n"

.bool_str: .string	"%s\n"

.true_str: .string	"true"

.false_str: .string	"false"

.globl main

main:
	pushq	%rbp
	movq	%rsp, %rbp

    #  true && false
    movl    $1, %edi
    andl   $0, %edi
    call print_bool

    # if 3 <> 4 then 10 * 2 else 14
    movl    $3, %edi
    cmpl   $4, %edi
    je f_2

    # 10 * 2
    movl    $10, %edi
    imul    $2, %edi    # edi *= 2

    jmp q2
    f_2:
    movl    $14, %edi

    q2:
    call print

    #;2 = 3 || 4 <= 2 * 3 
    movl    $2, %edi
    cmpl   $3, %edi
    jne f_3_1
    movl    $1, %edi
    call print_bool

    f_3_1:
    # 2 * 3
    movl    $2, %edi
    imul    $3, %edi    # edi *= 3

    cmpl   $4, %edi
    js f_3_2
    movl    $1, %edi
    call print_bool
    jmp q3_fin
    f_3_2:
    movl    $0, %edi
    call print_bool

    q3_fin:

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

print_bool:
	pushq	%rbp
	movq	%rsp, %rbp

	testl	%edi, %edi
    jz print_false
	leaq	.true_str(%rip), %rsi
    jmp print_bool_fin

print_false:
	leaq	.false_str(%rip), %rsi

print_bool_fin:
	leaq	.bool_str(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf

	movl	$0, %eax
	popq	%rbp
	ret
