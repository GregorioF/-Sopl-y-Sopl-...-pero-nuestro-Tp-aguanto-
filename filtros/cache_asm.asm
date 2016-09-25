section .data
DEFAULT REL



section .text
global cache_asm

cache_asm:

	push rbp
	mov rbp, rsp
	xor r9, r9 ; va a contar mis iteraciones
	
	.ciclo:
		push r9
		mov r10, [rsp]
		mov r11, [rsp]
		add r10, r11
		inc r9
		cmp r9, tam_cache
		jne .ciclo

	pop rbp

	ret
