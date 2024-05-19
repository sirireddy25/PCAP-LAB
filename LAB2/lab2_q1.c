#include"mpi.h"
#include<stdio.h>
#include<string.h>

int main(int argc, char *argv[]){
	int rank, size;
	char str[100], toggle[100];
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Status status;
	if(rank == 0){
		printf("enter a string: \n");
		scanf("%s", str);
		MPI_Ssend(str, 20, MPI_CHAR, 1, 123, MPI_COMM_WORLD);
		MPI_Recv(str, 20, MPI_CHAR, 1, 124, MPI_COMM_WORLD, &status);
		printf("the toggled string is: %s\n", str);
	}
	else{
		MPI_Recv(toggle, 20, MPI_CHAR, 0, 123, MPI_COMM_WORLD, &status);
		for(int i = 0; i < strlen(toggle); i++){
			if(toggle[i] >= 'A' && toggle[i] <= 'Z'){
				toggle[i] = toggle[i] + 32;
			}
			else if(toggle[i] >= 'a' && toggle[i] <= 'z'){
				toggle[i] = toggle[i] - 32;
			}
		}
		MPI_Ssend(toggle, 20, MPI_CHAR, 0, 124, MPI_COMM_WORLD);
	}
	MPI_Finalize();

}