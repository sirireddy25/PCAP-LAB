//Write a CUDA program to perform matrix multiplication using 2D grid and 2D block
#include<stdio.h>
#include<cuda.h>
#include<math.h>

_global_ void q1(int *d_A, int *d_B, int *d_C, int ha, int wa, int hb, int wb){
    int r = blockIdx.y*blockDim.y + threadIdx.y;
    int c = blockIdx.x*blockDim.x + threadIdx.x;
    int sum = 0;

    if( r < ha && c < wb){
        for(int k = 0; k < wa; k++){
            sum += d_A[r*wa + k] * d_B[k*wb + c];
        }
        d_C[r*wb + c] = sum;
    }
}

int main(){
    int *h_A, *h_B, *d_A, *d_B, *h_C, *d_C;
    int ha, wa, hb, wb;
    int sizeA, sizeB, sizeC;

    printf("enter dimensions of matrix A: \n");
    scanf("%d %d", &ha, &wa);

    printf("enter dimensions of matrix B: \n");
    scanf("%d %d", &hb, &wb);


    sizeA = ha*wa*sizeof(int);
    sizeB = hb*wb*sizeof(int);
    sizeC = ha*wb*sizeof(int);

    h_A = (int*)malloc(sizeA);
    h_B = (int*)malloc(sizeB);
    h_C = (int*)malloc(sizeC);

    cudaMalloc((void**)&d_A, sizeA);    
    cudaMalloc((void**)&d_B, sizeB);
    cudaMalloc((void**)&d_C, sizeC);

    printf("enter elements of matrix A: \n");
    for(int i = 0; i < ha; i++){
        for(int j = 0; j < wa; j++){
            scanf("%d", &h_A[i*wa + j]);
        }
    }

    printf("enter elements of matrix B: \n");
    for(int i = 0; i < hb; i++){
        for(int j = 0; j < wb; j++){
            scanf("%d", &h_B[i*wb + j]);
        }
    }

    cudaMemcpy(d_A, h_A, sizeA, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, sizeB, cudaMemcpyHostToDevice);

    dim3 block(16, 16, 1);
    dim3 grid(ceil(wb/2.0), ceil(ha/2.0), 1);
    q1<<<grid, block>>>(d_A, d_B, d_C, ha, wa, hb, wb);

    cudaMemcpy(h_C, d_C, sizeC, cudaMemcpyDeviceToHost);

    printf("result: \n");
    for(int i = 0; i < ha; i++){
        for(int j = 0; j < wb; j++){
            printf("%d  ", h_C[i*wb +j]);
        }
        printf("\n");
    }

}