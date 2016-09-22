section .data
DEFAULT REL

section .text
global smalltiles_asm

smalltiles_asm:
	push rbp
	mov rbp, rsp
	push rbx
	push r12

	mov rbx, rdx ; rbx = cantidad de columnas
	mov r12, rcx ; r12 = cant de filas

	shl rbx, 1 ; rbx = cant de columnas x fotito


	mov rax, r9
	mul rcx
	; rax = cant de pixeles totales
	mov r12, rax
	shr r12, 1 ; r12 = cant de pixeles x imagen

	xor r8, r8
	sub rdi, 4
	mov r11, rbx


	.ciclo:
		
		.subCiclo:

			cmp r8,rax
			je .fin

			movdqu xmm0, [rdi+r8] 					; guardo en xmm0 los 4 pixeles de src (3,2,1,0)
			add r8, 16
			movdqu xmm1, [rdi+r8] 					; guardo en xmm1 los siguientes 4 pixeles de src (7,6,5,4)
			pshufd xmm0, xmm0 , 0xdd			; xmm0 = |pixel2|pixel0|pixel2|pixel0
			pshufd xmm1, xmm1 , 0xdd			; xmm1 = |pixel6|pixel4|pixel6|pixel4
			psrldq xmm0, 8 						; xmm0 = 0|0|pixel2|pixel0
			pslldq xmm1, 8 						; xmm1 = pixel6|pixel4|0|0 
			paddb xmm0, xmm1 					; me queda |xmm1|xmm0 osea |pixel6|pixel4|pixel2|pixel0
		
			add r8, 16 							; procesé 8 pixeles

			;movdqu [rsi], xmm0
			movdqu [rsi+rbx], xmm0
			mov r9, r12
			;movdqu [rsi+r9], xmm0
			add r9, rbx
			movdqu [rsi+r9], xmm0
			
			lea rsi, [rsi + 16]

			cmp rsi, r11
			jne .subCiclo


		add r10, rbx
		inc r10
		add r11, rbx
		add r11, rbx	
		cmp r8,rax
		jne .ciclo

	.fin:

	pop r12
	pop rbx
	pop rbp
	ret

