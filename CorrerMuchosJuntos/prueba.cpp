#include <iostream>
#include <stdio.h>
using  namespace std;


int main(){
	string tamanios [] = {"204x204", "256x256", "512x512", "1024x768"};
	
	string tu = "tuvieja";
	
	FILE * pfile ;
	pfile = fopen( "mytext.txt", "w");
	
	for(int i = 0 ; i < 4; i ++){
	//	fprintf(pfile, "./tp2catedra -v colorizar -i c lena.%s.bmp 0.5 \n", tamanios[i].c_str());
		fprintf(pfile, "./bmpdiff -i lena.%s.bmp.colorizar.ASM.bmp lena.%s.bmp.colorizar.C.bmp 10 \n", tamanios[i].c_str(), tamanios[i].c_str());
	}
	
	

	fclose(pfile);

	return 0; 
}
