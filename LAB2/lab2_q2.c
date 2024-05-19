#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int size, rank;
	int n1, n2;
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Status status;

	if(rank == 0){
		printf("enter a number: \n");
		scanf("%d", &n1);
		for(int i = 0; i < size; i++){
			MPI_Send(&n1, 1, MPI_INT, i, 123, MPI_COMM_WORLD);
		}
	}
	else{
		MPI_Recv(&n2, 1, MPI_INT, 0, 123, MPI_COMM_WORLD, &status);
		printf("process %d: %d\n", rank, n2);
	}
	MPI_Finalize();
}