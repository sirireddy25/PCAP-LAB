#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size;
	int mat[4][4], fmat[4][4], row[4],  row1[4];

	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	if(rank == 0){
		printf("enter elements for 4x4 matrix: \n");
		for(int i = 0 ; i < 4; i++){
			for(int j = 0; j < 4; j++){
				scanf("%d", &mat[i][j]);
			}
		}
	}

	MPI_Scatter(mat, 4, MPI_INT, row, 4, MPI_INT, 0, MPI_COMM_WORLD);
	MPI_Scan(row, row1, 4, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
	MPI_Gather(row1, 4, MPI_INT, fmat, 4, MPI_INT, 0, MPI_COMM_WORLD);

	if(rank == 0){
		for(int i = 0 ; i < 4; i++){
			for(int j = 0; j < 4; j++){
				printf("%d ", fmat[i][j]);
			}
			printf("\n");
		}
		printf("\n");
	}

	MPI_Finalize();
}