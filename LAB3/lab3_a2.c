#include"mpi.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	int rank, size;
	int A[20], A1[20];
	int m, n, odd = 0, even = 0;
	int final[20], even_count[10], odd_count[10];
	
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	
	if(rank == 0){
		printf("enter length of array: \n");
		scanf("%d", &n);
		printf("enter elements: \n");
		for(int i = 0; i < n; i++){
			scanf("%d", &A[i]);
		}
		m =  n/size;
	}
	MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);
	MPI_Scatter(A, m, MPI_INT, A1, m, MPI_INT, 0, MPI_COMM_WORLD);

	for(int i = 0; i < m; i++){
		if(A1[i] % 2 == 0){
			A1[i] = 1;
			even++;
		}
		else{
			A1[i] = 0;
			odd++;
		}
	}

	MPI_Gather(A1, m, MPI_INT, final, m, MPI_INT, 0, MPI_COMM_WORLD);
	MPI_Gather(&even, 1, MPI_INT, even_count, 1, MPI_INT, 0, MPI_COMM_WORLD);
	MPI_Gather(&odd, 1, MPI_INT, odd_count, 1, MPI_INT, 0, MPI_COMM_WORLD);

	if(rank == 0){
		printf("result: \n");
		for(int i = 0; i < n; i++){
			printf("%d ", final[i]);
		}
		printf("\n");
		int c1 = 0, c2 = 0;
		for(int i = 0; i < size; i++){
			c1 += even_count[i];
		}
		for(int i = 0; i < size; i++){
			c2 += odd_count[i];
		}
		printf("\nno. of even numbers: %d\n", c1);
		printf("no. of odd numbers: %d\n", c2);
	}


	MPI_Finalize();
}