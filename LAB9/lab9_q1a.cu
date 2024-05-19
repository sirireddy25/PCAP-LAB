%%cu
#include<cuda.h>
#include<stdio.h>
#include<stdlib.h>

__global__ void q1a(int *d_A, int *d_B, int m, int n){
	int row = threadIdx.y;
	int col = threadIdx.x;
	int idx = threadIdx.x + blockDim.x*threadIdx.y;

	int sum = 0;
	if(d_A[idx] %2 == 0){
		for(int k = 0; k < n; k++){
			sum += d_A[row*n + k];
		}
	}
	else{
		for(int k = 0; k < n; k++){
			sum += d_A[k * n + col];
		}
	}

	d_B[idx] = sum;
}


int main(){
	int *h_A, *h_B, *d_A, *d_B;
	int m = 2, n = 3;

	int A[] = {1, 2, 3, 4, 5, 6};

	int size = m*n*sizeof(int);

	h_A = (int*)malloc(size);
	h_B = (int*)malloc(size);

	for(int i = 0; i < m*n; i++){
		h_A[i] = A[i];
	}

	cudaMalloc((void**)&d_A, size);
	cudaMalloc((void**)&d_B, size);


	cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);

	dim3 grid(1, 1, 1);
	dim3 block(n, m, 1);

	q1a<<<grid, block>>>(d_A, d_B, m, n);

	cudaMemcpy(h_B, d_B, size, cudaMemcpyDeviceToHost);


	printf("resultant matrix: \n");
	for(int i = 0; i < m; i++){
		for(int j = 0; j < n; j++){
			printf("%d  ", h_B[i*n + j]);
		}
		printf("\n");
	}

}
