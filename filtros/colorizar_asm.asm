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

.HacerMascaras: ;copiado de Gregorio:
		pxor xmm4, xmm4
		mov r8, 0x0f0c0e0d0b080a09 	; hago la mascara para shuffle
		
		movq xmm5, r10
		pslldq xmm5, 8
		mov r10, 0x0704060503000201
		movq xmm4, r10
		por xmm5, xmm4	 	; termine de hacer la mascara para shuffle si el pixel x era = a|b|g|r ahora con shufle
							; va a ser igual a  a|g|r|b


.ciclo:

	movups xmm1, [rdi + rdx]; en xmm1 guardo los 3 pixeles de arriba
	movups xmm2, [rdi]; en xmm2 guardo los 3 pixeles ppales (el pixel 1 y el 2 son los q estoy calculando)
	movups xmm3, [rdi - rdx]; en xmm3 guardo los 3 pixeles de abajo

	pmaxsb xmm1, xmm2 ; guardo el maximo de cada byte en xmm1
	pmaxsb xmm1, xmm3 ; guardo el max en xmm1 

	movups xmm3, xmm1 ; copio
	pshufb xmm3, xmm5 ; en xmm3 quedan los pixeles x dentro asi: a|g|r|b

	pmaxsb xmm3, xmm1 ; en el byte 1 y en el 0 de cada pixel tengo max(R,G) y max(R,B) respectivamente. y max(G,B) en el byte 2

	pcmpeqb xmm3, xmm1 ; comparo para obtener phi

	









	









	ret

