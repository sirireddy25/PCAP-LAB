#include"mpi.h"
#include<stdio.h>

int main(int argc, char*argv[]){
	int rank, size;
	int data[10], fact_all[10];
	int  n,  fact;
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Status status;

	if(rank == 0){
		printf("enter %d values: \n", size);
		for(int i = 0; i < size; i++){
			scanf("%d", &data[i]);
		}
	}

	MPI_Scatter(data, 1, MPI_INT, &n, 1, MPI_INT, 0, MPI_COMM_WORLD);
	fact = 1;	
	for(int i = 1; i <= n; i++){
		fact = fact * i;
	}
	printf("process %d computed factorial %d\n", rank, fact);
	MPI_Gather(&fact, 1, MPI_INT, fact_all, 1, MPI_INT, 0, MPI_COMM_WORLD);

	if (rank == 0){
		int sum = 0;
		for(int i = 0; i < size; i++){
			sum += fact_all[i];
		}
		printf("the sum is: %d\n", sum);
	}

	MPI_Finalize();
}