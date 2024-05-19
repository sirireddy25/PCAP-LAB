#include"mpi.h"
#include<stdio.h>
#include<string.h>

/*
int main(int argc, char *argv[]){
	int rank, size;
	char str1[10] , str2[10], s[10], final[20];
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Barrier(MPI_COMM_WORLD);
	double start = MPI_Wtime();
	if(rank == 0){
		strcpy(str1, "string");
		strcpy(str2, "length");
	}

	MPI_Scatter(str1, 1, MPI_CHAR, s, 1, MPI_CHAR, 0, MPI_COMM_WORLD);
	MPI_Scatter(str2, 1, MPI_CHAR, &s[1], 1, MPI_CHAR, 0, MPI_COMM_WORLD);
	MPI_Gather(s, 2, MPI_CHAR, final, 2, MPI_CHAR, 0, MPI_COMM_WORLD);
	double end = MPI_Wtime();
	if(rank == 0){
		final[12] = '\0';
		printf("the resultant string is: %s\n", final);
		printf("time taken: %lf\n", end-start);
	}
	MPI_Finalize();
}
*/

//SEE HOW TO USE MPI_Wtime() AND MPI_Barrier() !!!


int main(int argc, char *argv[]){
	int rank, size;
	int m, n;
	char str1[10] , str2[10], s[10], final[20];
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	
	if(rank == 0){
		strcpy(str1, "string");
		strcpy(str2, "length");
		n = strlen(str1);
		m = n/size;
	}

	MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);
	int k = 0, j = 0;
	for(int i = 1; i <= m; i++){
		MPI_Scatter(&str1[j], 1, MPI_CHAR, s, 1, MPI_CHAR, 0, MPI_COMM_WORLD);
		MPI_Scatter(&str2[j], 1, MPI_CHAR, &s[1], 1, MPI_CHAR, 0, MPI_COMM_WORLD);
		MPI_Gather(s, size*2 , MPI_CHAR, &final[size*i], size*2, MPI_CHAR, 0, MPI_COMM_WORLD);
		j += size;
	}

	if(rank == 0){
		final[12] = '\0';
		printf("the resultant string is: %s\n", final);
	}
	MPI_Finalize();
}

