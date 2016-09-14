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

.HacerMascaras: 
		pxor xmm4, xmm4
		
		;creo mascaras en xmm5 y xmm6 para q me queden : a|b|g|b y a|g|r|r

		mov r10, 1
		pxor xmm4, xmm4
		movq xmm4, r10


.ciclo:

	movups xmm1, [rdi + rdx]; en xmm1 guardo los 3 pixeles de arriba
	movups xmm2, [rdi]; en xmm2 guardo los 3 pixeles ppales (el pixel 1 y el 2 son los q estoy calculando)
;	movups xmm3, [rdi - rdx]; en xmm3 guardo los 3 pixeles de abajo

	pmaxsb xmm1, xmm2 ; guardo el maximo de cada byte en xmm1
	pmaxsb xmm1, xmm3 ; guardo el max en xmm1 

	movups xmm3, xmm1 ; copio

	pshufb xmm3, xmm5 ; en xmm3 quedan los pixeles x dentro asi: a|g|r|r

	pshufb xmm1, xmm6 ;: en xmm1 quedan los pixeles x dentro asi: a|b|g|b

	pcmpgtb xmm1, xmm3 ; comparo para obtener phi 
	
	;en el byte 3 de cada pixel: 0
	;en el byte 2 de cada pixel : b > g
	; en el byte 1 de cada pixel : g > r
	;en el  byte 0 de cada pixel : b > r



	ret

