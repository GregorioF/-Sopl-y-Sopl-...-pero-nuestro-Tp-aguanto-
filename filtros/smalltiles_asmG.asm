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
	mov i, rax 		; en i tengo la mitad de columnas que hay

	mov rax, rdx
	shl rax, 2 		; rax = rdx*4 = tamño de fila

	mov r12, rcx	; en r12 tengo la cantidad de filas que hay
	shr r12, 1		; ahora la mitad
	mov qword j, 0
	sub rdi, 4
	
		
	.opAux:
		add j, rax	; por cada fila le sumo a j 
		sub r12, 1
		cmp r12, 0
		jne .opAux

	mov r12, j			; ahora r12 = #cols*4*#filas/2 (para saltar media imagen)

	xor r9, r9 												; va a ser mi currrent de filas

	.ciclo:
			xor r8, r8 											; va a ser mi curren de cols
			xor r11, r11										; va a ser mi current sobre src
			
			cmp rcx, r9
			jle .fin 											; si termine de recorrer todas mis filas me voy
			.ciclo2:
				movdqu xmm1, [rdi+r8*4] 			; xmm1 = p4|p3|p2|p1
				movdqu xmm2, xmm1					; xmm2 = xmm1
				pshufd xmm1, xmm2,  0xd8 			; xmm1 = p4|p2|p3|p1      los dos pixeles que me importan ahora estan en la parte alta
				movdqu xmm10, [rdi+r8*4+16]	 		; xmm10 = p8|p7|p6|p5   le meto a mi xmm10 cuatro pixeles siguiente a los de xmm1
				movdqu xmm2, xmm10					; xmm2 = xmm10
				pshufd xmm10, xmm2, 0x2d			; xmm10 = p5|p7|p8|p6   los dos pixeles que me importan ahora estan en la parte baja de xmm10

				psrldq xmm1, 8						; xmm1 = 0|0|p4|p2
				pslldq xmm10, 8						; xmm10 = p8|p6|0|0

				paddb xmm10, xmm1 					; xmm10 = p8|p6|p4|p2		
				
				movdqu [rsi+r11*4], xmm10
				mov r10, r11
				add r10, i							; i acordarse que es igual a la mitad d las coulmnas 
				movdqu [rsi+r10*4], xmm10			; escribo en  la segunda imagen


				lea r10 , [r12+r11*4]				; para escribir en la tercer imagen

				movdqu [rsi+r10], xmm10				; lesto
				
				mov r10, r11			
				add r10, i
				
				lea r10, [r12+ r10*4]
				movdqu [rsi +r10], xmm10			; escribo en la cuarta imagen

				add r8, 8							; lo avanzo cuatro numeros
				add r11, 4							; imprimi cuatro pixeles en cada imagen
				cmp r8, rdx							; 
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
