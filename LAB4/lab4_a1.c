#include"mpi.h"
#include<stdio.h>
#include<string.h>

int main(int argc, char *argv[]){
	int rank, size;
	int repeat = 0;
	char input[10], a,str[10], output[30];
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);

	if(rank == 0){
		strcpy(input, "PCAP");
	}

	MPI_Scatter(input, 1, MPI_CHAR, &a, 1, MPI_CHAR, 0, MPI_COMM_WORLD);

	for(int i = 0; i <= rank; i++){
		str[i] += a;
	}
	for(int j = rank+1; j < size;j++){
		str[j] = '\0';
	}

	printf("process %d: %s\n", rank, str);

	
	MPI_Gather(str, size, MPI_CHAR, output, size, MPI_CHAR, 0, MPI_COMM_WORLD);

	if(rank == 0){
		for(int i = 0; i < size; i++){
      		for(int j = 0; j <= i;j++){
        		printf("%c",output[i*size + j]);
      		}
    	}
    	printf("\n");
	}

	MPI_Finalize();

}

