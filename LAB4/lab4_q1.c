#include "mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size;
	int sum;

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Status status;

	int n, fact = 1;

	n = rank + 1;
	for(int i = 1; i <= n; i++){
		fact = fact * i;
	}

	MPI_Scan(&fact, &sum, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);

	if(rank == size - 1){
		printf("the sum is %d\n", sum);
	}

	MPI_Finalize();

}