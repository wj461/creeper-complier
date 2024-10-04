.equ N, 15

        .text
	.globl	main

main:

	movl $0, %edi
	movl $1, %esi
	sal	$N, %esi
	subl $1, %esi
	call f
	movl %eax, %edi
	call print

	xorq    %rax, %rax
	ret

f:
	pushq	%rbp
	movq	%rsp, %rbp
    subq    $36, %rsp
	# 32 = i, 36 = c
	movl %edi, -32(%rbp)
	movl %esi, -36(%rbp)

	# if (i == N)
	cmp $N, %edi
	je return_0

	#cal key
	movl    %esi, %r8d
	sal		$4, %r8d
	or		%edi,%r8d

	# -4 = key
    movl    %r8d, -4(%rbp)
	# -8 = r
	leaq memo(%rip), %r9
	movl (%r9, %r8, 4), %r10d
	movl %r10d, -8(%rbp)

	# if (r != 0)
	cmpl $0, -8(%rbp)
	jne return_r

	# -12,s = 0 -16,j = 0
	movl $0, -12(%rbp)
	movl $0, -16(%rbp)
	# -20 col
	loop:
	# cal col
	movl $1, -20(%rbp)
	movl -16(%rbp), %ecx
	movl -20(%rbp), %r10d
	sall %cl, %r10d
	movl %r10d, -20(%rbp)
	movl -20(%rbp), %r8d
	# and c & col
	andl -36(%rbp), %r8d
	cmp $0, %r8d
	je not_save_s

	# -24 = x
	movl -32(%rbp), %r8d
	imull $N, %r8d
	addl -16(%rbp), %r8d
	# get m = -28
	leaq m(%rip), %r9
	movl (%r9, %r8, 4), %r10d
	movl %r10d, -28(%rbp)
	# change 1st++, 2nd-col arg
	movl -32(%rbp), %edi
	addl $1, %edi
	movl -36(%rbp), %esi
	subl -20(%rbp), %esi
	call f
	addl -28(%rbp), %eax
	movl %eax, -24(%rbp)

	# if x>s
	movl -24(%rbp), %r10d
	cmpl %r10d, -12(%rbp)
	jg not_save_s
	movl -24(%rbp), %r10d
	movl %r10d, -12(%rbp)

	not_save_s:
	addl $1, -16(%rbp)
	cmpl  $N, -16(%rbp)
	jl loop

	# end loop
	leaq memo(%rip), %r9
	movl -12(%rbp), %r10d
	movl -4(%rbp), %r8d
	movl %r10d, (%r9, %r8, 4)

	movl	-12(%rbp), %eax
    addq    $36, %rsp
	popq	%rbp
	ret

	return_0:
	xorq	%rax, %rax
    addq    $36, %rsp
	popq	%rbp
	ret

	return_r:
	movl	-8(%rbp), %eax
    addq    $36, %rsp
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

.data
format: .string	"solution = %d\n"
m:
	.long	7
	.long	53
	.long	183
	.long	439
	.long	863
	.long	497
	.long	383
	.long	563
	.long	79
	.long	973
	.long	287
	.long	63
	.long	343
	.long	169
	.long	583
	.long	627
	.long	343
	.long	773
	.long	959
	.long	943
	.long	767
	.long	473
	.long	103
	.long	699
	.long	303
	.long	957
	.long	703
	.long	583
	.long	639
	.long	913
	.long	447
	.long	283
	.long	463
	.long	29
	.long	23
	.long	487
	.long	463
	.long	993
	.long	119
	.long	883
	.long	327
	.long	493
	.long	423
	.long	159
	.long	743
	.long	217
	.long	623
	.long	3
	.long	399
	.long	853
	.long	407
	.long	103
	.long	983
	.long	89
	.long	463
	.long	290
	.long	516
	.long	212
	.long	462
	.long	350
	.long	960
	.long	376
	.long	682
	.long	962
	.long	300
	.long	780
	.long	486
	.long	502
	.long	912
	.long	800
	.long	250
	.long	346
	.long	172
	.long	812
	.long	350
	.long	870
	.long	456
	.long	192
	.long	162
	.long	593
	.long	473
	.long	915
	.long	45
	.long	989
	.long	873
	.long	823
	.long	965
	.long	425
	.long	329
	.long	803
	.long	973
	.long	965
	.long	905
	.long	919
	.long	133
	.long	673
	.long	665
	.long	235
	.long	509
	.long	613
	.long	673
	.long	815
	.long	165
	.long	992
	.long	326
	.long	322
	.long	148
	.long	972
	.long	962
	.long	286
	.long	255
	.long	941
	.long	541
	.long	265
	.long	323
	.long	925
	.long	281
	.long	601
	.long	95
	.long	973
	.long	445
	.long	721
	.long	11
	.long	525
	.long	473
	.long	65
	.long	511
	.long	164
	.long	138
	.long	672
	.long	18
	.long	428
	.long	154
	.long	448
	.long	848
	.long	414
	.long	456
	.long	310
	.long	312
	.long	798
	.long	104
	.long	566
	.long	520
	.long	302
	.long	248
	.long	694
	.long	976
	.long	430
	.long	392
	.long	198
	.long	184
	.long	829
	.long	373
	.long	181
	.long	631
	.long	101
	.long	969
	.long	613
	.long	840
	.long	740
	.long	778
	.long	458
	.long	284
	.long	760
	.long	390
	.long	821
	.long	461
	.long	843
	.long	513
	.long	17
	.long	901
	.long	711
	.long	993
	.long	293
	.long	157
	.long	274
	.long	94
	.long	192
	.long	156
	.long	574
	.long	34
	.long	124
	.long	4
	.long	878
	.long	450
	.long	476
	.long	712
	.long	914
	.long	838
	.long	669
	.long	875
	.long	299
	.long	823
	.long	329
	.long	699
	.long	815
	.long	559
	.long	813
	.long	459
	.long	522
	.long	788
	.long	168
	.long	586
	.long	966
	.long	232
	.long	308
	.long	833
	.long	251
	.long	631
	.long	107
	.long	813
	.long	883
	.long	451
	.long	509
	.long	615
	.long	77
	.long	281
	.long	613
	.long	459
	.long	205
	.long	380
	.long	274
	.long	302
	.long	35
	.long	805
        .bss
memo:
        .space	2097152

## Local Variables:
## compile-command: "gcc matrix.s && ./a.out"
## End:
