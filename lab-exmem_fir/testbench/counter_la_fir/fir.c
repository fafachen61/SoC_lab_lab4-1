#include "fir.h"

void __attribute__ ( ( section ( ".mprjram" ) ) ) initfir() {
	//initial your fir
}

int* __attribute__ ( ( section ( ".mprjram" ) ) ) fir(){
	initfir();
	//write down your fir
	int term_num;
	int result;
	for(int i=0; i<11; i++){
		term_num = i+1;
		result = 0;
		for(int j=0; j<term_num; j++){
			result  = result + taps[N-term_num+j] * inputsignal[j];
		}
		outputsignal[i] = result;
	}
	// outputsignal[0] = 11;
	// outputsignal[1] = 10;
	// outputsignal[2] = 9;
	// outputsignal[3] = 8;
	// outputsignal[4] = 7;
	// outputsignal[5] = 6;
	// outputsignal[6] = 5;
	// outputsignal[7] = 4;
	// outputsignal[8] = 3;
	// outputsignal[9] = 2;
	// outputsignal[10] = 1;

	return outputsignal;
}
		
