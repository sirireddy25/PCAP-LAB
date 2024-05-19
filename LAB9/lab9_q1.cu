#include"cuda_runtime.h"
#include"device_launch_parameters.h"
#include<stdio.h>
#include<stdlib.h>

__global__ void row(int *A, int *B, int *C, int ha, int wa, int hb, int wb){
	int r = threadIdx.x;
	for(int c = 0; c < wb; c++){
		int sum = 0;
		for(int k = 0; k < wa; k++){
			sum += A[r * wa + k] * B[k * wb + c];
		}
		C[r * wb + c] = sum;
	}
}

__global__ void col(int *A, int *B, int *C, int ha, int wa, int hb, int wb){
	int c = threadIdx.x;
	for(int r = 0; r < ha; r++){
		int sum = 0;
		for(int k = 0; k < wa; k++){
			sum += A[r * wa + k] * B[k * wb + c];
		}
		C[r * wb + c] = sum;
	}
}

__global__ void ele(int *A, int *B, int *C, int ha, int wa, int hb, int wb){
	int r = threadIdx.y;
	int c = threadIdx.x;
	int sum = 0;
	for(int k = 0; k < wa; k++){
		sum += A[r * wa + k] * B[k * wb + c];
	}
	C[r * wb + c] = sum;
}

int main(){
	int *A, *B, *C;
	int *dA, *dB, *dC;
	int ha, wa, hb, wb;
	printf("enter dimensions of matrix A: \n");
	scanf("%d %d", &ha, &wa);
	printf("enter dimensions of matrix B: \n");
	scanf("%d %d", &hb, &wb);

	if(wa != hb){
		printf("invalid dimensions!\n");
		exit(1);
	}

	int sizeA, sizeB, sizeC;

	sizeA = ha*wa*sizeof(int);
	sizeB = hb*wb*sizeof(int);
	sizeC = ha*wb*sizeof(int);

	A = (int*)malloc(sizeA);
    B = (int*)malloc(sizeB);
    C = (int*)malloc(sizeC);

    printf("enter elements of matrix A:\n");
    for(int i = 0; i < ha; i++){
    	for(int j = 0; j < wa; j++){
    		scanf("%d", &A[i*wa + j]);
    	}
    }

    printf("enter elements of matrix B:\n");
    for(int i = 0; i < hb; i++){
    	for(int j = 0; j < wb; j++){
    		scanf("%d", &B[i*wb + j]);
    	}
    }


    cudaMalloc((void**)&dA, sizeA);
    cudaMalloc((void**)&dB, sizeB);
    cudaMalloc((void**)&dC, sizeC);
    cudaMemcpy(dA, A, sizeA, cudaMemcpyHostToDevice);
    cudaMemcpy(dB, B, sizeB, cudaMemcpyHostToDevice);

    row<<<1, ha>>>(dA, dB, dC, ha, wa, hb, wb);
    cudaMemcpy(C, dC, sizeC, cudaMemcpyDeviceToHost);

    printf("\neach row computed by one thread: \n");
    for(int i = 0; i < ha; i++){
    	for(int j = 0; j < wb; j++){
    		printf("%d ", C[i*wb + j]);
    	}
    	printf("\n");
    }


    col<<<1, wb>>>(dA, dB, dC, ha, wa, hb, wb);
    cudaMemcpy(C, dC, sizeC, cudaMemcpyDeviceToHost);

    printf("\neach column computed by one thread: \n");
    for(int i = 0; i < ha; i++){
    	for(int j = 0; j < wb; j++){
    		printf("%d ", C[i*wb + j]);
    	}
    	printf("\n");
    }

    dim3 grid(1, 1, 1);
    dim3 block(wb, ha, 1);
    ele<<<grid, block>>>(dA, dB, dC, ha, wa, hb, wb);
    cudaMemcpy(C, dC, sizeC, cudaMemcpyDeviceToHost);

    printf("\neach element computed by one thread: \n");
    for(int i = 0; i < ha; i++){
    	for(int j = 0; j < wb; j++){
    		printf("%d ", C[i*wb + j]);
    	}
    	printf("\n");
    }

    cudaFree(dA);
    cudaFree(dB);
    cudaFree(dC);
    return 0;

}