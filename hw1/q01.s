	.file	"q01.c"
	.text
	.section	.rodata
.LC0:
	.string	"n = %d\n"
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$42, %esi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	popq	%rbp
	ret
