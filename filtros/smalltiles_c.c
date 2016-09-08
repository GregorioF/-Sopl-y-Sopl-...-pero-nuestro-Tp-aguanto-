
#include "../tp2.h"
#include <stdio.h>
#include <stdlib.h>

void smalltiles_c (unsigned char *src, unsigned char *dst, int cols, int filas, int src_row_size, int dst_row_size) {
	//COMPLETAR
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
	
	// ejemplo de uso de src_matrix y dst_matrix (copia la imagen)

	int ancho = div(cols, 2).quot;
	int largo = div(filas,2).quot;

	for (int f = 0; f < largo; f++) {
		for (int c = 0; c < ancho; c++) {

			bgra_t *p_s = (bgra_t*) &src_matrix[2*f][c * 8];

			for(int i = 0; i < 2; i++){
				
				bgra_t *p_d = (bgra_t*) &dst_matrix[f][(c  + ancho*i)*4];

				p_d->b = p_s->b;
				p_d->g = p_s->g;
				p_d->r = p_s->r;
				p_d->a = p_s->a;
			}

			for(int i = 0; i < 2; i++){
				
				bgra_t *p_d = (bgra_t*) &dst_matrix[f + largo][(c  + ancho*i)*4];

				p_d->b = p_s->b;
				p_d->g = p_s->g;
				p_d->r = p_s->r;
				p_d->a = p_s->a;
			}

		}
	}

}

	
