%%cu
//WORD COUNT
#include<cuda.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

__global__ void wordcountkernel(char *d_str, char *d_key, int *d_index, int *d_count){
    int idx = threadIdx.x;
    int start;
    if(idx == 0){
        start = 0;
    }
    else{
        start = d_index[idx] + 1;
    }

    int end = d_index[idx + 1];

    int equal = 1;
    int j = 0;
    for(int i = start; i < end; i++){
        if(d_str[i] != d_key[j]){
            equal = 0;
            break;
        }
        j++;
    }
    if(equal == 1){
        atomicAdd(d_count, 1);
    }
}

int main(){
    char h_str[100], h_key[100];
    char *d_str, *d_key;
    int *d_count, *d_index; 
    int count, index[10];

    strcpy(h_str, "hello world bye world");
    int str_size = sizeof(char)*strlen(h_str);
    strcpy(h_key, "world");
    int key_size = sizeof(char)*strlen(h_key);

    int word_count = 0, k = 0;
    index[k++] = 0;
    for(int i = 0; i < strlen(h_str); i++){
        if(h_str[i] == ' '){
          word_count++;
          index[k++] = i;
        }
    }
    word_count++;
    index[k] = str_size; 

    count = 0;

    cudaMalloc((void**)&d_str, str_size);
    cudaMalloc((void**)&d_key, key_size);
    cudaMalloc((void**)&d_index, (word_count + 1)*sizeof(int));
    cudaMalloc((void**)&d_count, sizeof(int));

    cudaMemcpy(d_str, h_str, str_size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_key, h_key, key_size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_count, &count, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_index, index, (word_count + 1)*sizeof(int), cudaMemcpyHostToDevice);

    wordcountkernel<<<1, word_count>>>(d_str, d_key, d_index, d_count);

    cudaError_t err = cudaGetLastError();

    cudaMemcpy(&count, d_count, sizeof(int), cudaMemcpyDeviceToHost);

    printf("%s occurs %d times.", h_key, count);
}