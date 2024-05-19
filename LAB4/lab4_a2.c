#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size;
	int A[5][5],  row[5], col[5], max_col[5], min_col[5], B[25];

	
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);


	if(rank == 0){
		printf("enter 5x5 matrix: \n");
		for(int i = 0; i < 5; i++){
			for(int j = 0; j < 5; j++){
				scanf("%d", &A[i][j]);
			}
		}
		printf("\n");
	}

	MPI_Scatter(A, 5, MPI_INT, row, 5, MPI_INT, 0, MPI_COMM_WORLD);

	MPI_Allreduce(row, max_col, 5, MPI_INT, MPI_MAX, MPI_COMM_WORLD);
	MPI_Allreduce(row, min_col, 5, MPI_INT, MPI_MIN, MPI_COMM_WORLD);

	for(int i = 0; i < 5; i++){
		if(i < rank){
			row[i] = max_col[rank];
		}
		else if(rank == i){
			row[i] = 0;
		}
		else if(i > rank){
			row[i] = min_col[rank];
		}

	}

	MPI_Gather(row, 5, MPI_INT, B, 5, MPI_INT, 0, MPI_COMM_WORLD);

	if(rank == 0){
		for(int i = 0; i < 5; i++){
			for(int j = 0; j < 5; j++){
				printf("%d ", B[j + i*5]);
			}
			printf("\n");
		}
	}

	MPI_Finalize();

}