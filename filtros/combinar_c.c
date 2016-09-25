
#include "../tp2.h"

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

			bgra_t *p_sa = (bgra_t*) &src_matrix[f][c * 4];
			bgra_t *p_sb = (bgra_t*) &src_matrix[f][(cols - c -1) * 4];
			bgra_t *p_d = (bgra_t*) &dst_matrix[f][c * 4];


			p_d->b = clamp(combine(p_sa->b, p_sb->b, alpha));
			p_d->g = clamp(combine(p_sa->g, p_sb->g, alpha));
			p_d->r = clamp(combine(p_sa->r, p_sb->r, alpha));
			p_d->a = clamp(combine(p_sa->a, p_sb->a, alpha));

		}
	}
}
