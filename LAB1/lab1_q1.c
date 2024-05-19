#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size, ans = 1;
	int x = 2;
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	for(int i = 1; i <= rank; i++)
		ans = ans*x;
	printf("pow(%d, %d): %d\n", x, rank, ans);
	MPI_Finalize();
	return 0;
}