
#include "../tp2.h"
#include "../helper/tiempo.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

char* name = "tiemposLeer.csv";

float clamp(float pixel)
{
	float res = pixel < 0.0 ? 0.0 : pixel;
	return res > 255.0 ? 255.0 : res;
}

float combine(unsigned char a, unsigned char b, float alpha){
	float af = a;
	float bf = b;

	return (((alpha*(af - bf))/255.0) + bf);
}

void combinar_c (unsigned char *src, unsigned char *dst, int cols, int filas, int src_row_size, int dst_row_size,float alpha) {

	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	for(int f = 0; f<filas; f++){
		for(int c = 0; c<cols; c++){

			volatile unsigned long long start, end;
			MEDIR_TIEMPO_START(start);
			//lectura:
			bgra_t *p_sa = (bgra_t*) &src_matrix[f][c * 4];
			bgra_t *p_sb = (bgra_t*) &src_matrix[f][(cols - c -1) * 4];
			bgra_t *p_d = (bgra_t*) &dst_matrix[f][c * 4];
			MEDIR_TIEMPO_STOP(end);

			// precesamiento:
			float n = clamp(combine(p_sa->b, p_sb->b, alpha));
			float n2 = clamp(combine(p_sa->g, p_sb->g, alpha));
			float n3 = clamp(combine(p_sa->r, p_sb->r, alpha));
			float n4 = clamp(combine(p_sa->a, p_sb->a, alpha));

			//escritura:

			p_d->b = n;
			p_d->g = n2;
			p_d->r = n3;
			p_d->a = n4;

			volatile unsigned long long int cant_ciclos = end-start;
			FILE *pFile = fopen( name, "a" );
			fprintf(pFile,"%.3f\n", (float)cant_ciclos;
			fclose( pFile );


		}
	}
}
