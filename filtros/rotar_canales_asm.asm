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

		mov r12, [rdi]	 ; subo a r10 2 pixeles
		
		mov r11b, [r12] ; subo a r11b un byte
		shr r12, 8
		mov r10b, [r12]
		shr r12, 8
		mov r9b, [r12]
		shr r12, 8
		mov r8b, [r12]
		shr r12, 8
		
		mov r13b, r10b
		shl r13, 8
		or r13b, r8b
		shl r13, 8
		or r13b, r9b
		shl r13, 8
		or r13b, r11b
		
		mov r11b, [r12] ; subo a r11b un byte
		shr r12, 8
		mov r10b, [r12]
		shr r12, 8
		mov r9b, [r12]
		shr r12, 8
		mov r8b, [r12]
		
		mov r14b, r10b
		shl r14, 8
		or r14b, r8b
		shl r14, 8
		or r14b, r9b
		shl r14, 8
		or r14b, r11b
		
		shl r14, 32
		or r14, r13

		mov [rsi], r14
		add rsi, 8
		add rdi, 8


		sub rax, 2			; procese dos pixeles
				
		jmp .ciclo
			
	.fin:

		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		
		ret
