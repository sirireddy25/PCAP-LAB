#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	if(rank % 2 == 0){
		printf("hello from process %d\n", rank);
	}
	else{
		printf("world from process %d\n", rank);
	}
	MPI_Finalize();
}