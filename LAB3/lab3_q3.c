#include "mpi.h"
#include<stdio.h>
#include<string.h>

int main(int argc, char *argv[]){
	int rank, size;
	char str[100], str1[100];
	int count[10];
	int len, non_vowels = 0, vowels = 0;
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);

	if(rank == 0){
		printf("enter a string: \n");
		scanf("%s", str);
		len = strlen(str)/size;
	}
	MPI_Bcast(&len, 1, MPI_INT, 0, MPI_COMM_WORLD);
	MPI_Scatter(str, len, MPI_CHAR, str1, len, MPI_CHAR, 0, MPI_COMM_WORLD);

	for(int i = 0; i < len; i++){
		if(str1[i] == 'a'|| str1[i] == 'e'|| str1[i] == 'i'|| str1[i] == 'o'|| str1[i] == 'u')
			vowels++;
	}
	non_vowels = len - vowels;
	printf("process %d found %d non-vowels\n", rank, non_vowels);
	MPI_Gather(&non_vowels, 1, MPI_INT, count, 1, MPI_INT, 0, MPI_COMM_WORLD);

	if(rank == 0){
		int total = 0;
		for(int i = 0; i < size; i++){
			total += count[i];
		}
		printf("total no. of non-vowels: %d\n", total);
	}
	MPI_Finalize();
}