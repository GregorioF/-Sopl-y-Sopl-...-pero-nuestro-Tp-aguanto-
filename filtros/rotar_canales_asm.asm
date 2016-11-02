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

	push rbp
	mov rbp, rsp ;a|b|g|r --> a|g|r|b
	push rbx
	push r12
	push r13
	push r14

	xor rax, rax
	mov eax, edx	; en eax tengo la cnatidad de columnas
	mul ecx			; en rax tengo la  cantidad d pilxeles totales

	.ciclo:
		
		cmp rax,  0 
		je .fin

		xor r8, r8
		xor r9, r9
		xor r10, r10
		xor r11, r11
		xor r12, r12
		xor r13,r13
		xor r14,r14

		mov r11b, [rdi]	 ; subo a r10 1  pixelesbyte a
		inc rdi ; 
		mov r10b, [rdi] ; siguiente byte b
		inc rdi
		mov r9b, [rdi] ; g
		inc rdi
		mov r8b, [rdi] ;r
		inc rdi

		mov [rsi], r9b	
		mov [rsi+1], r10b
		mov [rsi+2], r8b
		mov [rsi+3], r11b

		sub rax, 1			; procese ya dos pixeles
				
		jmp .ciclo
			
	.fin:

		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		
		ret
