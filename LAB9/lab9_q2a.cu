%%cu
#include<cuda.h>
#include<stdio.h>
#include<stdlib.h>

__global__ void q2a(int *d_A, int *d_B, int n){
	int row = threadIdx.y;
	int col = threadIdx.x;
	int idx = threadIdx.x + blockDim.x*threadIdx.y;

	int num, fact = 1, sum = 0;

	if(row == col){
		d_B[idx] = 0;
	}
	else if(col > row){
		num = d_A[idx];
		for(int i = 1; i <= num; i++){
			fact = fact * i;
		}
		d_B[idx] = fact;
	}
	else{
		num = d_A[idx];
		while(num != 0){
			sum += num % 10;
			num = num / 10;
		}
		d_B[idx] = sum;
	}
}

int main(){
	int *h_A, *h_B, *d_A, *d_B;

	int n = 3;
	int A[] = {1, 2, 3, 14, 5, 6, 17, 18, 9};

	int size = n * n * sizeof(int);

	h_A = (int*)malloc(size);
	h_B = (int*)malloc(size);

	for(int i = 0; i < n*n; i++){
		h_A[i] = A[i];
	}

	cudaMalloc((void**)&d_A, size);
	cudaMalloc((void**)&d_B, size);

	cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);

	dim3 grid(1, 1, 1);
	dim3 block(3, 3, 1);

	q2a<<<grid, block>>>(d_A, d_B, n);

	cudaMemcpy(h_B, d_B, size, cudaMemcpyDeviceToHost);

	printf("resultant matrix: \n");
	for(int i = 0; i < n; i++){
		for(int j = 0; j < n; j++){
			printf("%d ", h_B[i*n +j]);
		}
		printf("\n");
	}


}