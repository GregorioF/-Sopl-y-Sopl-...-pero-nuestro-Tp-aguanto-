; void colorizar_asm (
; 	unsigned char *src,
; 	unsigned char *dst,
; 	int cols,
; 	int filas,
; 	int src_row_size,
; 	int dst_row_size,
;   float alpha
; );

; Parámetros:
; 	rdi = src
; 	rsi = dst
; 	rdx = cols
; 	rcx = filas
; 	r8 = src_row_size
; 	r9 = dst_row_size
;   xmm0 = alpha


global colorizar_asm


section .text

colorizar_asm:

;alpha;

	mov r10, 1
	movq xmm7, r10
	addps xmm8, xmm7 ; guardo 1+alpha en xmm8
	subps xmm7, xmm9 ; guardo 1-alpha en xmm7

.HacerMascaras: 
		pxor xmm4, xmm4	;								a|r|g|b
		
		;creo mascaras en xmm5 y xmm6 para q me queden : a|b|g|b y a|g|r|r

		mov r10, 0x0f0c0d0c0b080908 	; hago la mascara para shuffle
		
		movq xmm5, r10
		pslldq xmm5, 8
		mov r10, 0x0704050403000100
		movq xmm4, r10
		por xmm5, xmm4

		mov r10, 0x0f0d0e0e0b090a0a

		movq xmm6, r10
		pslldq xmm6, 8
		mov r10, 0x0705060603010202
		movq xmm4, r10
		por xmm6, xmm4


.ciclo:

	movups xmm1, [rdi + rdx + rdx]; en xmm1 guardo los 3 pixeles de arriba
	movups xmm2, [rdi + rdx]; en xmm2 guardo los 3 pixeles ppales (el pixel 1 y el 2 son los q estoy calculando)
	movups xmm3, [rdi]; en xmm3 guardo los 3 pixeles de abajo

	pmaxsb xmm1, xmm2 ; guardo el maximo de cada byte en xmm1
	pmaxsb xmm1, xmm3 ; guardo el max en xmm1 

	movups xmm3, xmm1 ; copio
	movups xmm2, xmm1

	psrldq xmm3, 8 ; me queda en los 4 bytes 0 uno de los dos pixeles ppales
	psrldq xmm1, 4 ; me queda en los 4 bytes 0 uno de los dos pixeles ppales

	pmaxsb xmm3, xmm1 ; me queda en el pixel 0 max(pixeles ppales) y en el pixel 1 max(pixel ppal y columna de la izquierda)

	pmaxsb xmm2, xmm1 ; me queda en el pixel 0 max(pixel ppal y su columna de la derecha)

	pmaxsb xmm2, xmm3 ; me queda en el pixel 0 los maximos entre los pixeles 2,1,0

	movups xmm1, xmm3
	psrldq xmm1, 4

	pmaxsb xmm1, xmm3 ; me queda en el pixel 0 los maximos entre los pixeles 3,2,1

	pslldq xmm1, 4
	por xmm1, xmm2 ; me queda pixel 1 max entre 3,2,1 y pixel 2 max entre 2,1,0

	movups xmm1, xmm2


	


	ret

