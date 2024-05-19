%%cu

#include<cuda.h>
#include<stdlib.h>
#include<stdio.h>
#include<string.h>

__global__ void q3a(char *d_sin, char*d_T){
	int idx = threadIdx.x;

	int letter = d_sin[idx];

	int start = 0;

	if (idx == 0){
		start = 0;
	}
	else{
		for(int i = 1; i <= idx; i++){
			start += i;
		}
	}

	for(int i = 0; i < idx + 1; i++){
		d_T[start] = letter;
    start += 1;
	}


}

int main(){
	char str[] = "Hai";
	int len = strlen(str);

	int Tlen = 0;
	for(int i = 1; i <= len; i++){
		Tlen += i;
	}

	char sin[len], T[Tlen];
	char *d_sin, *d_T;

	strcpy(sin, str);

	int sin_size = len*sizeof(char);
	int T_size = Tlen*sizeof(char);

	cudaMalloc((void**)&d_sin, sin_size);
	cudaMalloc((void**)&d_T, T_size);

	cudaMemcpy(d_sin, sin, sin_size, cudaMemcpyHostToDevice);

	dim3 grid(1, 1, 1);
	dim3 block(len, 1, 1);
	q3a<<<grid, block>>>(d_sin, d_T);

	cudaMemcpy(T, d_T, T_size, cudaMemcpyDeviceToHost);

	printf("result: %s\n", T);
}