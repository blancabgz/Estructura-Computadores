.section .data
#lista:		.int 1,2,10,  1,2,0b10,  1,2,0x10
lista:  .int 1,1,1,1
        .int 1,1,1,1
        .int 1,1,1,1
        .int 1,1,1,1
longlista:	.int   (.-lista)/4
resultado:	.int   0
  formato: 	.asciz	"suma = %u = 0x%x hex\n"

# opción: 1) no usar printf, 2)3) usar printf/fmt/exit, 4) usar tb main
# 1) as  suma.s -o suma.o
#    ld  suma.o -o suma					1232 B
# 2) as  suma.s -o suma.o				6520 B
#    ld  suma.o -o suma -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
# 3) gcc suma.s -o suma -no-pie –nostartfiles		6544 B
# 4) gcc suma.s -o suma	-no-pie				8664 B

.section .text
#_start: .global _start
main: .global  main
	mov     $lista, %rbx
	mov  longlista, %ecx
	call suma		# == suma(&lista, longlista);
	mov  %eax, resultado

  #require libC
  mov   $formato, %rdi
  mov   resultado,%esi
  mov   resultado,%edx
  mov          $0,%eax	# varargin sin xmm
  call  printf		# == printf(formato, res, res);

  #require libC
  mov  resultado, %edi
  call _exit		# ==  exit(resultado)

suma:
	push     %rdx
	mov  $0, %eax
	mov  $0, %rdx
bucle:
	add  (%rbx,%rdx,4), %eax
	inc   %rdx
	cmp   %rdx,%rcx
	jne    bucle

	pop   %rdx
	ret
