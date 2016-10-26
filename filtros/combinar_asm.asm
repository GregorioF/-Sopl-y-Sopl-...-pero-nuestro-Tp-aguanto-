; void combinar_asm (
; 	unsigned char *src,
; 	unsigned char *dst,
; 	int cols,
; 	int filas,
; 	int src_row_size,
; 	int dst_row_size,
; 	float alpha
; );

; Parámetros:
; 	rdi = src
; 	rsi = dst
; 	rdx = cols
; 	rcx = filas
; 	r8 = src_row_size
; 	r9 = dst_row_size
; 	xmm0 = alpha

global combinar_asm

extern combinar_c
extern imprimirArchivo


section .data
	form: db "%d", 10
	texto: db "tiemposCombinar.txt", 0
	puntero: db 0
	current : db 0

section .rodata
		mascara255: dd 255.0, 255.0, 255.0, 255.0
		menos1: dd -1.0, -1.0, -1.0, -1.0

section .text

combinar_asm:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15

	
	push rdi
	push rsi
	push rdx
	push r8
	push r9

	mov rdi, 1024
	call malloc
	mov puntero, rax

	pop r9
	pop r8
	pop rdx
	pop rsi
	pop rdi

	sub rsp, 8


	pxor xmm9, xmm9
	xor r10, r10 ; pongo un 0 en mi contador de filas
	xor r9, r9 ; pongo un 0 en mi contador de iteraciones
	xor r11, r11
	xor r14, r14
	pshufd xmm0, xmm0, 00000000b ; El alpha era un float que sólo estaba en los "primeros" (últimos) 4 bytes de xmm0, entonces no iba a multiplicar bien.
																; Paso el alpha a los otros lugares: xmm0 == | alpha | alpha | alpha | alpha |
	movdqu xmm14, [mascara255] ; paso a un registro lo de la máscara fuera de los ciclos porque como es un acceso a memoria quiero minimizar la cantidad de veces que se hace.
	mov rax, rdx ; muevo el ancho de las filas (en píxeles) a rax
	xor rdx, rdx ; rdx == 0
	mov rbx, 8
	div rbx ; divido por 8. Queda en rax el cociente de la división y en rdx el resto.

	
.cicloExterno:
		cmp r10, rcx ; comparo r10 con la cantidad de filas
		je .fin ; si es igual ya terminó de recorrer la matriz y salto al final
		xor r9, r9  ; si no, pongo un 0 en el contador de columnas y voy al ciclo Interno
		xor rbx, rbx ; rbx == 0
		mov r14, r9 ; r14 == 0
		mov r11, rdi ; r11 == rdi
		add r11, r8 ; r11 == rdi + tamaño de la fila
		sub r11, 16 ; r11 == rdi + tamaño de la fila - 16
		mov r12, rsi ; r12 == rsi
		add r12, r8 ; r12 == rsi + tamaño de la fila
		sub r12, 16 ; r12 == rsi + tamaño de la fila - 16

			.cicloInterno:

					cmp rbx, rax ; comparo rbx con la cantidad de veces que entran 8 píxeles, con el cociente de la división.
					je .QuizasFaltaProcesar ; si no es igual falta procesar píxeles en esa fila
					
					push rax
					push rdx
					rdtscp  ;; AGREGOOOO!
					mov rdx, current
					mov [puntero + rdx*8], rax

					movdqu xmm1, [rdi + 4*r9] ; agarro 4 píxeles de la mitad izquierda de la foto		; xmm1 = p3|p2|p1|p0
					movdqu xmm2, xmm1

					movdqu xmm3, [r11 + 4*r14] ; agarro 4 píxeles de la mitad derecha de la foto		; xmm3 = p7|p6|p5|p4
					movdqu xmm4, xmm3
					

					rdtscp
					inc current
					mov rdx, current
					mov [puntero + rdx*8], rax
					inc current
					pop rdx
					pop rax

					punpcklbw xmm1, xmm9 ; | 0 | píxel 1 a | 0 | píxel 1 r | 0 | píxel 1 g | 0 | píxel 1 b | 0 | píxel 0 a | 0 | píxel 0 r | 0 | píxel 0 g | 0 | píxel 0 b |
					punpckhbw xmm2, xmm9 ; | 0 | píxel 3 a | 0 | píxel 3 r | 0 | píxel 3 g | 0 | píxel 3 b | 0 | píxel 2 a | 0 | píxel 2 r | 0 | píxel 2 g | 0 | píxel 2 b |
					punpcklbw xmm3, xmm9 ; | 0 | píxel 5 a | 0 | píxel 5 r | 0 | píxel 5 g | 0 | píxel 5 b | 0 | píxel 4 a | 0 | píxel 4 r | 0 | píxel 4 g | 0 | píxel 4 b |
					punpckhbw xmm4, xmm9 ; | 0 | píxel 7 a | 0 | píxel 7 r | 0 | píxel 7 g | 0 | píxel 7 b | 0 | píxel 6 a | 0 | píxel 6 r | 0 | píxel 6 g | 0 | píxel 6 b |

					movdqu xmm5, xmm1
					movdqu xmm6, xmm2
					movdqu xmm7, xmm3
					movdqu xmm8, xmm4

					punpcklwd xmm1, xmm9 ; | 0 | 0 | 0 | píxel 0 a | 0 | 0 | 0 | píxel 0 r | 0 | 0 | 0 | píxel 0 g | 0 | 0 | 0 | píxel 0 b |
					punpckhwd xmm5, xmm9 ; | 0 | 0 | 0 | píxel 1 a | 0 | 0 | 0 | píxel 1 r | 0 | 0 | 0 | píxel 1 g | 0 | 0 | 0 | píxel 1 b |
					punpcklwd xmm2, xmm9 ; | 0 | 0 | 0 | píxel 2 a | 0 | 0 | 0 | píxel 2 r | 0 | 0 | 0 | píxel 2 g | 0 | 0 | 0 | píxel 2 b |
					punpckhwd xmm6, xmm9 ; | 0 | 0 | 0 | píxel 3 a | 0 | 0 | 0 | píxel 3 r | 0 | 0 | 0 | píxel 3 g | 0 | 0 | 0 | píxel 3 b |
					punpcklwd xmm3, xmm9 ; | 0 | 0 | 0 | píxel 4 a | 0 | 0 | 0 | píxel 4 r | 0 | 0 | 0 | píxel 4 g | 0 | 0 | 0 | píxel 4 b |
					punpckhwd xmm7, xmm9 ; | 0 | 0 | 0 | píxel 5 a | 0 | 0 | 0 | píxel 5 r | 0 | 0 | 0 | píxel 5 g | 0 | 0 | 0 | píxel 5 b |
					punpcklwd xmm4, xmm9 ; | 0 | 0 | 0 | píxel 6 a | 0 | 0 | 0 | píxel 6 r | 0 | 0 | 0 | píxel 6 g | 0 | 0 | 0 | píxel 6 b |
					punpckhwd xmm8, xmm9 ; | 0 | 0 | 0 | píxel 7 a | 0 | 0 | 0 | píxel 7 r | 0 | 0 | 0 | píxel 7 g | 0 | 0 | 0 | píxel 7 b |

					movdqu xmm10, xmm1
					movdqu xmm11, xmm5
					movdqu xmm12, xmm2
					movdqu xmm13, xmm6

					psubd xmm10, xmm8 ; resto los 2 píxeles correspondientes, | 0 | 0 | 0 | píxel 0 a - píxel 7 a | 0 | 0 | 0 | píxel 0 r - píxel 7 r | 0 | 0 | 0 | píxel 0 g - píxel 7 g | 0 | 0 | 0 | píxel 0 b -píxel 7 b |
					psubd xmm11, xmm4 ; resto los 2 píxeles correspondientes
					psubd xmm12, xmm7 ; resto los 2 píxeles correspondientes
					psubd xmm13, xmm3 ; resto los 2 píxeles correspondientes

					cvtdq2ps xmm3, xmm3 ; xmm3 == | píxel 4 a | píxel 4 r | píxel 4 g | píxel 4 b |
					cvtdq2ps xmm7, xmm7	; xmm7 ==  pixel 5
					cvtdq2ps xmm4, xmm4 ; xmm4 == pixel 6
					cvtdq2ps xmm8, xmm8	; xmm8 == pixel 7
					cvtdq2ps xmm10, xmm10 ; xmm10 == | píxel 0 a - píxel 7 a | píxel 0 r - píxel 7 r | píxel 0 g - píxel 7 g | píxel 0 b - píxel 7 b |
					cvtdq2ps xmm11, xmm11 ; xmm11 == pixel 1 - pixel 6
					cvtdq2ps xmm12, xmm12 ; xmm12 == pixel 2 - pixel 5
					cvtdq2ps xmm13, xmm13 ; xmm13 == pixel 3 - pixel 4

					mulps xmm10, xmm0 ; Multiplico por alpha: xmm10 == | alpha *  | ... | ... | alpha *  | (pixel 0 - pixel 3)
					mulps xmm11, xmm0 ; xmm11 == alpha * ( pixel 1 - pixel 6)
					mulps xmm12, xmm0 ; xmm12 == alpha * ( pixel 2 - pixel 5)
					mulps xmm13, xmm0 ; xmm13 == alpha * ( pixel 3 - pixel 4)

					divps xmm10, xmm14 ; xmm10 == alpha * ( pixel 0 - pixel 7)  / 255
					divps xmm11, xmm14 ; xmm11 == alpha * ( pixel 1 - pixel 6)  / 255
					divps xmm12, xmm14 ; xmm12 == alpha * ( pixel 2 - pixel 5)  / 255
					divps xmm13, xmm14 ; xmm13 == alpha * ( pixel 3 - pixel 4)  / 255

; ============ Sumo el píxel de la parte espejada ==============
					addps xmm10, xmm8 ; xmm10 == ( alpha * ( pixel 0 - pixel 7)  / 255 )  + pixel 7 = dst 0
					addps xmm11, xmm4 ; xmm11 == ( alpha * ( pixel 1 - pixel 6)  / 255 )  + pixel 6 = dst 1
					addps xmm12, xmm7 ; xmm12 == ( alpha * ( pixel 2 - pixel 5)  / 255 )  + pixel 5 = dst 2
					addps xmm13, xmm3 ; xmm13 == ( alpha * ( pixel 3 - pixel 4)  / 255 )  + pixel 4 = dst 3

; ============ Muevo lo que tengo hasta ahora y le resto lo que acabo de sumar para obtener la parte casi común (salvo por el -1)
					movups xmm15, xmm10 ; xmm15 == ( alpha * ( pixel 0 - pixel 7)  / 255 )  + pixel 7 = dst 0
					subps xmm15, xmm8 ; xmm15 == ( alpha * ( pixel 0 - pixel 7)  / 255 )
					movups xmm8, xmm11
					subps xmm8, xmm4
					movups xmm4, xmm12
					subps xmm4, xmm7
					movups xmm7, xmm13
					subps xmm7, xmm3

; ============ Convierto a enteros
					cvtps2dq xmm10, xmm10
					cvtps2dq xmm11, xmm11
					cvtps2dq xmm12, xmm12
					cvtps2dq xmm13, xmm13

; ============ Empaqueto ========================================
					packusdw xmm13, xmm12 ; empaqueto de dw a w, xmm13 == pixel de xmm12, es decir, el pixel 2, seguido del pixel de xmm13, el 3
					packusdw xmm11, xmm10 ; empaqueto de dw a w, xmm11 == pixel de xmm10, es decir, el pixel 0, seguido del pixel de xmm11, el 1
					packuswb xmm13, xmm11 ; empaqueto de w a b, xmm13 == pixel 0, pixel 1, pixel 2, pixel 3
					pshufd xmm11, xmm13, 0x1B		; esto porque tienen q ser al revés la de un lado a la del otro!

; ============ Pongo en la imagen destino en la mitad izquierda de la imagen =======================
					movdqu [rsi + 4*r9], xmm11

; =============== PARA LA PARTE DERECHA =========================
					mulps xmm15, [menos1] ; uso lo ya multiplicado por alpha y dividido por 255 y lo multiplico por -1.
					mulps xmm8, [menos1]
					mulps xmm4, [menos1]
					mulps xmm7, [menos1]

; =============== Convierto a precisión simple los que voy a sumar ======
					cvtdq2ps xmm1, xmm1
					cvtdq2ps xmm5, xmm5
					cvtdq2ps xmm2, xmm2
					cvtdq2ps xmm6, xmm6

; =============== Sumo ============================
					addps xmm15, xmm1
					addps xmm8, xmm5
					addps xmm4, xmm2
					addps xmm7, xmm6

; ============ Convierto a enteros
					cvtps2dq xmm15, xmm15
					cvtps2dq xmm8, xmm8
					cvtps2dq xmm4, xmm4
					cvtps2dq xmm7, xmm7

; ============ Empaqueto ========================================
					packusdw xmm7, xmm4 ; empaqueto de dw a w, xmm7 == pixel de xmm4, es decir, el pixel 2, seguido del pixel de xmm7, el 3
					packusdw xmm8, xmm15 ; empaqueto de dw a w, xmm8 == pixel de xmm15, es decir, el pixel 0, seguido del pixel de xmm8, el 1
					packuswb xmm7, xmm8 ; empaqueto de w a b, xmm7 == pixel 0, pixel 1, pixel 2, pixel 3

; ============ Pongo en la imagen destino en la mitad derecha de la imagen =======================
					movdqu [r12 + 4*r14], xmm7

					add r9, 4 ; como cada vez se procesan 4 píxeles de la imagen destino, se avanzan 4 columnas
					mov r14, r9
					imul r14, -1
					add rbx, 1
					cmp rbx, rax ; comparo rbx con la cantidad de veces que entran 8 píxeles, con el cociente de la división
					jne .cicloInterno ; si no es igual falta procesar píxeles en esa fila

.QuizasFaltaProcesar:
					; veo si falta procesar 4 píxeles en el medio o si ya está esta fila
					cmp rdx, 0 ; el resto de la división por 8 con 4
					jne .faltaProcesar
		 ; ya se procesó todo y terminé la fila
		jmp .terminoFila

.faltaProcesar:					; quedan 4 píxeles en el medio que falta procesar
		movdqu xmm1, [rdi + 4*r9] ; agarro 4 píxeles de la mitad izquierda de la foto		; xmm1 = p3|p2|p1|p0
		movdqu xmm2, xmm1

		punpcklbw xmm1, xmm9 ; | 0 | píxel 1 a | 0 | píxel 1 r | 0 | píxel 1 g | 0 | píxel 1 b | 0 | píxel 0 a | 0 | píxel 0 r | 0 | píxel 0 g | 0 | píxel 0 b |
		punpckhbw xmm2, xmm9 ; | 0 | píxel 3 a | 0 | píxel 3 r | 0 | píxel 3 g | 0 | píxel 3 b | 0 | píxel 2 a | 0 | píxel 2 r | 0 | píxel 2 g | 0 | píxel 2 b |

		movdqu xmm5, xmm1
		movdqu xmm6, xmm2

		punpcklwd xmm1, xmm9 ; | 0 | 0 | 0 | píxel 0 a | 0 | 0 | 0 | píxel 0 r | 0 | 0 | 0 | píxel 0 g | 0 | 0 | 0 | píxel 0 b |
		punpckhwd xmm5, xmm9 ; | 0 | 0 | 0 | píxel 1 a | 0 | 0 | 0 | píxel 1 r | 0 | 0 | 0 | píxel 1 g | 0 | 0 | 0 | píxel 1 b |
		punpcklwd xmm2, xmm9 ; | 0 | 0 | 0 | píxel 2 a | 0 | 0 | 0 | píxel 2 r | 0 | 0 | 0 | píxel 2 g | 0 | 0 | 0 | píxel 2 b |
		punpckhwd xmm6, xmm9 ; | 0 | 0 | 0 | píxel 3 a | 0 | 0 | 0 | píxel 3 r | 0 | 0 | 0 | píxel 3 g | 0 | 0 | 0 | píxel 3 b |

		movdqu xmm10, xmm1
		movdqu xmm11, xmm5
		movdqu xmm12, xmm2
		movdqu xmm13, xmm6

		psubd xmm10, xmm6 ; resto los 2 píxeles correspondientes, | 0 | 0 | 0 | píxel 0 a - píxel 3 a | 0 | 0 | 0 | píxel 0 r - píxel 3 r | 0 | 0 | 0 | píxel 0 g - píxel 3 g | 0 | 0 | 0 | píxel 0 b -píxel 3 b |
		psubd xmm11, xmm2 ; resto los 2 píxeles correspondientes
		psubd xmm12, xmm5
		psubd xmm13, xmm1 ; resto los 2 píxeles correspondientes, | 0 | 0 | 0 | píxel 3 a - píxel 0 a | 0 | 0 | 0 | píxel 3 r - píxel 0 r | 0 | 0 | 0 | píxel 3 g - píxel 0 g | 0 | 0 | 0 | píxel 3 b -píxel 0 b |

		; =============== Convierto a precisión simple los que voy a sumar ======
		cvtdq2ps xmm1, xmm1 ; xmm1 == | píxel 0 a | píxel 0 r | píxel 0 g | píxel 0 b |
		cvtdq2ps xmm5, xmm5 ; xmm5 == píxel 1
		cvtdq2ps xmm2, xmm2 ; xmm2 == píxel 2
		cvtdq2ps xmm6, xmm6 ; xmm6 == píxel 3

		cvtdq2ps xmm10, xmm10 ; xmm10 == | píxel 0 a - píxel 3 a | píxel 0 r - píxel 3 r | píxel 0 g - píxel 3 g | píxel 0 b - píxel 3 b |
		cvtdq2ps xmm11, xmm11 ; xmm11 == pixel 1 - pixel 2
		cvtdq2ps xmm12, xmm12 ; xmm11 == pixel 2 - pixel 1
		cvtdq2ps xmm13, xmm13 ; xmm11 == pixel 3 - pixel 0

		mulps xmm10, xmm0 ; Multiplico por alpha: xmm10 == | alpha *  | ... | ... | alpha *  | (pixel 0 - pixel 3)
		mulps xmm11, xmm0 ; xmm11 == alpha * ( pixel 1 - pixel 2)
		mulps xmm12, xmm0 ; xmm11 == alpha * ( pixel 2 - pixel 1)
		mulps xmm13, xmm0 ; xmm11 == alpha * ( pixel 3 - pixel 0)

		divps xmm10, xmm14 ; xmm10 == alpha * ( pixel 0 - pixel 3)  / 255
		divps xmm11, xmm14 ; xmm11 == alpha * ( pixel 1 - pixel 2)  / 255
		divps xmm12, xmm14 ; xmm12 == alpha * ( pixel 2 - pixel 1)  / 255
		divps xmm13, xmm14 ; xmm13 == alpha * ( pixel 3 - pixel 0)  / 255

		; ============ Sumo el píxel de la parte espejada ==============
		addps xmm10, xmm6 ; xmm10 == ( alpha * ( pixel 0 - pixel 3)  / 255 )  + pixel 3 = src 0
		addps xmm11, xmm2 ; xmm11 == ( alpha * ( pixel 1 - pixel 2)  / 255 )  + pixel 2 = src 1
		addps xmm12, xmm5 ; xmm12 == ( alpha * ( pixel 2 - pixel 1)  / 255 )  + pixel 1 = src 2
		addps xmm13, xmm1 ; xmm13 == ( alpha * ( pixel 3 - pixel 0)  / 255 )  + pixel 0 = src 3

		; ============ Vuelvo a convertir a entero
		cvtps2dq xmm10, xmm10
		cvtps2dq xmm11, xmm11
		cvtps2dq xmm12, xmm12
		cvtps2dq xmm13, xmm13

		; ============ Empaqueto ========================================
		packusdw xmm13, xmm12 ; empaqueto de dw a w, xmm13 == pixel de xmm12, es decir, el pixel 2, seguido del pixel de xmm13, el 3
		packusdw xmm11, xmm10 ; empaqueto de dw a w, xmm11 == pixel de xmm10, es decir, el pixel 0, seguido del pixel de xmm11, el 1
		packuswb xmm13, xmm11 ; empaqueto de w a b, xmm13 == pixel 0, pixel 1, pixel 2, pixel 3
		pshufd xmm11, xmm13, 0x1b		; esto porque tienen q ser al revés la de un lado a la del otro!

		; ============ Pongo en la imagen destino en la mitad izquierda de la imagen =======================
		movdqu [rsi + 4*r9], xmm11

.terminoFila:
		add rdi, r8
		add rsi, r8
		add r10, 1 ; r8 = r8 + 1
		jmp .cicloExterno

.fin:

		mov rcx, current
		xor rax, rax

		.cicle:

			dec rcx
			mov r8, [puntero + rcx*8]
			dec rcx
			mov r9, [puntero + rcx*8]
			sub r8, r9
			add rax, r8
			cmp rcx, 0
			jne .cicle 

		;;EN RAX TENGO EL TOTAL DE TIEMPO INSUMIDO PARA ESCRIBIR!

		mov rdi, rax
		call imprimirArchivo

		mov rdi, puntero
		call free

		add rsp, 8
		pop rbp


		add rsp, 8
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret






	;	al de la izquierda le resto 2 y al otro le sumo 2
