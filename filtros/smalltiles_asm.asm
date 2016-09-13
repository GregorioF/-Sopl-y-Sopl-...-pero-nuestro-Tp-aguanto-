%define i [rbp-8]
%define j [rbp-16]

section .data
DEFAULT REL

section .text
global smalltiles_asm
; void smalltiles_c (unsigned char *src, unsigned char *dst, int cols, int filas, int src_row_size, int dst_row_size) {
smalltiles_asm:
; rdi = src
; rsi = dst
; rdx = cols
; rcx = filas
	push rbp
	mov rbp, rsp
	sub rsp, 8
	sub rsp, 8
	push r12

	mov rax, rdx
	shr rax,1
	mov i, rax 	; en i tengo la mitad de columnas que hay

	mov rax, rdx
	shl rax, 2 ; tengo el tamaño de fila en rax

	mov r12, rcx	; en r12 tengo la cantidad de filas que hay
	shr r12, 1		; ahora la mitad
	mov qword j, 0
	.opAux:
		add j, rax	; por cada fila le sumo a j 
		sub r12, 1
		cmp r12, 0
		jne .opAux

	mov r12, j

	xor r9, r9 												; va a ser mi currrent de filas

	.ciclo:
			xor r8, r8 										; va a ser mi curren de cols
			xor r11, r11										; va a ser mi current sobre src
			cmp rcx, r9
			jle .fin 											; si termine de recorrer todas mis filas me voy
			.ciclo2:
				movdqu xmm1, [rdi+r8*4] 			; le meto a mi xmm1 cutro pixeles de donde me qde
				movdqu xmm2, xmm1
				pshufd xmm1, xmm2,  0xd8 			; los dos pixeles que me importan ahora estan en la parte alta
				movdqu xmm10, [rdi+r8*4+16]	 	; le meto a mi xmm10 cuatro pixeles siguiente a los de xmm1
				movdqu xmm2, xmm10
				pshufd xmm10, xmm2, 0x2d			; los dos pixeles que me importan ahora estan en la parte baja de xmm10

				psrldq xmm1, 8
				pslldq xmm10, 8

				paddb xmm10, xmm1 						; en xmm10 tengo los cuatro pixeles que me importan de los 8 que lei
																			; en orden reverso porq asi es como los ovy a imprimir desp
				movdqu [rsi+r11*4], xmm10
				mov r10, r11
				add r10, i
				movdqu [rsi+r10*4], xmm10			; escribo en  la segunda imagen


				lea r10 , [r12+r11*4]

				movdqu [rsi+r10], xmm10
				
				mov r10, r11
				add r10, i
				
				lea r10, [r12+ r10*4]
				movdqu [rsi +r10], xmm10

				add r8, 8
				add r11, 4
				cmp r8, rdx
				jne .ciclo2

				add r9, 2
				add rdi, rax
				add rdi, rax
				add rsi, rax
				jmp .ciclo


	.fin:
		pop r12
		add rsp, 8
		add rsp,8
		pop rbp
		ret
