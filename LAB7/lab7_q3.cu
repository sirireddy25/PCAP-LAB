%%cu
//1D convolution
#include<cuda.h>
#include<stdio.h>

__global__ void conv(int *d_arr, int *d_mask, int *d_out, int width, int mask_width){
    int idx = threadIdx.x;
    int start_point = idx - (mask_width/2);
    int output = 0;
    for(int i = 0; i < mask_width; i++){
        if(start_point + i >= 0 && start_point + i < width){
            output = output + d_arr[start_point + i] * d_mask[i];
        }
    }
    d_out[idx] = output;
}

int main(){
    int *h_arr, *h_mask, *h_out, *d_out, *d_arr, *d_mask;
    
    int width = 6;
    int mask_width = 3;

    int arr_size = sizeof(int)*width;
    int mask_size = sizeof(int)*mask_width;

    h_arr = (int*)malloc(arr_size);
    h_out = (int*)malloc(arr_size);
    h_mask = (int*)malloc(mask_size);
    
    int mask[] = {1, 2, 1};
    int arr[] = {1, 2, 3, 4, 5, 6};

    for(int i = 0; i < width; i++){
        h_arr[i] = arr[i];
    }

    for(int i = 0; i < mask_width; i++){
        h_mask[i] = mask[i];
    }

    cudaMalloc((void**)&d_arr, arr_size);
    cudaMalloc((void**)&d_out, arr_size);
    cudaMalloc((void**)&d_mask, mask_size);
    cudaMemcpy(d_arr, h_arr, arr_size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_mask, h_mask, mask_size, cudaMemcpyHostToDevice);

    conv<<<1, width>>>(d_arr, d_mask, d_out, width, mask_width);

    cudaMemcpy(h_out, d_out, arr_size, cudaMemcpyDeviceToHost);

    printf("resultant array: ");
    for(int i = 0; i < width; i++){
        printf("%d ", h_out[i]);
    }
}