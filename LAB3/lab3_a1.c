#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size;
	int data[20], row[10], m;
	int final[20];

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	
	if (rank == 0){
		printf("enter m: \n");
		scanf("%d", &m);
		printf("enter %d elements: \n", size*m);
		for(int i = 0; i < size * m; i++){
			scanf("%d", &data[i]);
		}
	}

	MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);
	MPI_Scatter(data, m, MPI_INT, row, m, MPI_INT, 0, MPI_COMM_WORLD);

	int pow = 1 + rank;
	int n;
	for(int i = 0; i < m; i++){
		n = row[i];
		for(int j = 0; j < pow; j++){
			row[i] *= n;
		}
	}

	MPI_Gather(row, m, MPI_INT, final, m, MPI_INT, 0, MPI_COMM_WORLD);

	if(rank == 0){
		printf("the resultant array is: \n");
		for(int i = 0; i < size * m; i++){
			printf("%d  ", final[i]);
		}
		printf("\n");
	}
	
	MPI_Finalize();
}