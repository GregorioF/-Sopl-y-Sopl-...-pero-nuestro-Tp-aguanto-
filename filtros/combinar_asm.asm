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

section .rodata
		mascara255: dd 255.0, 255.0, 255.0, 255.0

section .text

combinar_asm:
; SE CONSIDERA QUE EL ANCHO ES MÚLTIPLO DE 4 Y HAY QUE VER SI ANDA EN CASO DE NO SER MÚLTIPLO DE 16
	sub rsp, 8

	pxor xmm9, xmm9
	xor r10, r10 ; pongo un 0 en mi contador de filas
	xor r9, r9 ; pongo un 0 en mi contador de columnas
	xor r11, r11
	pshufd xmm0, xmm0, 00000000b ; El alpha era un float que sólo estaba en los "primeros" (últimos) 4 bytes de xmm0, entonces no iba a multiplicar bien.
																; Paso el alpha a los otros lugares: xmm0 == | alpha | alpha | alpha | alpha |
	movdqu xmm14, [mascara255] ; paso a un registro lo de la máscara fuera de los ciclos porque como es un acceso a memoria quiero minimizar la cantidad de veces que se hace.
	shl rdx, 1 ; como la imagen destino se completa de ambos lados en cada iteración de columna, voy hasta la mitad

.cicloExterno:
		cmp r10, rcx ; comparo r8 con la cantidad de filas
		je .fin ; si es igual ya terminó de recorrer la matriz y salto al final
		mov r9, 0 ; si no, pongo un 0 en el contador de columnas y voy al ciclo Interno
		mov r11, rdi ; r11 == rdi
		add r11, r8 ; r11 == rdi + tamaño de la fila
		sub r11, 16 ; r11 == rdi + tamaño de la fila - 16
		mov r12, rsi ; r12 == rsi
		add r12, r8 ; r12 == rsi + tamaño de la fila
		sub r12, 16 ; r12 == rsi + tamaño de la fila - 16

			.cicloInterno:
					movdqu xmm1, [rdi + 4*r9] ; agarro 4 píxeles de la mitad izquierda de la foto
					movdqu xmm2, xmm1
					movdqu xmm3, [r11 - 4*r9] ; agarro 4 píxeles de la mitad derecha de la foto
					movdqu xmm4, xmm3
					punpcklbw xmm1, xmm9 ; | 0 | píxel 1 a | 0 | píxel 1 r | 0 | píxel 1 g | 0 | píxel 1 b | 0 | píxel 0 a | 0 | píxel 0 r | 0 | píxel 0 g | 0 | píxel 0 b |
					punpckhbw xmm2, xmm9 ; | 0 | píxel 3 a | 0 | píxel 3 r | 0 | píxel 3 g | 0 | píxel 3 b | 0 | píxel 2 a | 0 | píxel 2 r | 0 | píxel 2 g | 0 | píxel 2 b |
					punpcklbw xmm3, xmm9 ; | 0 | píxel 5 a | 0 | píxel 5 r | 0 | píxel 5 g | 0 | píxel 5 b | 0 | píxel 4 a | 0 | píxel 4 r | 0 | píxel 4 g | 0 | píxel 4 b |
					punpckhbw xmm4, xmm9 ; | 0 | píxel 7 a | 0 | píxel 7 r | 0 | píxel 7 g | 0 | píxel 7 b | 0 | píxel 6 a | 0 | píxel 6 r | 0 | píxel 6 g | 0 | píxel 6 b |

					movdqu xmm5, xmm1
					movdqu xmm6, xmm2
					movdqu xmm7, xmm3
					movdqu xmm8, xmm4

					punpcklwd xmm1, xmm9 ; | 0 | 0 | 0 | píxel 0 a | 0 | 0 | 0 | píxel 0 r | 0 | 0 | 0 | píxel 0 g | 0 | 0 | 0 | píxel 0 b |
					punpckhbw xmm5, xmm9 ; | 0 | 0 | 0 | píxel 1 a | 0 | 0 | 0 | píxel 1 r | 0 | 0 | 0 | píxel 1 g | 0 | 0 | 0 | píxel 1 b |
					punpcklbw xmm2, xmm9 ; | 0 | 0 | 0 | píxel 2 a | 0 | 0 | 0 | píxel 2 r | 0 | 0 | 0 | píxel 2 g | 0 | 0 | 0 | píxel 2 b |
					punpckhwd xmm6, xmm9 ; | 0 | 0 | 0 | píxel 3 a | 0 | 0 | 0 | píxel 3 r | 0 | 0 | 0 | píxel 3 g | 0 | 0 | 0 | píxel 3 b |
					punpcklwd xmm3, xmm9 ; | 0 | 0 | 0 | píxel 4 a | 0 | 0 | 0 | píxel 4 r | 0 | 0 | 0 | píxel 4 g | 0 | 0 | 0 | píxel 4 b |
					punpckhwd xmm7, xmm9 ; | 0 | 0 | 0 | píxel 5 a | 0 | 0 | 0 | píxel 5 r | 0 | 0 | 0 | píxel 5 g | 0 | 0 | 0 | píxel 5 b |
					punpckhbw xmm4, xmm9 ; | 0 | 0 | 0 | píxel 6 a | 0 | 0 | 0 | píxel 6 r | 0 | 0 | 0 | píxel 6 g | 0 | 0 | 0 | píxel 6 b |
					punpckhwd xmm8, xmm9 ; | 0 | 0 | 0 | píxel 7 a | 0 | 0 | 0 | píxel 7 r | 0 | 0 | 0 | píxel 7 g | 0 | 0 | 0 | píxel 7 b |

					movdqu xmm10, xmm1
					movdqu xmm11, xmm5
					movdqu xmm12, xmm2
					movdqu xmm13, xmm6

					subps xmm10, xmm8 ; resto los 2 píxeles correspondientes, | 0 | 0 | 0 | píxel 0 a - píxel 7 a | 0 | 0 | 0 | píxel 0 r - píxel 7 r | 0 | 0 | 0 | píxel 0 g - píxel 7 g | 0 | 0 | 0 | píxel 0 b -píxel 7 b |
					subps xmm11, xmm4 ; resto los 2 píxeles correspondientes
					subps xmm12, xmm7 ; resto los 2 píxeles correspondientes
					subps xmm13, xmm3 ; resto los 2 píxeles correspondientes

					cvtdq2ps xmm3, xmm3 ; xmm3 == | píxel 4 a | píxel 4 r | píxel 4 g | píxel 4 b |
					cvtdq2ps xmm7, xmm7
					cvtdq2ps xmm4, xmm4
					cvtdq2ps xmm8, xmm8
					cvtdq2ps xmm10, xmm10 ; xmm10 == | píxel 0 a - píxel 7 a | píxel 0 r - píxel 7 r | píxel 0 g - píxel 7 g | píxel 0 b - píxel 7 b |
					cvtdq2ps xmm11, xmm11
					cvtdq2ps xmm12, xmm12
					cvtdq2ps xmm13, xmm13

					mulps xmm10, xmm0 ; Multiplico por alpha: xmm10 == | alpha *  | ... | ... | alpha *  |
					mulps xmm11, xmm0
					mulps xmm12, xmm0
					mulps xmm13, xmm0

					movdqu xmm15, xmm1 ; Muevo xmm1 a otro registro porque en xmm1 se hace la división

					movdqu xmm1, xmm10
					divps xmm14 ; Hago la división con xmm1
					movdqu xmm10, xmm1 ; Pongo el resultado donde lo quiero
					movdqu xmm1, xmm11 ; tengo que mover a xmm1 para poder hacer la división de lo que hay en xmm11
					divps xmm14
					movdqu xmm11, xmm1
					movdqu xmm1, xmm12
					divps xmm14
					movdqu xmm12, xmm1
					movdqu xmm1, xmm13
					divps xmm14
					movdqu xmm13, xmm1

					movdqu xmm1, xmm15 ; Reestablezco xmm1

; ============ Sumo el píxel de la parte espejada ==============
					addps xmm10, xmm8 ; sumo el píxel de la parte espejada
					addps xmm11, xmm4
					addps xmm12, xmm7
					addps xmm13, xmm3

; ============ Muevo lo que tengo hasta ahora y le resto lo que acabo de sumar para obtener la parte casi común (salvo por el -1)
					movdqu xmm15, xmm10
					subps xmm15, xmm8
					movdqu xmm8, xmm11
					subps xmm8, xmm4
					movdqu xmm4, xmm12
					subps xmm4, xmm7
					movdqu xmm7, xmm13
					subps xmm7, xmm3

; ============ Empaqueto ========================================
					packusdw xmm13, xmm12 ; empaqueto de dw a w, xmm13 == pixel de xmm12, es decir, el pixel 2, seguido del pixel de xmm13, el 3
					packusdw xmm11, xmm10 ; empaqueto de dw a w, xmm11 == pixel de xmm10, es decir, el pixel 0, seguido del pixel de xmm11, el 1
					packuswb xmm13, xmm11 ; empaqueto de w a b, xmm13 == pixel 0, pixel 1, pixel 2, pixel 3

; ============ Pongo en la imagen destino en la mitad izquierda de la imagen =======================
					movups [rsi + 4*r9], xmm13

; =============== PARA LA PARTE DERECHA =========================
					mulps xmm15, -1 ; uso lo ya multiplicado por alpha y dividido por 255 y lo multiplico por -1.
					mulps xmm8, -1
					mulps xmm4, -1
					mulps xmm7, -1

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

; ============ Empaqueto ========================================
					packusdw xmm7, xmm4 ; empaqueto de dw a w, xmm7 == pixel de xmm4, es decir, el pixel 2, seguido del pixel de xmm7, el 3
					packusdw xmm8, xmm15 ; empaqueto de dw a w, xmm8 == pixel de xmm15, es decir, el pixel 0, seguido del pixel de xmm8, el 1
					packuswb xmm7, xmm8 ; empaqueto de w a b, xmm7 == pixel 0, pixel 1, pixel 2, pixel 3

; ============ Pongo en la imagen destino en la mitad derecha de la imagen =======================
					movups [r12 - 4*r9], xmm7

					add r9, 4 ; como cada vez se procesan 4 píxeles de la imagen destino, se avanzan 4 columnas
					cmp r9, rdx ; comparo r9 con la cantidad de columnas
					jne .cicloInterno ; si no es igual falta procesar píxeles en esa fila

		add rdi, rdx ; si era igual entonces llegé al final de la fila y muevo 4 veces la cantidad de columnas al puntero rdi para que apunte a la próxima fila
		add rdi, rdx
		add rdi, rdx
		add rdi, rdx
		add rsi, rdx ; muevo 4 veces la cantidad de columnas al puntero rsi para que apunte a la próxima fila
		add rsi, rdx
		add rsi, rdx
		add rsi, rdx
		add r8, 1 ; r8 = r8 + 1
		jmp .cicloExterno

.fin:
		add rsp, 8
		ret
