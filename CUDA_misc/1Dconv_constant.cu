%%cu
//1D parallel convolution using constant memory
#include<cuda.h>
#include<stdio.h>
#include<stdlib.h>

__device__ __constant__ int MW;
__device__ __constant__ int mask[3];

__global__ void conv(int* d_A, int* d_B, int width){
	int idx = threadIdx.x;

	int start_point = idx - (MW/2);

	int output = 0;
	for(int i = 0; i < MW; i++){
		if(start_point + i >= 0 && start_point + i < width ){
			output += d_A[start_point + i] * mask[i];
		}
	}

	d_B[idx] = output;
}

int main(){
	int *h_A, *h_B, *h_M, *d_A, *d_B;
	int width = 7;
	int mask_width = 3;
	int size = width * sizeof(int);

	int A[] = {1, 2, 3, 4, 5, 6, 7};
	int M[] = {1, 2, 1};

	h_A = (int*)malloc(size);
	h_B = (int*)malloc(size);
	h_M = (int*)malloc(mask_width*sizeof(int));

	for(int i = 0; i < width; i++){
		h_A[i] = A[i];
	}
 
	for(int i = 0; i < mask_width; i++){
	     h_M[i] = M[i];
	}

	cudaMalloc((void**)&d_A, size);
	cudaMalloc((void**)&d_B, size);

	cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
	cudaMemcpyToSymbol(mask , h_M, sizeof(int)*mask_width, 0, cudaMemcpyHostToDevice);
	cudaMemcpyToSymbol(MW , &mask_width, sizeof(int), 0, cudaMemcpyHostToDevice);
 
	dim3 grid(1, 1, 1);
	dim3 block(width, 1, 1);
	conv<<<grid, block>>>(d_A, d_B, width);

	cudaMemcpy(h_B, d_B, size, cudaMemcpyDeviceToHost);

	printf("result: \n");
	for(int i = 0; i < width; i++){
		printf("%d ", h_B[i]);
	}

}