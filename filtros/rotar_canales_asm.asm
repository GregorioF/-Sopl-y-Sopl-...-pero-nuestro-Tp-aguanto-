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

	.ciclo:
		cmp rax,  0 
		je .fin
		mov r10, [rdi]	 ; subo a r10 2  pixeles
		mov r11, r10
		pslld r10, 2 ; |g|r|0|0
		psrld r10, 1 ; 0|g|r|0
		movq r9, r11
		pslld r9, 1 ; a|b|g|r --> b|g|r|0
		psrld r9, 3 ; b|g|r|0 --> 0|0|0|b
		psrld r11, 3 ; a|b|g|r --> 0|0|0|a
		pslld r11, 3 ; 0|0|0|a --> a|0|0|0
		paddb r11, r9 ; a|0|0|b
		paddb r10, r11 ; a|g|r|b
		
		movq [rsi], r10	; reescribo y lesto
		
		sub rax, 2			; procese ya cuatro pixeles
		add rdi, 8
		add rsi, 8
		jmp .ciclo
			
	.fin:
		ret
