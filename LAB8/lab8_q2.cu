%%cu
//S = PCAP RS = PCAPPCAPCP
#include<cuda.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

__global__ void repeat(char *d_S, char *d_RS, int *d_index, int S_len){
    int idx = threadIdx.x;
    int r = S_len - idx;
    int start = d_index[idx];
    for(int i = 0; i < r; i++){
      d_RS[start++] = d_S[i];
    }
}

int main(){
    char h_S[5], h_RS[20];
    char *d_S, *d_RS;
    int S_len, RS_len, S_size, RS_size ;

    strcpy(h_S, "PCAP");
    S_len = strlen(h_S);
    int index[S_len], *d_index;

    RS_len = 0;
    int j = 0;
    for(int i = S_len; i >=0; i--){
        index[j++] = RS_len;
        RS_len += i;
    }

    S_size = S_len*sizeof(char);
    RS_size = RS_len*sizeof(char);

    cudaMalloc((void**)&d_S, S_size);
    cudaMalloc((void**)&d_RS, RS_size);
    cudaMalloc((void**)&d_index, S_len*sizeof(int));

    cudaMemcpy(d_S, h_S, S_size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_index, index, S_len*sizeof(int), cudaMemcpyHostToDevice);

    repeat<<<1, S_len>>>(d_S, d_RS, d_index, S_len);
    cudaError_t err = cudaGetLastError();

    printf("resultant string: ");
    for(int i = 0; i < RS_len; i++){
        printf("%c", h_RS[i]);
    }

}