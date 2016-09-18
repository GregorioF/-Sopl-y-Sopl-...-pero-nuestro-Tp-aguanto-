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

section .data
MenosUnosEnDobleW: db 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
mascaraPrueba: db 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00

section .text

colorizar_asm:

movups xmm6, xmm0
xor rax, rax
inc rax
mov r12, rdx
mul r12
mul rcx
mov rdx, r12
xor r12,r12

.HacerMascaras: 
		pxor xmm4, xmm4	;								a|r|g|b
		
		;creo mascaras en xmm5 me quede : b|b|b|b

		mov r10, 0x0f0e0d0c0b0a0908 	; hago la mascara para shuffle

		movq xmm5, r10

		pslldq xmm5, 8 ;shifteo a izquierda 8 bytes

		mov r10, 0x0404040400000000

		movq xmm4, r10

		por xmm5,xmm4 ; tengo la mascara en xmm5
		



.ciclo:

	inc r12
	inc r12

	;movdqu xmm0, [mascaraPrueba] 
	;call pasarDeMenosUnoAUnoYDeCeroAMenosUno
	
	movups xmm1, [rdi + rdx + rdx]; en xmm1 guardo los 3 pixeles de arriba
	movups xmm7, [rdi + rdx]; en xmm2 guardo los 3 pixeles ppales (el pixel 1 y el 2 son los q estoy calculando)
	movups xmm2, xmm7
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

	psrldq xmm1, 1 ; shifteo 1 byte, me queda 0|a|max(r)|max(g)|max(b)|a|max(r)|max(g)

	pmaxsb xmm1,xmm2 ; me quedan a|max(a,r)|max(r,g)|max(g,b)|max(b,a)|max(a,r)|max(r,g)|max(g,b)

	movups xmm2,xmm1

	psrldq xmm1,1 ;  shifteo 1 byte, me queda 0|a|max(a,r)|max(r,g)|max(g,b)|max(b,a)|max(a,r)|max(r,g)

	pmaxsb xmm1, xmm2 ; me quedan a|max1(a,r)|max1(a,r,g)|max1(r,g,b)|max0(a,g,b)|max0(a,r,b)|max0(a,r,g)|max0(r,g,b)

	pshufb xmm1, xmm5 ; en xmm1 me quedan basura|max1(rgb)|max1(rgb)|max1(rgb)|max1(rgb)||max0(rgb)|max0(rgb)|max0(rgb)|max0(rgb)

	movups xmm2, xmm7

	psrldq xmm2, 4 ; shifteo 4 bytes a la derecha

	pcmpeqb xmm1, xmm2 ; comparo el mayor de todos con a|r|g|b original

	; me queda en xmm1 basura| ceros o -1s

	punpcklbw xmm1, xmm1 ; paso de bytes a words

	movups xmm2, xmm1

	punpcklwd xmm2, xmm1 ; paso de words a doble words el pixel de la pte baja

	punpckhwd xmm1, xmm1 ; paso de words a double words el pixel de la pte alta

	movups xmm0, xmm1

	call pasarDeMenosUnoAUnoYDeCeroAMenosUno

	movups xmm1, xmm0

	movups xmm0, xmm2

	call pasarDeMenosUnoAUnoYDeCeroAMenosUno

	addps xmm1, xmm6

	addps xmm2, xmm6

	pxor xmm0, xmm0

	punpcklwd xmm7, xmm0

	movups xmm8, xmm7

	punpckhwd xmm8, xmm0
	punpcklwd xmm7, xmm0

	mulps xmm7, xmm2
	mulps xmm8, xmm1

	packssdw xmm8, xmm7 ; quyedan pixel1|pixel0

	packsswb xmm8, xmm8 ; quedan pixel1|pixel0|pixel1|pixel0

	movq [rdi + 4], xmm8

	lea rdi, [rdi + 16]

	cmp r12, rax

	jne .ciclo


	ret
	
	
; pasarle un registro con floats sino no funca naAaaaaa!


pasarDeMenosUnoAUnoYDeCeroAMenosUno:
; en xmm0 me viene el registro a cambiar de a dobles words son

pxor xmm14, xmm14 ; foward clean

movdqu xmm15, [MenosUnosEnDobleW]	; les meto toddas F
cvtdq2ps xmm15, xmm15		; los convierto en floats



mulps xmm0, xmm15		; multiplico todos los valores por menos uno, asi que lo que era -1 ahora es 1 y lo que es cero sigue siendo cero

movups xmm13, xmm0

cmpps xmm13, xmm14, 0		; en donde habia ceros ahora hay menos unos y donde habia unos quedan ceros

addps xmm0, xmm13 			; ahora en xmm0 me qda donde habia ceros en un principio menos unos  y donde habia efes en un princio unos
ret






