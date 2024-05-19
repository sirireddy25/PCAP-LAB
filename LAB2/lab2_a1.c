#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size;
	int data[10], num, prime;
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Status status;

	if (rank == 0){
		printf("enter %d elements: \n", size);
		for(int i = 0; i < size; i++){
			scanf("%d", &data[i]);
		}
		for(int i = 0; i < size; i++){
			MPI_Send(&data[i], 1, MPI_INT, i, 123, MPI_COMM_WORLD);
		}
	}

	MPI_Recv(&num, 1, MPI_INT, 0, 123, MPI_COMM_WORLD, &status);
	prime = 0;
	for(int i = 2; i <= num/2; i++){
		if(num % i == 0){
			prime = 1;
			break;
		}
	}
	if(prime == 0){
		printf("process %d: %d is prime\n", rank, num);
	}
	else{
		printf("process %d: %d is not prime\n", rank, num);
	}

	MPI_Finalize();
}