
#include "../tp2.h"

void pixelar_c (unsigned char *src, unsigned char *dst, int cols, int filas, int src_row_size, int dst_row_size) {
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	for(int f = 0; f < filas; f++){
		for(int c = 0; c < cols; c++){

			bgra_t *p_d = (bgra_t*) &dst_matrix[f][c * 4];

			p_d->b = 0;
			p_d->g = 0;
			p_d->r = 0;
			p_d->a = 0;
			
			for(int i=0; i < 2; i++){

				for(int j = 0 ; j<2 ; j++){

					bgra_t *p_s = (bgra_t*) &src_matrix[f+i][(c + j) * 4];
					
					p_d->b = p_d->b + (p_s->b/4);
					p_d->g = p_d->g + (p_s->g/4);
					p_d->r = p_d->r + (p_s->r/4);
					p_d->a = p_d->a + (p_s->a/4);

				}
			}
			for(int i=0; i < 2; i++){

				for(int j = 0 ; j<2 ; j++){

					bgra_t *p_d1 = (bgra_t*) &dst_matrix[f+i][(c+j) * 4];
					
					p_d1->b = p_d->b;
					p_d1->g = p_d->g;
					p_d1->r = p_d->r;
					p_d1->a = p_d->a;

				}
			}
	
			c=c+1;
		}

		f=f+1;
	}

	
}
