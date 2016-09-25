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


		HacerMascaras:
		
		mov r8, 0x0704060503000201
				
	.ciclo:
		cmp rax,  0 
		je .fin
		mov r10, [rdi]	 ; subo a r10 2  pixeles
		pshufb r10, r8	; shufleee!
		mov [rsi], r10	; reescribo y lesto
		
		sub rax, 2			; procese ya cuatro pixeles
		add rdi, 8
		add rsi, 8
		jmp .ciclo
			
	.fin:
		ret
