#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size;
	int start, end, prime;
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	if (rank == 0){
		start = 2;
		end = 50;
	}
	else{
		start = 51;
		end = 100;
	}

	for(int i = start; i < end; i++){
		prime = 0;
		for(int j = 2; j <= i/2; j++){
			if(i % j == 0){
				prime = 1;
				break;
			}
		}
		if(prime == 0){
			printf("process %d foung prime no. %d\n", rank, i);
		}
	}
	MPI_Finalize();
}