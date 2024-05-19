#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int size, rank;
	int mat[3][3], row[3];
	int ele, occurences = 0, total;

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);

	if(rank == 0){
		printf("enter elements for 3x3 matrix: \n");
		for(int i = 0; i < 3; i++){
			for(int j = 0; j < 3; j++){
				scanf("%d", &mat[i][j]);
			}
		}
		printf("enter element to search for: \n");
		scanf("%d", &ele);
	}

	MPI_Bcast(&ele, 1, MPI_INT, 0, MPI_COMM_WORLD);
	MPI_Scatter(mat, 3, MPI_INT, row, 3, MPI_INT, 0, MPI_COMM_WORLD);

	for(int i = 0; i < 3; i ++){
		if(row[i] == ele)
			occurences++;
	}
	printf("no. of occurences found by process %d: %d\n", rank, occurences);
	MPI_Reduce(&occurences, &total, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

	if(rank == 0){
		printf("total number of occurences: %d\n", total);
	}

	MPI_Finalize();
}