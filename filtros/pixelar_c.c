
#include "../tp2.h"

float promedio( unsigned char a , unsigned char b , unsigned char c , unsigned char d ){
	float af = a; 
	float bf = b;
	float cf = c;
	float df = d;
	return (af/4+bf/4+cf/4+df/4);

}

void pixelar_c (unsigned char *src, unsigned char *dst, int cols, int filas, int src_row_size, int dst_row_size) {
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	//COMPLETAR
	for (int f = 0; f < filas; f+=2) {
		for (int c = 0; c < cols; c+=2) {
			bgra_t *p_d = (bgra_t*) &dst_matrix[f][c * 4];
            bgra_t *p_s = (bgra_t*) &src_matrix[f][c * 4];

			bgra_t *p_d2 = (bgra_t*) &dst_matrix[f][(c+1) * 4];
            bgra_t *p_s2 = (bgra_t*) &src_matrix[f][(c+1) * 4];

			bgra_t *p_d3 = (bgra_t*) &dst_matrix[f+1][(c+1) * 4];
            bgra_t *p_s3 = (bgra_t*) &src_matrix[f+1][(c+1) * 4];

			bgra_t *p_d4 = (bgra_t*) &dst_matrix[f+1][c * 4];
            bgra_t *p_s4 = (bgra_t*) &src_matrix[f+1][c * 4];

            float k = 0.5;

			unsigned char b = promedio ( p_s->b, p_s2->b, p_s3->b, p_s4->b ) ;
			unsigned char g = promedio ( p_s->g, p_s2->g, p_s3->g, p_s4->g ) ;
			unsigned char r = promedio ( p_s->r, p_s2->r, p_s3->r, p_s4->r ) ;
			unsigned char a = promedio ( p_s->a, p_s2->a, p_s3->a, p_s4->a ) ;


			p_d->b = b;
			p_d->g = g;
			p_d->r = r;
			p_d->a = a;

			p_d2->b = b;
			p_d2->g = g;
			p_d2->r = r;
			p_d2->a = a;
			
			p_d3->b = b;
			p_d3->g = g;
			p_d3->r = r;
			p_d3->a = a;
			
			p_d4->b = b;
			p_d4->g = g;
			p_d4->r = r;
			p_d4->a = a;

		}
	}


}
