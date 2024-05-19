%%cu
//ADDING VECTORS
#include <stdio.h>
#include <cuda.h>

__global__ void vector_add(int *d_A, int *d_B, int *d_sum){
    int idx = threadIdx.x;
    d_sum[idx] = d_A[idx] + d_B[idx];
 }

int main(){
    int *h_A, *h_B, *d_B, *d_A, *h_sum, *d_sum;
    int n = 5;
    int size = sizeof(int)*n;
    h_A = (int*)malloc(size);
    h_B = (int*)malloc(size);
    h_sum = (int*)malloc(size);
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_sum, size);

    int A[] = {1, 2, 3, 4, 5};
    int B[] = {1, 2, 3, 4, 5};
    for(int i = 0; i < 5; i++){
        h_A[i] = A[i];
        h_B[i] = B[i];
    }

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    vector_add<<<1, n>>>(d_A, d_B, d_sum);

    cudaMemcpy(h_sum, d_sum, size, cudaMemcpyDeviceToHost);

    printf("sum :\n");
    for(int i = 0; i < 5; i++){
        printf("%d  ", h_sum[i]);
    }

}
