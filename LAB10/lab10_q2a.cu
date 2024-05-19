%%cu
#include<cuda.h>
#include<stdio.h>
#include<stdlib.h>

__global__ void q2a(char *d_A, int *d_B, char *d_C, int m, int n){
	int idx = threadIdx.x + blockDim.x * threadIdx.y;
	int offset = 0;

	for(int i = 0; i < idx; i++){
		offset += d_B[i];
	}

	int repeat = d_B[idx];

	for(int i  = 0; i < repeat; i++){
		d_C[offset++] = d_A[idx];
	}
}

int main(){
	char *h_A, *h_C, *d_A, *d_C;
	int *h_B, *d_B;

	int m = 2, n = 4;

	int sizeA = m * n * sizeof(char);
	int sizeB = m * n * sizeof(int);

	h_A = (char*)malloc(sizeA);
	h_B = (int*)malloc(sizeB);

	char A[] = {'p', 'C', 'a', 'P', 'e', 'X', 'a', 'M'};
	int B[] = {1, 2, 4, 3, 2, 4, 3, 2};
	int sum = 0;

	for(int i = 0; i < m*n; i++) {
        h_A[i] = A[i];
        h_B[i] = B[i];
        sum += B[i];
    }

    int sizeC = sizeof(char)*sum;
	h_C = (char*)malloc(sizeC);

    cudaMalloc((void**)&d_A, sizeA);
    cudaMalloc((void**)&d_B, sizeB);
    cudaMalloc((void**)&d_C, sizeC);

    cudaMemcpy(d_A, h_A, sizeA, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, sizeB, cudaMemcpyHostToDevice);

    dim3 grid(1, 1, 1);
    dim3 block(n, m, 1);

    q2a<<<grid, block>>>(d_A, d_B, d_C, m, n);

    cudaMemcpy(h_C, d_C, sizeC, cudaMemcpyDeviceToHost);

    printf("resultant string: %s", h_C);

    free(h_A);
    free(h_B);
    free(h_C);
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}