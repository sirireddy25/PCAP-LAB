%%cu 

#include<cuda.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

__global__ void q1a(char *d_A, char *d_B, int *d_index){
	int idx = threadIdx.x;
	int start, end, len;
	if(idx == 0){
		start = 0;
	}
	else{
		start = d_index[idx] + 1;
	}

	end = d_index[idx + 1] - 1;
	int j = start;
	for(int i = end; i >= start; i--){
		d_B[j++] = d_A[i];
	}
	d_B[j] = ' ';
}

int main(){
	char *d_A, *d_B;
  	int *d_index;
	char h_A[100], h_B[100];

	strcpy(h_A, "hello world bye world");

	int size = strlen(h_A)*sizeof(char);
	int index[10];
	int wordcount = 0, k = 0;

	index[k++] = 0;
	for(int i = 0; i < strlen(h_A); i++){
		if(h_A[i] == ' '){
			wordcount++;
			index[k++] = i;
		}
	}
	wordcount++;
	index[k] = strlen(h_A);

	cudaMalloc((void**)&d_A, size);
	cudaMalloc((void**)&d_B, size);
	cudaMalloc((void**)&d_index, (wordcount + 1)*sizeof(int));


	cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_index, index, (wordcount + 1)*sizeof(int) , cudaMemcpyHostToDevice);

	dim3 grid(1, 1, 1);
	dim3 block(wordcount, 1, 1);
	q1a<<<grid, block>>>(d_A, d_B, d_index);

	cudaMemcpy(h_B, d_B, size, cudaMemcpyDeviceToHost);

	printf("result: %s\n", h_B);

}