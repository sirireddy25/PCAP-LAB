%%cu
#include<stdio.h>
#include<cuda.h>
#include<stdlib.h>
#define TW 4

__device__ __constant__ int MW;
__device__ __constant__ int mask[5];

__global__ void conv(int *d_A, int *d_B, int width){
	
  	int idx = threadIdx.x + blockIdx.x*blockDim.x;
	__shared__ int AS[TW];

	AS[threadIdx.x] = d_A[idx];

	__syncthreads();

	int this_tile_start_point = blockIdx.x*blockDim.x;
	int next_tile_start_point = (blockIdx.x + 1)*blockDim.x;

	int start_point = idx - (MW/2);

	int output = 0;
  	int j = 0;
	for(int i = 0; i < MW; i++){
		if( start_point + i >= 0 && start_point + i < width){
			if(start_point + i >= this_tile_start_point && start_point + i < next_tile_start_point){
				output += AS[j] * mask[i];
        		j++;
			}
			else{
				output += d_A[start_point + i]*mask[i];
			}
		}
	}

	d_B[idx] = output;
}

int main(){
	int *h_A,*h_B, *h_M, *d_A, *d_B;
	int mask_width, width;

	width = 16;
	mask_width = 5;

	int M[] = {1, 1, 2, 1, 1};
	int A[] = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 11, 120, 130, 140, 150, 160};

	int size = width*sizeof(int);

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
	cudaMemcpyToSymbol(MW, &mask_width, sizeof(int), 0, cudaMemcpyHostToDevice);
	cudaMemcpyToSymbol(mask, h_M, mask_width*sizeof(int), 0, cudaMemcpyHostToDevice);

	dim3 grid(4, 1, 1);
	dim3 block(4, 1, 1);

	conv<<<grid, block>>>(d_A, d_B, width);

	cudaMemcpy(h_B, d_B, size, cudaMemcpyDeviceToHost);

	printf("result: \n");
	for(int i = 0; i < width; i++){
		printf("%d ", h_B[i]);
	}

}