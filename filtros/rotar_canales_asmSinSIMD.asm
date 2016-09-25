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

		mov r10, [rdi]	 ; subo a r10 2  pixeles
		
		mov r8d, r10d ; muevo la parte baja
		shr r10, 32 ; shifteo a la derecha 4 bytes
		mov r9d, r10d ; muevo la parte alta

		mov r11b, r8b ; muevo el r
		shr r8d, 8 ; shifteo 1 byte
		mov r12b, r8b ; muevo el g
		shr r8d, 8
		mov r13b, r8b ; muevo el b
		shr r8d, 8
		mov r14b, r8b ; muevo el a

		mov [rsi], r12b	
		mov [rsi+1], r13b
		mov [rsi+2], r11b
		mov [rsi+3], r14b

		xor r11, r11
		xor r12, r12
		xor r13,r13
		xor r14,r14

		mov r11b, r9b ; muevo el r
		shr r9d, 8 ; shifteo 1 byte
		mov r12b, r9b ; muevo el g
		shr r9d, 8
		mov r13b, r9b ; muevo el b
		shr r9d, 8
		mov r14b, r9b ; muevo el a

		mov [rsi+4], r12b	; reescribo y lesto
		mov [rsi+5], r13b
		mov [rsi+6], r11b
		mov [rsi+7], r14b
		
		sub rax, 2			; procese ya dos pixeles
		add rdi, 8
		add rsi, 8
		
		jmp .ciclo
			
	.fin:

		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		
		ret
