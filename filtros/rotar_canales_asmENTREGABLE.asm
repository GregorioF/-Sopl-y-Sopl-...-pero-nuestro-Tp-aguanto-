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
		pxor xmm4, xmm4
		mov r8, 0x0f0c0e0d0b080a09 	; hago la mascara para shuffle
		
		movq xmm3, r8
		pslldq xmm3, 8
		mov r8, 0x0704060503000201
		movq xmm4, r8
		por xmm3, xmm4	 	; termine de hacer la mascara para shufle si el pixel x era = a|b|g|r ahora con shufle
							; va a ser igual a  a|g|r|b
		
	.ciclo:
		cmp rax,  0 
		je .fin
		movdqu xmm0, [rdi]	 ; subo a xmm0 4  pixeles
		pshufb xmm0, xmm3	; shufleee!
		;psrldq xmm0, 1
		movdqu [rsi], xmm0	; reescribo y lesto
		
		sub rax, 4			; procese ya cuatro pixeles
		add rdi, 16
		add rsi, 16
		jmp .ciclo
			
	.fin:
		ret
