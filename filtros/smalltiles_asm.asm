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

	shr r12,1 ;psrlq r12, 1
	shr rbx,1 ;psrlq rbx, 1

	xor r8, r8 ; contador
	;rax = cant de bytes de una de las 4 imagenes destino
	mov rax, r12
	mul rdx

	;mascara:
	mov r10, 0x0b0a090803020100
	movq xmm2, r10
	pslldq xmm2, 8
	movq xmm3, r10
	por xmm2, xmm3 ;|me queda: pixel3|pixel1|pixel3|pixel1 xq solo quiero los pares

	.ciclo:

		add r8, 16 							; voy a procesar 4 pixeles, x ende 16 bytes
		movups xmm0, [rdi] 					; guardo en xmm0 los 4 pixeles de src (3,2,1,0)
		lea rdi, [rdi + 16] 				; ahora apunto a los siguiente 4
		movups xmm1, [rdi] 					; guardo en xmm1 los siguientes 4 pixeles de src (7,6,5,4)
		pshufb xmm0, xmm2 					; xmm0 = |pixel2|pixel0|pixel2|pixel0
		pshufb xmm1, xmm2 					; xmm1 = |pixel6|pixel4|pixel6|pixel4
		psrldq xmm0, 8 						; xmm0 = 0|0|pixel2|pixel0
		psrldq xmm1, 8 						; xmm1 = 0|0|pixel6|pixel4
		pslldq xmm1, 8 						; xmm1 = pixel6|pixel4|0|0 
		por xmm1, xmm0 						; me queda |xmm1|xmm0 osea |pixel6|pixel4|pixel2|pixel0

		movdqu [rsi], xmm0
		movdqu [rsi + rbx], xmm0 			; sumo la cant de bytes hasta el final de la columna
		mov r9, rax
		add r9, rax
		movdqu [rsi + r9], xmm0 			; sumo la cant de bytes de 2 mini fotos
		add r9, r9 
		movdqu [rsi + r9], xmm0 			; sumo la cant de bytes de 3 mini fotos 

		lea rdi, [rdi + 16] 				; procese 4 pixeles desde q sume
		lea rsi, [rsi + 16] 				; procese 4 pixeles

		cmp r8, rax
		jne .ciclo

	pop r12
	pop rbx
	pop rbp
	ret
