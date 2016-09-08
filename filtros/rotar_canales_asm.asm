section .data
DEFAULT REL



section .text
global rotar_asm
;unsigned char *src, unsigned char *dst, int cols, int filas, int src_row_size, int dst_row_size
rotar_asm:
; rdi = putnero a matriz src
; rsi = puntero a matriz dst
; edx = cantidad de columnas
; ecx = cantidad de filas
	xor rax, rax
	mov eax, edx	; en eax tengo la cnatidad de columnas
	mul ecx			; en rax tengo la  cantidad d pilxeles totales
	
	.HacerMascaras:
		mov r8, 0x0000ff000000ff00
		movq xmm3, r8
		pslldq xmm3, 8
		movq xmm3, r8		; LO QUE HAGO ACA ES CREAR UNA MASCARA EN XMM3, TAL QUE SI HAGO AND CON XMM0 ME QDE LOS BYTES DE BLUE Y GREEN NADA MAS
		
		mov r9, 0xffff0000ffff0000
		movq xmm4, r9
		pslldq xmm4, 8
		movq xmm4, r9		; lo mismo pero ahora me qdarian red y transaprecia
				
	.ciclo:
		cmp rax,  0 
		je .fin
		movdqu xmm0, [rdi]	 ; subo a xmm0 4  pixeles
		movdqu xmm1, xmm0	; copio lo que levante en xmm0
		movdqu xmm2, xmm0	; copio lo que levante en xmm0 
		pslldq xmm0, 1		; corro todo un bbyte a la izquierda ya puse olos valores correspondientes en blue y green falta el del red
		pand xmm0, xmm4		; en xmm0, las posiciones donde van red y transp me qdan en 0
		
		psrldq xmm1, 2		; ahora el blue me qda en la posicion del red
		pand xmm1, xmm3		; ahora me qdan todos los bits en cero menos los del valor del red
		
		paddsb xmm0, xmm1	; ahora me qda con repecto a los valores iniciales  g|r|b|0 , me flata setear el a
		
		
		pslldq xmm2, 1		; ahjora la transparencia me qda en la posicion del red
		pan xmm2, xmm3		; ahora me qda todos los bytes en cero menos los del valor de red, donde est ala transparencia
		psrldq xmm2, 1		; vuelvo la transparencia a su lugar inicial
		
		paddsb xmm0, xmm2	; ahora me qda con respecto a los valores iniciales g|r|b|a y listo
		
		movdqu [rsi], xmm0
		
		sub rax, 4			; procese ya cuatro pixeles
		add rdi, 16
		add rsi, 16
		jmp .ciclo
			
	.fin:
		ret
