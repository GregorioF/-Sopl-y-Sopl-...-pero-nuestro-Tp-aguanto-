#include <iostream>

using namespace std;

int tams [] ={204*204, 43264, 256*256, 512*512, 1024*768, 1024*1024 , 2048*1024, 1024*2048, 2048*2048, 4096*4096};

long int ciclosC0Rojo2 [] = {1, 9507201.000, 14307005.000, 57302136.000, 181463760.000, 233336240.000, 1, 1, 1, 1};

long int ciclosC0 [] = {16408088, 17776530.000, 26776683, 99544152, 294242816, 389767744, 760021888, 726832512, 1431769600, 5333222912};

long int ciclosC3 [] = {2032783.250, 1900281.250, 2957188.000, 11609813.000, 39881976.000, 55542356.000, 97794328.000, 117880848.000, 195195696.000, 773635712.000};

long int ciclosAsm[] = {1716395.625, 999626.000, 1657268, 6293405.000, 19035442.000,  32136688.000,  51055872.000, 69079152.000, 102727088.000, 411247808.000};

long int ciclosC3Rojo[] = {1, 2097196.750, 2695413.250, 10801330.000, 35554860.000, 54525560.000, 95880488.000, 115541072.000, 189283952.000, 758990720.000};

long int ciclosC0Rojo[] = {1, 9494461.000, 14248083.000, 57144616.000, 173296560.000, 229725136.000, 460218272.000, 462068288.000, 919972544.000, 3704177152.000};

long int ciclosAsmRojo[] ={1, 1594691.750, 1621886.500, 6669256.500, 19364506.000, 31780836.000, 51335488.000, 70017024.000, 102535992.000, 415381760.000};

long int ciclosC0Azul[] = {1, 20525422.000, 14758814.000, 58368056.000, 167942096.000, 224616272.000, 457854048.000, 449236896.000, 906885760.000, 3600436736.000};

long int ciclosC0MismTam[] = {383843840.000, 387171360.000, 369981952.000, 370681280.000, 350379392.000};

long int ciclosC3MismTam[] = {55598388.000, 48429052.000, 45921260.000, 47870328.000, 46229268.000};

long int ciclosAsmMismTam [] = {31485386.000, 	25542546.000, 24698182.000, 25553268.000, 24846540.000};
int main(){
	int i  = 0;
	while(i < 10){
		float res = ciclosC0Rojo2[i]/tams[i];
		cout << res  <<endl;
		i++;
	}	

	return 0 ;
}