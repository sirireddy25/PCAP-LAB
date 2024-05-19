#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size, a;
	int input[10] = {18, 523, 301, 1234, 2, 14, 108, 150, 1928};
	int output[10];
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	
	a = input[rank];
	int reverse = 0;
	while(a > 0){
		reverse = reverse * 10 + a % 10 ;
		a = a / 10;
	}
	output[rank] = reverse;
	printf("rank: %d reversed value: %d\n",rank, output[rank]);
	MPI_Finalize();
}