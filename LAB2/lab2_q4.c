#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size;
	int n1, n2;

	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Status status;

	if (rank == 0){
		printf("enter a number: \n");
		scanf("%d", &n1);

		MPI_Send(&n1, 1, MPI_INT, (rank + 1)%size, rank, MPI_COMM_WORLD);
		MPI_Recv(&n1, 1, MPI_INT, size - 1, size - 1, MPI_COMM_WORLD, &status);
		printf("process %d num = %d\n", rank, n1);
	}
	else{
		MPI_Recv(&n2, 1, MPI_INT, rank - 1, rank -1, MPI_COMM_WORLD,  &status);
		n2 += 1;
		printf("process %d num = %d\n", rank, n2);
		MPI_Send(&n2, 1, MPI_INT, (rank + 1)%size, rank, MPI_COMM_WORLD);
	}
	MPI_Finalize();
}