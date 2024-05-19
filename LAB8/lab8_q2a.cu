%%cu

#include<cuda.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

__global__ void q2a(char *d_sin, char *d_sout, int len, int n){
	int idx = threadIdx.x;

	char letter = d_sin[idx];
	int offset = idx;

	for(int i = 0; i < n; i++){
		d_sout[offset] = letter;
		offset += len;
	}

}

int main(){
	int n = 3;
	char str[] = "hello";
	int len = strlen(str);
	char sin[len], sout[len*n];
	char *d_sin, *d_sout;

	strcpy(sin, "Hello");

	int size_sin = len*sizeof(char);
	int size_sout = n*len*sizeof(char);

	cudaMalloc((void**)&d_sin, size_sin);
	cudaMalloc((void**)&d_sout, size_sout);

	cudaMemcpy(d_sin, sin, size_sin, cudaMemcpyHostToDevice);

	dim3 grid(1, 1, 1);
	dim3 block(len, 1, 1);
	q2a<<<grid, block>>>(d_sin , d_sout, len, n);

	cudaMemcpy(sout, d_sout, size_sout, cudaMemcpyDeviceToHost);

	printf("result: %s\n", sout);

}