%%cu 

#include<stdio.h>
#include<stdlib.h>
#include<cuda.h>

#define TW 2

__global__ void practice(int *d_M, int *d_N, int *d_P, int width){

	//elements brought in by collaboration stored in M and N
	__shared__ int M[TW][TW];
	__shared__ int N[TW][TW];

	int tx = threadIdx.x;
	int ty = threadIdx.y;
	int bx = blockIdx.x;
	int by = blockIdx.y;

	//finding out row and column of the element in the output array that we want to work on
	int row = ty + by*TW;
	int col = tx + bx*TW;

	int product = 0;

	// no. of phases = width/TW
	// for loop to loop for no. of phases


	for(int i = 0; i < width/TW; i++){

		//collaborative loading of d_M and d_N tiles into shared memory
		// we are seeing which element the thread needs to bring in for each phase

		M[ty][tx] = d_M[row*width + TW*i + tx];
		N[ty][tx] = d_N[(i*TW +ty)*width + col];

		__syncthreads();

		//calculating partial sum
		for(int i = 0; i < TW; i++){
			product += M[ty][i]*N[i][tx];
		}
	}

	d_P[row*width + col] = product;
}


int main(){
	int *h_M, *h_N, *h_P, *d_N, *d_M, *d_P;

	int m = 4, n = 4;

	int M[] = {1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8};
	int N[] = {1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8};

	int size = m * n * sizeof(int);

	h_M = (int*)malloc(size);
	h_N = (int*)malloc(size);
	h_P = (int*)malloc(size);

	for(int i = 0; i < m*n ; i++){
		h_M[i] = M[i];
		h_N[i] = N[i];
	}

	cudaMalloc((void**)&d_M, size);
	cudaMalloc((void**)&d_N, size);
	cudaMalloc((void**)&d_P, size);

	cudaMemcpy(d_M, h_M, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_N, h_N, size, cudaMemcpyHostToDevice);

	dim3 grid(m/TW, n/TW, 1);
	dim3 block(TW, TW, 1);
	practice<<<grid, block>>>(d_M, d_N, d_P, n);

	cudaMemcpy(h_P, d_P, size, cudaMemcpyDeviceToHost);

	printf("result: \n");
	for(int i = 0; i < m; i++){
		for(int j = 0; j < n; j++){
			printf("%d  ", h_P[i*n + j]);
		}
		printf("\n");
	}

}