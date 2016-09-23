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
	push rbx
	push r12


		mov r8, rdx ; mi largo de fila 
		shr r8, 1 ; largo de media fila

		mov rax, rdx
		mul rcx
		
		mov r9, rax ; r9 = mitad de imagen source
		shl r9, 1

		mov r12, r8
		add r12, r9

		mov r10, 1 ; r10 = contador de filas
		xor rbx, rbx ; contador de columnas
		shl rcx, 2

		.ciclo:

			mov r11d, [rdi]
			mov [rsi], r11d
			mov [rsi + r8], r11d
			mov [rsi + r9], r11d
			mov [rsi + r12], r11d 

			lea rdi, [rdi + 8] ; sumo 2 pixeles
			lea rsi, [rsi + 4] ; sumo 1 pixel
						
			add rbx, 4
			cmp rbx, r8

			jne .ciclo

			xor rbx, rbx 
			inc r10
			lea rsi, [rsi + rbx]
			cmp rcx, r10
			
			jne .ciclo

		pop r12
		pop rbx
		pop rbp

		ret
