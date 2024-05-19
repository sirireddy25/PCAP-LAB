//sparse matrix
%%cu
#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

__global__ void sparse(int num_rows, int* data, int* col_index, int* row_ptr, int* x, int* y) {
    int row = blockIdx.x * blockDim.x + threadIdx.x;
    if (row < num_rows) {
        int product = 0;
        int start = row_ptr[row];
        int stop = row_ptr[row + 1];
        for (int k = start; k < stop; k++) {
            product += data[k] * x[col_index[k]];
        }
        y[row] = product;
    }
}

int main() {
    int n = 4, m = 4;
    int* h_matrix = (int*)malloc(n * m * sizeof(int));
    int* h_x = (int*)malloc(m * sizeof(int));
    int non_zero_count = 0;
    int init_h_matrix[] = {3, 0, 0, 1, 0, 0, 0, 0, 0, 2, 4, 1, 1, 0, 0, 1};
    for (int i = 0; i < n * m; i++) {
        h_matrix[i] = init_h_matrix[i];
        non_zero_count += (h_matrix[i] != 0);
    }

    int init_h_x[] = {1, 2, 1, 2};
    for (int i = 0; i < m; i++) {
        h_x[i] = init_h_x[i];
    }

    int* h_data = (int*)malloc(non_zero_count * sizeof(int));
    int* h_col_index = (int*)malloc(non_zero_count * sizeof(int));
    int* h_row_ptr = (int*)calloc(n + 1, sizeof(int));
    int* h_y = (int*)calloc(n, sizeof(int));

    int k = 0, b = 0;
    for(int i = 0; i < n; i++){
        h_row_ptr[b++] = k;
        for(int j = 0; j < m; j++){
            if(h_matrix[i*m + j] != 0){
                h_col_index[k] = j;
                h_data[k] = h_matrix[i*m + j];
                k++;
            }
        }
    }
    h_row_ptr[b] = non_zero_count;

    int *d_data, *d_col_index, *d_row_ptr, *d_x, *d_y;
    cudaMalloc((void**)&d_data, non_zero_count * sizeof(int));
    cudaMalloc((void**)&d_col_index, non_zero_count * sizeof(int));
    cudaMalloc((void**)&d_row_ptr, (n + 1) * sizeof(int));
    cudaMalloc((void**)&d_x, m * sizeof(int));
    cudaMalloc((void**)&d_y, n * sizeof(int));
    
    cudaMemcpy(d_data, h_data, non_zero_count * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_col_index, h_col_index, non_zero_count * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_row_ptr, h_row_ptr, (n + 1) * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_x, h_x, m * sizeof(int), cudaMemcpyHostToDevice);

    sparse<<<1, n>>>(n, d_data, d_col_index, d_row_ptr, d_x, d_y);
    cudaMemcpy(h_y, d_y, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Y:");
    for (int i = 0; i < n; i++) {
        printf(" %d", h_y[i]);
    }
    printf("\n");
}

