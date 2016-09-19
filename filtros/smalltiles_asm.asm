section .data
DEFAULT REL

section .text
global smalltiles_asm

smalltiles_asm:
	push rbp
	mov rbp, rsp
	push rbx
	push r12

	mov rbx, rdx ; rbx = cantidad de bytes x fila
	mov r12, rcx ; r12 = cant de filas

	xor r10, r10
	mov rax, rbx
	mul r12
	;rax = cant de bytes total
	mov r10, rax ; r10 = cant de pixeles totales
	;shr rax, 2
	
	xor r8, r8 ; contador
	;rax = cant de bytes de una de las 4 imagenes destino
	
	shl rbx,1

	.ciclo:

		add r8, 8 							; voy a procesar 8 pixeles
		movups xmm0, [rdi] 					; guardo en xmm0 los 4 pixeles de src (3,2,1,0)
		lea rdi, [rdi + 16] 				; ahora apunto a los siguiente 4
		movups xmm1, [rdi] 					; guardo en xmm1 los siguientes 4 pixeles de src (7,6,5,4)
		pshufd xmm0, xmm0 , 0xdd			; xmm0 = |pixel4|pixel2|pixel4|pixel2
		pshufd xmm1, xmm1 , 0xdd			; xmm1 = |pixel8|pixel6|pixel8|pixel6
		psrldq xmm0, 8 						; xmm0 = 0|0|pixel2|pixel0
		pslldq xmm1, 8 						; xmm1 = pixel6|pixel4|0|0 
		paddb xmm0, xmm1 						; me queda |xmm1|xmm0 osea |pixel6|pixel4|pixel2|pixel0

		movups [rsi], xmm0
		movups [rsi + r9], xmm0 			; sumo la cant de bytes hasta el final de la columna
		mov r9, rax
		add r9, rax
		
		movups [rsi + r9], xmm0 			; sumo la cant de bytes de 2 mini fotos 
		;add r9, r9
		;movups [rsi + r9], xmm0

		lea rdi, [rdi + 16] 				; procese 4 pixeles desde q sume
		lea rsi, [rsi + 16] 				; procese 4 pixeles

		cmp r8, r10
		jne .ciclo

	pop r12
	pop rbx
	pop rbp
	ret
