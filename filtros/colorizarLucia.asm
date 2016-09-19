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
push r12
sub rsp, 8

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
		
	add rdi, r8
	;lea rdi, [rdi + 1] ; empiezo desde la fila 1 columna 1

	add r12, r8
	;inc r12

	sub rax, r8 ; le resto al total de pixeles la fila tope
	sub rax, r8
	sub rax, r8
	sub rax, r8
	sub rax, r8
	sub rax, r8
	sub rax, r8
	sub rax, r8
	
	
	;dec rax


.ciclo:

	inc r12
	inc r12

	;movdqu xmm0, [mascaraPrueba] 
	;call pasarDeMenosUnoAUnoYDeCeroAMenosUno
	
	movups xmm1, [rdi + r8 + r8]; xmm1 == p3|p2|p1|p0      en xmm1 guardo los 3 pixeles de arriba
	movups xmm7, [rdi + r8]		; xmm2 == p7|p6|p5|p4    guardo los 3 pixeles ppales (el pixel 1 y el 2 son los q estoy calculando)
	movups xmm2, xmm7			; salvo estos en xmm2
	movups xmm13, xmm7
	movups xmm3, [rdi]			; xmm3 == p11|p10|p9|p8      guardo los 3 pixeles de abajo

	pmaxub xmm1, xmm2 ; guardo el maximo de cada byte en xmm1 
	pmaxub xmm1, xmm3 ; guardo el max en xmm1 ==  pMax1 {3,7,11} | pmax2{2,6,10}| pmax3 {1,5,9}| pmax4 {0,4,8}

	movups xmm3, xmm1 ; copio
	movups xmm2, xmm1

	psrldq xmm3, 8 ; me queda en los 4 bytes 0 uno de los dos pixeles ppales  xmm3 == 0 | 0 | pmax1 {3,7,11} | pmax 2 {2,6,10}
	psrldq xmm1, 4 ; me queda en los 4 bytes 0 uno de los dos pixeles ppales  xmm1 == 0 | pmax1 | pmax 2 {2,6,10} | pmax3 {1,5,9}

	pmaxub xmm3, xmm1 ; me queda en el pixel 0 max(pixeles ppales) y en el pixel 1 max(pixel ppal y columna de la izquierda)
					  ; xmm3 == 0 | fruit | pmax {3,7,11,2,6,10} | pmax {2,6,10,1,5,9}

	pmaxub xmm2, xmm1 ; me queda en el pixel 0 max(pixel ppal y su columna de la derecha)
					  ; xmm2 == fruit | fruit | pmax {1,5,9,2,6,10} | pmax {0,4,8,1,5,9}

	pmaxub xmm2, xmm3 ; me queda en el pixel 0 los maximos entre los pixeles 2,1,0		
					  ; xmm2 == fruit | fruit | MaxP2 | MaxP1

	
	movups xmm1, xmm2 ; xmm1 == fruta | furta | maxP2 | MaxP1

	psrldq xmm1, 1 ; shifteo 1 byte, me queda 0|a|max(r)|max(g)|max(b)|a|max(r)|max(g)

	pmaxsb xmm1,xmm2 ; me quedan a|max(a,r)|max(r,g)|max(g,b)|max(b,a)|max(a,r)|max(r,g)|max(g,b)

	psrldq xmm1,1 ;  shifteo 1 byte, me queda 0|a|max(a,r)|max(r,g)|max(g,b)|max(b,a)|max(a,r)|max(r,g)

	pmaxsb xmm1, xmm2 ; xmm1 =  0 | 0 | (fruta*3, maxP2 (g,b,r)) | (fruta*3, maxP1 (g,b,r))  

	pshufb xmm1, xmm5 ; en xmm1 fruta | fruta | [maxP2(g,b,r) * 4] | [maxP1(g,b,r) * 4] 

	pcmpeqb xmm1, xmm2 ; comparo el mayor de todos con los  maximos de cada canal en pixel 1 y 2

	; me queda en xmm1 basura| ceros o -1s

	punpcklbw xmm1, xmm1 ; paso de bytes a words
		
	movups xmm2, xmm1

	punpcklwd xmm2, xmm1 ; paso de words a doble words el pixel de la pte baja

	punpckhwd xmm1, xmm1 ; paso de words a double words el pixel de la pte alta

	movups xmm0, xmm1
	
	cvtdq2ps xmm0, xmm0

	call pasarDeMenosUnoAUnoYDeCeroAMenosUno

	movups xmm1, xmm0

	movups xmm0, xmm2
	
	cvtdq2ps xmm0, xmm0

	call pasarDeMenosUnoAUnoYDeCeroAMenosUno
	
	movups xmm5, xmm6	 ; le pongo en xmm5 el registro con los alphas

	mulps xmm6, xmm1 		; le multiplico al alfa  por uno si esta en la posicion de pixel maximo
							; o un -1 en caso contrario ACA QUEDAN LOS ALFAS DLEP IXEL 2 
							
	mulps xmm5, xmm2		; ACA QUEDAN LOS ALFAS DEL PIXEL 1

	pxor xmm0, xmm0
	movups xmm9, xmm7		; copio los valores de los pixeles del medio
	
	punpcklbw xmm7, xmm0  ; desempaqueto los q eran los valores del primer pixel q me qdan en la parte alta
	
	movups xmm8, xmm7	

	punpckhwd xmm8, xmm0 ; en xmm8 tengo en dw cada canal del primer pixel
	
	punpckhbw xmm9, xmm0
	
	movups xmm7, xmm9
	
	punpcklwd xmm7, xmm0	; en xmm7 me qdan los caloores en dw del segundo pixel
	
	cvtdq2ps xmm8, xmm8
	cvtdq2ps xmm7, xmm7		; PASO AMBOS A FLOAT PARA PODER MULTIPLICAR POR EL VALOR DE CADA ALPHA

	mulps xmm7, xmm6
	mulps xmm8, xmm5
	
	cvtps2dq xmm8, xmm8
	cvtps2dq xmm7, xmm7

	packssdw xmm8, xmm7 ; quyedan pixel1|pixel0

	packsswb xmm8, xmm8 ; quedan pixel1|pixel0|pixel1|pixel0
	
	

	movq [rsi], xmm8

	add rdi, 16

	cmp r12, 23000

	jne .ciclo


	add rsp, 8 
	pop r12
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






