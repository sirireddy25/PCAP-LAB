#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size;
	int a = 6, b = 2, result = 0;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	if(rank % 4 == 0){
		result = a + b;
		printf("process %d computed result: %d\n", rank, result);
	}
	else if(rank %4 == 1){
		result = a - b;
		printf("process %d computed result: %d\n", rank, result);
	}
	else if(rank %4 == 2){
		result = a * b;
		printf("process %d computed result: %d\n", rank, result);
	}
	else if(rank %4 == 3){
		result = a / b;
		printf("process %d computed result: %d\n", rank, result);
	}
	MPI_Finalize();
}