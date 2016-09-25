; void pixelar_asm (
; 	unsigned char *src,
; 	unsigned char *dst,
; 	int cols,
; 	int filas,
; 	int src_row_size,
; 	int dst_row_size
; );

; Parámetros:
; 	rdi = src
; 	rsi = dst
; 	rdx = cols
; 	rcx = filas
; 	r8 = src_row_size
; 	r9 = dst_row_size

extern pixelar_c

global pixelar_asm

section .text

pixelar_asm:
	pxor xmm10, xmm10	; foward clean

	mov r8, rdx
	shl r8, 2		; tengo en r8 el tamaño de fila

	.ciclo:
		mov r9, 0		; en r9 voy a llevar mi current sobre columnas
		cmp rcx, 0
		je .fin

		.ciclo2:
			mov r10, r9
			shl r10, 2									;Lo que hice fue poner en que columna estoy y le multiplico el tamaño de las unidades
			movdqu xmm0, [rdi+r10]			; tengo en xmm0 la linea superior de los pixeles sobre los  q voy a trabajar
			add r10, r8 								; esta operacion es para acceder a los pixeles de la linea inferior
			movdqu xmm1, [rdi+r10]			; tengo en xmm1 la linea inferior de los pixeles sobre los q voy a trabajar

		;======== pongo las sumatorias correspondientes en los registros xmm3 y xmm5
			movdqu xmm3, xmm0					; pongo los valores de la priemr linea en xmm3
			punpckhbw xmm3, xmm10			; extiendo los valores de la parte alta
			movdqu xmm4, xmm1					; pongo lo valores de la segunad linea en xmm4
			punpckhbw xmm4, xmm10			; extiendo los valores de la parte alta
			paddsw xmm3, xmm4					; en xmm3 tengo la sumatoria de los pixeles de la primer linea con su respectivo de la segunda linea

			movdqu xmm6, xmm3
			pslldq xmm3, 8
			paddsw xmm3, xmm6 	  		; en la parte alta de xmm3 me qda la sumatoria de los cuatro pixeles.

	    psrlw xmm3, 2						; divido cada valor por cuatro


			;; Esta operacion es para duplicar el valor de la parte alta en la parte baja
			;; para cuando los empaquete que me qde como deseo
			psrldq xmm3, 8
			movdqu xmm11, xmm3
			pslldq xmm3, 8
			paddsw xmm3, xmm11
		;===================================================

			punpcklbw xmm0, xmm10			; extiendo los valores de la parte baja
			;movdqu xmm4, xmm1					; pongo los valores de la segunda linea en xmm4
			punpcklbw xmm1, xmm10			; extiendo los valores de la parte baja
			paddsw xmm0, xmm1					; en xmm0 tengo la sumatoria de los pixeles de la primer linea con su respectivo de la segunda linea

			movdqu xmm6, xmm0
			psrldq xmm6, 8
			paddsw xmm0, xmm6			; en la parte baja de xmm0, me qda la sumatoria de los cuatro pixeles inferiores


	    psrlw xmm0, 2						; divido cada valor por cuatro
			pslldq xmm0, 8
			movdqu xmm11, xmm0
			psrldq xmm0, 8
			paddsw xmm0, xmm11
		;===================================================

			packuswb xmm0, xmm3 		; en xmm0 tengo el resultado final

			mov r10, r9
			shl r10, 2							; multiplico r10 porq el tamaño de los bgra
			movdqu [rsi+r10], xmm0
			add r10, r8
			movdqu [rsi+r10], xmm0

			; =====================   actualizo currents
			add r9, 4							; avanzo cuatro columnas
			cmp r9, rdx
			jne .ciclo2		; no llegue al final, vuelvo al ciclo 2

			add rdi, r8		; llegue al final y muevo dos lineas para abajo rdi y rsi
			add rdi, r8
			add rsi, r8
			add rsi, r8
			sub rcx, 2
			jmp .ciclo


.fin:
	ret
