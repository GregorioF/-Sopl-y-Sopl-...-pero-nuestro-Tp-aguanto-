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
mascaraMaximos: db 0x00, 0x00, 0x00, 0x00, 0x04, 0x04, 0x04, 0x04, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
mascaraUnos: db 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
casoRyB : db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00
casoRyG : db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00
casoGyB : db 0x01, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
casoRyGyB: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00
restoDos: db 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
restoCuatro: db 0x3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0

section .text

colorizar_asm:
	push rbx
	push r12
	push r13
	push r14
	push r15

	
	mov rbx, rdx
	
	call ponerBordesBien

	movdqu xmm12, xmm0		; xmm12 siempre va a tener mi alpha inicial y fuckin punto
	
	pshufd xmm12, xmm12, 00000000b
	movdqu xmm11, [mascaraMaximos]
	
	
	movdqu xmm10, [mascaraUnos]
	cvtdq2ps xmm10, xmm10
	
	xor r9, r9  ; mi current sobre filas
	add r9, 1 ; para no contemplar la primer fila

	sub rcx, 1 ; para no contemplar las dos filas que no proceso
	sub rbx, 2 ; misma situacion
	add rsi, 4 ; siempre escribo sin contar el primero
	add rsi, r8

	.ciclo1:

		xor r10, r10
		cmp r9, rcx ; si son iguales termine de recorrer
		je .fin

		.ciclo2:
			
			
			;==== cuenta auxliar para direccionamiento correcto
			lea r11, [r10*4] ; mi current en columnas
			add r11, r8
			add r11, r8		; sumo dos veces para obtener la ultima fila dela q me interesa sacar datos
			;====
			movdqu xmm1, [rdi + r11]	; xmm1 == p3|p2|p1|p0

			.parada11:
				movd r13d, xmm1
				shr r13d, 16
				movd r15d, xmm1
				mov eax, r15d
				mov r14d, 2
				mov rdx, 0
				div r14d
				cmp edx, 0
				je .cont11
				jne .cont12
			
			.cont11:
			
			
			movq r15, xmm1 ; me lo salvo pa despues
			;======================
			;=== cuenta auxiliar para direccionamiento correcto
			lea r11, [r10*4]
			add r11, r8
			;===

			movdqu xmm2, [rdi + r11]	; xmm2 == p7|p6|p5|p4
			movups xmm7, xmm2  ; guardo los datos para despues

			;===
			movdqu xmm3, [rdi+r10*4]	; xmm3 == p11|p10|p9|p8
			;=== listo levante tdoso los datos q qria
			
			;========================== seccion maximos parcial
			pmaxub xmm1, xmm2 
			pmaxub xmm1, xmm3 ; guardo el max en xmm1 ==  pMax {3,7,11} | pmax{2,6,10}| pmax {1,5,9}| pmax {0,4,8}

			movups xmm3, xmm1 ; copio
			movups xmm2, xmm1

			psrldq xmm3, 8 ;   xmm3 == 0 | 0 | pmax1 {3,7,11} | pmax 2 {2,6,10}
			psrldq xmm1, 4 ;   xmm1 == 0 | fruta | pmax 2 {2,6,10} | pmax3 {1,5,9}

			pmaxub xmm3, xmm1 ; xmm3 == 0 | fruit | pmax {3,7,11,2,6,10} | pmax {2,6,10,1,5,9}

			pmaxub xmm2, xmm1 ; xmm2 == fruit | fruit | pmax {1,5,9,2,6,10} | pmax {0,4,8,1,5,9}

			pmaxub xmm2, xmm3 ; xmm2 == fruit | fruit | MaxP2 | MaxP1
			movups xmm1, xmm2 ; xmm1 == fruta | furta | maxP2 | MaxP1
			
			.parada21:
				mov rax, r15
				mov r14, 3
				div r14
				cmp rdx, 0
				je .cont21
				cmp rdx, 1
				je .cont22
				cmp rdx, 2
				je .cont23
			
			.cont21:
			
			;========== seccion para calcular el maximo de los maximos en xmm1

			psrldq xmm1, 1 ; shifteo 1 byte, xmm1 == | 0 |  -  | ... | -  | 		a2   | max2(r)  |  max2(g) | max2(b)  | 		 a1	  |  max1(r) | max1(g)  |

			pmaxub xmm1,xmm2 							 ; xmm1 == | - |  -  | ... | -  | max(a,r) | max(r,g) | max(g,b) | max(b,a) | max(a,r) | max(r,g) | max(g,b) |

			psrldq xmm1,1 ;  shifteo 1 byte, xmm1 == | 0 |  -  | ... | -  | 	 -		 | max(a,r) | max(r,g) | max(g,b) | max(b,a) | max(a,r) | max(r,g) |

			pmaxub xmm1, xmm2 ;  xmm1 =  | - | ... |  -  || -  | - | - | maxP2 (g,b,r) || - | - | - | maxP1 (g,b,r) ||

			pshufb xmm1, xmm11 ; xmm1 == || fruta || fruta || maxP2(g,b,r) | ... | maxP2(g,b,r) || maxP1(g,b,r) | ... | maxP1(g,b,r) ||

			pcmpeqb xmm1, xmm2 ; comparo el mayor de todos con los  maximos de cada canal en pixel 1 y 2

			;====== termino secccion en xmm1 me qda -1 en el byte de posicion igual al canal q tiene al maximo 0 en el resto
			;====== xmm1== fruta | fruta | InfoCopada2 | InfoCopada1 |
			
			pslldq xmm1, 8
			psrldq xmm1, 8 ; limpio parte alta de xmm1  osea  => xmm1 = 0|0|infoCopada2 | InfoCoapda1
			
			punpcklbw xmm1, xmm1  ; xmm1 == InfoCopada2High| I.C.2.L | I.C.1.H | I.C.1.L|
							
			movups xmm2, xmm1
			
			
			.parada31:
				mov rax, r13
				mov r14, 2
				div r14
				cmp rdx, 0
				je .cont31
				jne .cont32
			
			.cont31:
			
			punpcklwd xmm2, xmm1 ;  en cada dw me qda info copada sobre cada canala respectivamente del Pixel 1
			;checkeo caso dos maximos iguales:
			movups xmm0, xmm2
			call checkearCasoDosMaximos
			movups xmm2, xmm0
			
			
			punpckhwd xmm1, xmm1 ; en cada dw me qda info copada sobre cada canal respectivamente del Pixel 2
			movups xmm0, xmm1
			call checkearCasoDosMaximos
			movups xmm1, xmm0



			movups xmm0, xmm1
			cvtdq2ps xmm0, xmm0
			call pasarDeMenosUnoAUnoYDeCeroAMenosUno

			movups xmm1, xmm0	; lo mismo q antes tengo en xmm1 pero ahora en float y bueno lo q hizo la op....

			movups xmm0, xmm2
			cvtdq2ps xmm0, xmm0
			call pasarDeMenosUnoAUnoYDeCeroAMenosUno ; hace lo q hace dice pero me devuelve xmm0 en enteros

			cvtdq2ps xmm1, xmm1
			cvtdq2ps xmm0, xmm0

			movups xmm5, xmm12	 	; le pongo en xmm5 el registro con los alphas
			movups xmm6, xmm12


			mulps xmm6, xmm1 		; le multiplico al alfa  por uno si esta en la posicion de pixel maximo
									; o un -1 en caso contrario ACA QUEDAN LOS ALFAS DLEP IXEL 2

			mulps xmm5, xmm0		; ACA QUEDAN LOS ALFAS DEL PIXEL 1


			
			; == recordar que xmm10 tiene 4 floats = 1.
			pslldq xmm5, 4
			psrldq xmm5, 4
			pslldq xmm6, 4
			psrldq xmm6, 4
			
			addps xmm5, xmm10  
			addps xmm6, xmm10 ; aca me qda po lo que tengo q multiplicar a los pixeles iniciales para el resultado final
			


			.parada41:
			mov rax, r13
			mov r14, 3
			div r14
			cmp rdx, 0
			je .cont41
			cmp rdx, 1
			je .cont42
			cmp rdx, 2
			je .cont43
			
			.cont41:
			
			;============================================================================================
			
			pxor xmm0, xmm0

			movups xmm9, xmm7		; xmm9 == p7|p6|p5|p4
			movups xmm8, xmm7  		; xmm8 == p7|p6|p5|p4
			
		
			punpcklbw xmm7, xmm0  ; xmm7 == p5 | p4
			punpckhwd xmm7, xmm0 ; xmm7 == p5a | p5r | p5g |p5b

			;====================================================

			punpckhbw xmm9, xmm0  ; xmm9 == p7 | p6
			punpcklwd xmm9, xmm0  ; xmm9 == p6a | p6r | p6g |p6b

			;====================================================
			
			cvtdq2ps xmm7, xmm7
			cvtdq2ps xmm9, xmm9	  ; PASO AMBOS A FLOAT PARA PODER MULTIPLICAR POR EL VALOR DE CADA ALPHA

			mulps xmm9, xmm6
			mulps xmm7, xmm5

			cvtps2dq xmm7, xmm7
			cvtps2dq xmm9, xmm9
			
			
			packusdw xmm7, xmm9 ; xmm7 = quyedan pixel1|pixel0
			packuswb xmm7, xmm7 ; xmm7 = quedan pixel1|pixel0|pixel1|pixel0

			movq [rsi + r10*4], xmm7


			add r10, 2
			cmp r10, rbx
			jne .ciclo2

		add r9, 1
		add rdi,r8
		add rsi,r8

		jmp .ciclo1
		
		
		
	.fin:
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx
		ret


		
		
		
		
		
		
		
		
		;===========================.ciclo2.2:
			
			.cont12:
			movq r15, xmm1 
			
			;=== cuenta auxiliar para direccionamiento correcto
			lea r11, [r10*4]
			add r11, r8
			;===

			movdqu xmm2, [rdi + r11]	; xmm2 == p7|p6|p5|p4
			movups xmm7, xmm2  ; guardo los datos para despues

			;===
			movdqu xmm3, [rdi+r10*4]	; xmm3 == p11|p10|p9|p8
			;=== listo levante tdoso los datos q qria
			
						
			;========================== seccion maximos parcial
			pmaxub xmm1, xmm2 
			pmaxub xmm1, xmm3 ; guardo el max en xmm1 ==  pMax {3,7,11} | pmax{2,6,10}| pmax {1,5,9}| pmax {0,4,8}

			movups xmm3, xmm1 ; copio
			movups xmm2, xmm1

			psrldq xmm3, 8 ;   xmm3 == 0 | 0 | pmax1 {3,7,11} | pmax 2 {2,6,10}
			psrldq xmm1, 4 ;   xmm1 == 0 | fruta | pmax 2 {2,6,10} | pmax3 {1,5,9}

			pmaxub xmm3, xmm1 ; xmm3 == 0 | fruit | pmax {3,7,11,2,6,10} | pmax {2,6,10,1,5,9}

			pmaxub xmm2, xmm1 ; xmm2 == fruit | fruit | pmax {1,5,9,2,6,10} | pmax {0,4,8,1,5,9}

			pmaxub xmm2, xmm3 ; xmm2 == fruit | fruit | MaxP2 | MaxP1
			movups xmm1, xmm2 ; xmm1 == fruta | furta | maxP2 | MaxP1
			
			
			.parada22:
				mov rax, r15
				mov r14, 3
				div r14
				cmp rdx, 1
				je .cont21
				cmp rdx, 0
				je .cont22
				cmp rdx, 2
				je .cont23
				
			
			.cont22:
			;========== seccion para calcular el maximo de los maximos en xmm1

			psrldq xmm1, 1 ; shifteo 1 byte, xmm1 == | 0 |  -  | ... | -  | 		a2   | max2(r)  |  max2(g) | max2(b)  | 		 a1	  |  max1(r) | max1(g)  |

			pmaxub xmm1,xmm2 							 ; xmm1 == | - |  -  | ... | -  | max(a,r) | max(r,g) | max(g,b) | max(b,a) | max(a,r) | max(r,g) | max(g,b) |

			psrldq xmm1,1 ;  shifteo 1 byte, xmm1 == | 0 |  -  | ... | -  | 	 -		 | max(a,r) | max(r,g) | max(g,b) | max(b,a) | max(a,r) | max(r,g) |

			pmaxub xmm1, xmm2 ;  xmm1 =  | - | ... |  -  || -  | - | - | maxP2 (g,b,r) || - | - | - | maxP1 (g,b,r) ||

			pshufb xmm1, xmm11 ; xmm1 == || fruta || fruta || maxP2(g,b,r) | ... | maxP2(g,b,r) || maxP1(g,b,r) | ... | maxP1(g,b,r) ||

			pcmpeqb xmm1, xmm2 ; comparo el mayor de todos con los  maximos de cada canal en pixel 1 y 2

			;====== termino secccion en xmm1 me qda -1 en el byte de posicion igual al canal q tiene al maximo 0 en el resto
			;====== xmm1== fruta | fruta | InfoCopada2 | InfoCopada1 |
			
			pslldq xmm1, 8
			psrldq xmm1, 8 ; limpio parte alta de xmm1  osea  => xmm1 = 0|0|infoCopada2 | InfoCoapda1
			
			punpcklbw xmm1, xmm1  ; xmm1 == InfoCopada2High| I.C.2.L | I.C.1.H | I.C.1.L|
			
			movups xmm2, xmm1
						
			.parada32:
				mov rax, r13
				mov r14, 2
				div r14
				cmp rdx, 0
				je .cont32
				jne .cont31
				
			.cont32:
			
			
			punpcklwd xmm2, xmm1 ;  en cada dw me qda info copada sobre cada canala respectivamente del Pixel 1
			;checkeo caso dos maximos iguales:
			movups xmm0, xmm2
			call checkearCasoDosMaximos
			movups xmm2, xmm0
			
			
			punpckhwd xmm1, xmm1 ; en cada dw me qda info copada sobre cada canal respectivamente del Pixel 2
			movups xmm0, xmm1
			call checkearCasoDosMaximos
			movups xmm1, xmm0



			movups xmm0, xmm1
			cvtdq2ps xmm0, xmm0
			call pasarDeMenosUnoAUnoYDeCeroAMenosUno

			movups xmm1, xmm0	; lo mismo q antes tengo en xmm1 pero ahora en float y bueno lo q hizo la op....

			movups xmm0, xmm2
			cvtdq2ps xmm0, xmm0
			call pasarDeMenosUnoAUnoYDeCeroAMenosUno ; hace lo q hace dice pero me devuelve xmm0 en enteros

			cvtdq2ps xmm1, xmm1
			cvtdq2ps xmm0, xmm0

			movups xmm5, xmm12	 	; le pongo en xmm5 el registro con los alphas
			movups xmm6, xmm12


			mulps xmm6, xmm1 		; le multiplico al alfa  por uno si esta en la posicion de pixel maximo
									; o un -1 en caso contrario ACA QUEDAN LOS ALFAS DLEP IXEL 2

			mulps xmm5, xmm0		; ACA QUEDAN LOS ALFAS DEL PIXEL 1


			
			; == recordar que xmm10 tiene 4 floats = 1.
			pslldq xmm5, 4
			psrldq xmm5, 4
			pslldq xmm6, 4
			psrldq xmm6, 4
			
			addps xmm5, xmm10  
			addps xmm6, xmm10 ; aca me qda po lo que tengo q multiplicar a los pixeles iniciales para el resultado final
			
			
			
			.parada42:
			mov rax, r13
			mov r14, 3
			div r14
			cmp rdx, 0
			je .cont41
			cmp rdx, 1
			je .cont42
			cmp rdx, 2
			je .cont43
			
			.cont42:


			;============================================================================================
			
			pxor xmm0, xmm0

			movups xmm9, xmm7		; xmm9 == p7|p6|p5|p4
			movups xmm8, xmm7  		; xmm8 == p7|p6|p5|p4
			
		
			punpcklbw xmm7, xmm0  ; xmm7 == p5 | p4
			punpckhwd xmm7, xmm0 ; xmm7 == p5a | p5r | p5g |p5b

			;====================================================

			punpckhbw xmm9, xmm0  ; xmm9 == p7 | p6
			punpcklwd xmm9, xmm0  ; xmm9 == p6a | p6r | p6g |p6b

			;====================================================
			
			cvtdq2ps xmm7, xmm7
			cvtdq2ps xmm9, xmm9	  ; PASO AMBOS A FLOAT PARA PODER MULTIPLICAR POR EL VALOR DE CADA ALPHA

			mulps xmm9, xmm6
			mulps xmm7, xmm5

			cvtps2dq xmm7, xmm7
			cvtps2dq xmm9, xmm9
			
			
			packusdw xmm7, xmm9 ; xmm7 = quyedan pixel1|pixel0
			packuswb xmm7, xmm7 ; xmm7 = quedan pixel1|pixel0|pixel1|pixel0

			movq [rsi + r10*4], xmm7


			add r10, 2
			cmp r10, rbx
			jne .ciclo2

		add r9, 1
		add rdi,r8
		add rsi,r8

		jmp .ciclo1
		
		
		
		
		
		
		
		
		
		
		
		
		
		;================cciclo2.3
			
			.cont23:
			;========== seccion para calcular el maximo de los maximos en xmm1

			psrldq xmm1, 1 ; shifteo 1 byte, xmm1 == | 0 |  -  | ... | -  | 		a2   | max2(r)  |  max2(g) | max2(b)  | 		 a1	  |  max1(r) | max1(g)  |

			pmaxub xmm1,xmm2 							 ; xmm1 == | - |  -  | ... | -  | max(a,r) | max(r,g) | max(g,b) | max(b,a) | max(a,r) | max(r,g) | max(g,b) |

			psrldq xmm1,1 ;  shifteo 1 byte, xmm1 == | 0 |  -  | ... | -  | 	 -		 | max(a,r) | max(r,g) | max(g,b) | max(b,a) | max(a,r) | max(r,g) |

			pmaxub xmm1, xmm2 ;  xmm1 =  | - | ... |  -  || -  | - | - | maxP2 (g,b,r) || - | - | - | maxP1 (g,b,r) ||

			pshufb xmm1, xmm11 ; xmm1 == || fruta || fruta || maxP2(g,b,r) | ... | maxP2(g,b,r) || maxP1(g,b,r) | ... | maxP1(g,b,r) ||

			pcmpeqb xmm1, xmm2 ; comparo el mayor de todos con los  maximos de cada canal en pixel 1 y 2

			;====== termino secccion en xmm1 me qda -1 en el byte de posicion igual al canal q tiene al maximo 0 en el resto
			;====== xmm1== fruta | fruta | InfoCopada2 | InfoCopada1 |
			
			pslldq xmm1, 8
			psrldq xmm1, 8 ; limpio parte alta de xmm1  osea  => xmm1 = 0|0|infoCopada2 | InfoCoapda1
			
			punpcklbw xmm1, xmm1  ; xmm1 == InfoCopada2High| I.C.2.L | I.C.1.H | I.C.1.L|
							
			movups xmm2, xmm1
			
			
			punpcklwd xmm2, xmm1 ;  en cada dw me qda info copada sobre cada canala respectivamente del Pixel 1
			;checkeo caso dos maximos iguales:
			movups xmm0, xmm2
			call checkearCasoDosMaximos
			movups xmm2, xmm0
			
			
			punpckhwd xmm1, xmm1 ; en cada dw me qda info copada sobre cada canal respectivamente del Pixel 2
			movups xmm0, xmm1
			call checkearCasoDosMaximos
			movups xmm1, xmm0



			movups xmm0, xmm1
			cvtdq2ps xmm0, xmm0
			call pasarDeMenosUnoAUnoYDeCeroAMenosUno

			movups xmm1, xmm0	; lo mismo q antes tengo en xmm1 pero ahora en float y bueno lo q hizo la op....

			movups xmm0, xmm2
			cvtdq2ps xmm0, xmm0
			call pasarDeMenosUnoAUnoYDeCeroAMenosUno ; hace lo q hace dice pero me devuelve xmm0 en enteros

			cvtdq2ps xmm1, xmm1
			cvtdq2ps xmm0, xmm0

			movups xmm5, xmm12	 	; le pongo en xmm5 el registro con los alphas
			movups xmm6, xmm12


			mulps xmm6, xmm1 		; le multiplico al alfa  por uno si esta en la posicion de pixel maximo
									; o un -1 en caso contrario ACA QUEDAN LOS ALFAS DLEP IXEL 2

			mulps xmm5, xmm0		; ACA QUEDAN LOS ALFAS DEL PIXEL 1


			
			; == recordar que xmm10 tiene 4 floats = 1.
			pslldq xmm5, 4
			psrldq xmm5, 4
			pslldq xmm6, 4
			psrldq xmm6, 4
			
			addps xmm5, xmm10  
			addps xmm6, xmm10 ; aca me qda po lo que tengo q multiplicar a los pixeles iniciales para el resultado final
			
			
			
			.parada43:
			mov rax, r13
			mov r14, 3
			div r14
			cmp rdx, 0
			je .cont41
			cmp rdx, 1
			je .cont42
			cmp rdx, 2
			je .cont43
			
			.cont43:


			;============================================================================================
			
			pxor xmm0, xmm0

			movups xmm9, xmm7		; xmm9 == p7|p6|p5|p4
			movups xmm8, xmm7  		; xmm8 == p7|p6|p5|p4
			
		
			punpcklbw xmm7, xmm0  ; xmm7 == p5 | p4
			punpckhwd xmm7, xmm0 ; xmm7 == p5a | p5r | p5g |p5b

			;====================================================

			punpckhbw xmm9, xmm0  ; xmm9 == p7 | p6
			punpcklwd xmm9, xmm0  ; xmm9 == p6a | p6r | p6g |p6b

			;====================================================
			
			cvtdq2ps xmm7, xmm7
			cvtdq2ps xmm9, xmm9	  ; PASO AMBOS A FLOAT PARA PODER MULTIPLICAR POR EL VALOR DE CADA ALPHA

			mulps xmm9, xmm6
			mulps xmm7, xmm5

			cvtps2dq xmm7, xmm7
			cvtps2dq xmm9, xmm9
			
			
			packusdw xmm7, xmm9 ; xmm7 = quyedan pixel1|pixel0
			packuswb xmm7, xmm7 ; xmm7 = quedan pixel1|pixel0|pixel1|pixel0

			movq [rsi + r10*4], xmm7


			add r10, 2
			cmp r10, rbx
			jne .ciclo2

		add r9, 1
		add rdi,r8
		add rsi,r8

		jmp .ciclo1




; pasarle un registro con floats sino no funca naAaaaaa!
pasarDeMenosUnoAUnoYDeCeroAMenosUno:
; en xmm0 me viene el registro a cambiar de a dobles words son

pxor xmm14, xmm14 ; foward clean
cvtdq2ps xmm14, xmm14

movdqu xmm15, [MenosUnosEnDobleW]	; les meto toddas F
cvtdq2ps xmm15, xmm15		; los convierto en floats



mulps xmm0, xmm15		; multiplico todos los valores por menos uno, asi que lo que era -1 ahora es 1 y lo que es cero sigue siendo cero

movups xmm13, xmm0

cmpps xmm13, xmm14, 0		; en donde habia ceros ahora hay menos unos y donde habia unos quedan ceros

cvtps2dq xmm0, xmm0

paddd xmm0,xmm13

ret


; en xmm0 viene el registro 
checkearCasoDosMaximos:
	pmovmskb eax, xmm0
	shl rax, 52
	shr rax, 52
	cmp rax, 0xf0f
	je .casoRyB
	cmp rax, 0xff0
	je .casoRyG
	cmp rax, 0x0ff
	je .casoGyB
	cmp rax, 0xfff
	je .casoRyGyB
	jmp .fin
	 
	.casoRyB:
		movdqu xmm14, [casoRyB]
		pand xmm0, xmm14
		jmp .fin
	.casoRyG:
		movdqu xmm14, [casoRyG]
		pand xmm0, xmm14
		jmp .fin
	.casoGyB:
		movdqu xmm14, [casoGyB]
		pand xmm0, xmm14
		jmp .fin
	.casoRyGyB:
		movdqu xmm14, [casoRyGyB]
		pand xmm0, xmm14
		jmp .fin	 
	.fin:
		ret 
		
ponerBordesBien:
	push r14
	push r15
	
	
	xor r10, r10
	mov r14, rdi
	mov r15, rsi
	.ciclo1:
		cmp r10, rbx
		je .cont1
		movdqu xmm1, [r14+r10*4]
		movdqu [r15+r10*4], xmm1
		add r10, 4
		jmp .ciclo1
	.cont1:
	
	xor r10, r10	
	add r10, 1
	.ciclo2:
		cmp r10, rcx
		je .cont2
		mov eax, [r14]
		mov [r15], eax
		
		mov eax, [r14 + r8 - 4]
		mov [r15 + r8 - 4], eax
		add r10, 1
		add r15, r8
		add r14, r8
		jmp .ciclo2
	.cont2:
	
	xor r10, r10
	.ciclo3:
		cmp r10, rbx
		je .fin
		movdqu xmm1, [r14+r10*4]
		movdqu [r15+r10*4], xmm1
		add r10, 4
		jmp .ciclo3
	
	 
	.fin:
	
	pop r15
	pop r14
	ret
