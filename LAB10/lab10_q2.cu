%%cu

#include<stdio.h>
#include<cuda.h>
#include<stdlib.h>

__glocal__ void q2(int *d_A, int *d_B, int n){
    int row = threadIdx.x;

    int ele;

    for(int i = 0; i < n; i++){
        ele = d_A[row * n + i];
        d_B[row * n + i] = powf(ele, row + 1);
    }

}

int main(){
    int *h_A, *h_B, *d_A, *d_B;

    int m = 3, n = 3;
    int A[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};

    int size = m * n * sizeof(int);

    h_A = (int*)malloc(size);
    h_B = (int*)malloc(size);

    for(int i = 0; i < m*n ; i++){
        h_A[i] = A[i];
    }

    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);

    dim3 grid(1, 1, 1);
    dim3 block(m, 1, 1);
    q2<<<grid, block>>>(d_A, d_B, n);

    cudaMemcpy(h_B, d_B, size, cudaMemcpyDeviceToHost);

    for(int i = 0; i < m; i++){
        for(int j = 0; j < n; j++){
            printf("%d  ", h_B[i * n + j]);
        }
        printf("\n");
    }
}