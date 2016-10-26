#include "../tp2.h"
#include <stdio.h>


float clamp2(float pixel)
{
	float res;
	if ( pixel < 0.0) res = 0.0;
	else res = pixel;

	if ( pixel > 255.0) res = 255.0;
	else res = pixel; 
	
	return res;
}

unsigned char maximo(unsigned char* a, int n){
	unsigned char res = a[0];
	for (int i = 0; i < n ; i++){
	//	printf("%d, \n", a[i] );
		if( res < a[i] ) res = a[i];
	}
	//printf(" El maximo es : %d\n", res);
	return res;
}

void maximos(bgra_t* a, bgra_t* b, bgra_t* c, unsigned char * res){
	unsigned char aux [9] = { (a-4)->b, a->b, (a+4)->b, (b-4)->b, b->b, (b+4)->b, (c-4)->b, c->b, (c+4)->b };
	res[0] = maximo(aux, 9);
	
	unsigned char aux2 [9] = { (a-4)->g, a->g, (a+4)->g, (b-4)->g, b->g, (b+4)->g, (c-4)->g, c->g, (c+4)->g };
	res[1] = maximo(aux2, 9);
	
	unsigned char aux3 [9] = { (a-4)->r, a->r, (a+4)->r, (b-4)->r, b->r, (b+4)->r, (c-4)->r, c->r, (c+4)->r };
	res[2] = maximo(aux3, 9);
}

void colorizar_c (
	unsigned char *src,
	unsigned char *dst,
	int cols,
	int filas,
	int src_row_size,
	int dst_row_size,
	float alpha
) {
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	for (int f = 1; f < filas-1; f++) {
		for (int c = 1; c < cols-1; c++) {
			bgra_t *p1_s = (bgra_t*) &src_matrix[f-1][c * 4];
            bgra_t *p2_s = (bgra_t*) &src_matrix[f][c * 4];
            bgra_t *p3_s = (bgra_t*) &src_matrix[f+1][c * 4];

            //unsigned char res[3];
            //maximos( p1_s, p2_s, p3_s, res);
            
            
            unsigned char res[3] = {0,0,0}; 
            for(int ff=-1;ff<=1;ff++) {
               for(int cc=-1;cc<=1;cc++) {
				   if( res[0] < ((bgra_t*)&src_matrix[f+ff][c*4+cc*4])->b ) {
					   res[0] = ((bgra_t*)&src_matrix[f+ff][c*4+cc*4])->b;
				   }
				   if( res[1] < ((bgra_t*)&src_matrix[f+ff][c*4+cc*4])->g ) {
					   res[1] = ((bgra_t*)&src_matrix[f+ff][c*4+cc*4])->g;
				   }
				   if( res[2] < ((bgra_t*)&src_matrix[f+ff][c*4+cc*4])->r ) {
					   res[2] = ((bgra_t*)&src_matrix[f+ff][c*4+cc*4])->r;
				   }
			   }
		   }

            bgra_t *p_d = (bgra_t*) &dst_matrix[f][c * 4];
            
            float alpha1;
            float alpha2;
            float alpha3;
            if (res[0] > res[2] && res[0] > res[1]) alpha1 = 1+alpha;
            else alpha1 = 1- alpha;

            if( res[1] > res[2] && res[1] >= res[0]) alpha2 = 1+ alpha; 
			else alpha2 = 1 - alpha;

			if( res[2] >= res[1] && res[2] >= res[0]) alpha3 = 1 +alpha;
			else alpha3 = 1 - alpha;

			
			p_d->b = clamp2(p2_s->b * alpha1);
			p_d->g = clamp2(p2_s->g * alpha2);
			p_d->r = clamp2(p2_s->r * alpha3);

		}
	}
}
