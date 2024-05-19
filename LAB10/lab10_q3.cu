%%cu 
#include<cuda.h>
#include<stdio.h>
#include<stdlib.h>


__global__ void q3(int *d_A, int *d_B, int m, int n){
	int row = threadIdx.y;
	int col = threadIdx.x;
	int idx = threadIdx.x + blockDim.x*threadIdx.y;

	if(row == 0|| col == 0 || row == m - 1 || col == n - 1){
		d_B[idx] = d_A[idx];
	}
	else{
		int num = d_A[idx];
		int i = 0, rem = 0, pow = 1;
		while(num != 0){
			rem += !(num % 2) * pow;
			num = num / 2;
			pow = pow * 10;
		}
		d_B[idx] = rem;
	}
}


int main(){
	int *h_A, *h_B, *d_A, *d_B;

	int m = 4, n = 4;

	int A[] = {1, 2, 3, 4, 6, 5, 8, 3, 2, 4, 10, 1, 9, 1, 2, 5};

	int size = m * n * sizeof(int);

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

	q3<<<grid, block>>>(d_A, d_B, m, n);

	cudaMemcpy(h_B, d_B, size, cudaMemcpyDeviceToHost);

	printf("resultant matrix: \n");
	for(int i = 0; i < m; i++){
		for(int j = 0; j < n; j++){
			printf("%d ", h_B[i*n +j]);
		}
		printf("\n");
	}
}
