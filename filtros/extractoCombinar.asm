section .rodata
		mascara255: dd 255.0, 255.0, 255.0, 255.0
		menos1: dd -1.0, -1.0, -1.0, -1.0
...
section .text
pshufd xmm0, xmm0, 00000000b ; Paso el alpha a los otros lugares: xmm0 == | alpha | alpha | alpha | alpha |
movdqu xmm14, [mascara255] ; xmm14 == | 255.0 | 255.0 | 255.0 | 255.0 |
movdqu xmm1, [rdi + 4*r9] ; agarro 4 píxeles de la mitad izquierda de la foto		; xmm1 = p3|p2|p1|p0
movdqu xmm3, [r11 + r15] ; agarro 4 píxeles de la mitad derecha de la foto		; xmm3 = p7|p6|p5|p4
punpcklbw xmm1, xmm9 ; | 0 | píxel 1 a | 0 | píxel 1 r | 0 | píxel 1 g | 0 | píxel 1 b | 0 | píxel 0 a | 0 | píxel 0 r | 0 | píxel 0 g | 0 | píxel 0 b |
punpckhbw xmm4, xmm9 ; | 0 | píxel 7 a | 0 | píxel 7 r | 0 | píxel 7 g | 0 | píxel 7 b | 0 | píxel 6 a | 0 | píxel 6 r | 0 | píxel 6 g | 0 | píxel 6 b |
punpcklwd xmm1, xmm9 ; | 0 | 0 | 0 | píxel 0 a | 0 | 0 | 0 | píxel 0 r | 0 | 0 | 0 | píxel 0 g | 0 | 0 | 0 | píxel 0 b |
punpckhwd xmm8, xmm9 ; | 0 | 0 | 0 | píxel 7 a | 0 | 0 | 0 | píxel 7 r | 0 | 0 | 0 | píxel 7 g | 0 | 0 | 0 | píxel 7 b |
movdqu xmm10, xmm1 ; xmm10 == | 0 | 0 | 0 | píxel 0 a | 0 | 0 | 0 | píxel 0 r | 0 | 0 | 0 | píxel 0 g | 0 | 0 | 0 | píxel 0 b |
psubd xmm10, xmm8 ; resto los 2 píxeles correspondientes, | 0 | 0 | 0 | píxel 0 a - píxel 7 a | 0 | 0 | 0 | píxel 0 r - píxel 7 r | 0 | 0 | 0 | píxel 0 g - píxel 7 g | 0 | 0 | 0 | píxel 0 b -píxel 7 b |
cvtdq2ps xmm8, xmm8	; xmm8 == pixel 7
cvtdq2ps xmm10, xmm10 ; xmm10 == | píxel 0 a - píxel 7 a | píxel 0 r - píxel 7 r | píxel 0 g - píxel 7 g | píxel 0 b - píxel 7 b |
mulps xmm10, xmm0 ; Multiplico por alpha: xmm10 == | alpha *  | ... | ... | alpha *  | (pixel 0 - pixel 3)
divps xmm10, xmm14 ; xmm10 == alpha * ( pixel 0 - pixel 7)  / 255
addps xmm10, xmm8 ; xmm10 == ( alpha * ( pixel 0 - pixel 7)  / 255 )  + pixel 7 = dst 0
movups xmm15, xmm10 ; xmm15 == ( alpha * ( pixel 0 - pixel 7)  / 255 )  + pixel 7 = dst 0
subps xmm15, xmm8 ; xmm15 == ( alpha * ( pixel 0 - pixel 7)  / 255 )
cvtps2dq xmm10, xmm10 ; Convierto a enteros
; ============ Empaqueto ========================================
packusdw xmm13, xmm12 ; empaqueto de dw a w, xmm13 == pixel de xmm12, es decir, el pixel 2, seguido del pixel de xmm13, el 3
packusdw xmm11, xmm10 ; empaqueto de dw a w, xmm11 == pixel de xmm10, es decir, el pixel 0, seguido del pixel de xmm11, el 1
packuswb xmm13, xmm11 ; empaqueto de w a b, xmm13 == pixel 0, pixel 1, pixel 2, pixel 3
pshufd xmm11, xmm13, 0x1b		; esto porque tienen q ser al revés la de un lado a la del otro!
; ============ Pongo en la imagen destino en la mitad izquierda de la imagen =======================
movdqu [rsi + 4*r9], xmm11
; =============== PARA LA PARTE DERECHA =========================
mulps xmm15, [menos1] ; uso lo ya multiplicado por alpha y dividido por 255 y lo multiplico por -1.
                      ; xmm15 == ( alpha * ( pixel 7 - pixel 0)  / 255 )
cvtdq2ps xmm1, xmm1 ; Convierto a float lo que voy a sumar
                    ; xmm1 == | píxel 0 a | píxel 0 r | píxel 0 g | píxel 0 b |
addps xmm15, xmm1 ; Sumo, ; xmm15 == ( alpha * ( pixel 7 - pixel 0)  / 255 ) + pixel 0
cvtps2dq xmm15, xmm15 ; Convierto a entero
; ============ Empaqueto ========================================
packusdw xmm7, xmm4 ; empaqueto de dw a w, xmm7 == pixel de xmm4, es decir, el pixel 2, seguido del pixel de xmm7, el 3
packusdw xmm8, xmm15 ; empaqueto de dw a w, xmm8 == pixel de xmm15, es decir, el pixel 0, seguido del pixel de xmm8, el 1
packuswb xmm7, xmm8 ; empaqueto de w a b, xmm7 == pixel 0, pixel 1, pixel 2, pixel 3
; ============ Pongo en la imagen destino en la mitad derecha de la imagen =======================
movdqu [r12 + r15], xmm7
