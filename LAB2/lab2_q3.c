#include"mpi.h"
#include<stdio.h>
#include<stdlib.h>

int main(int argc, char *argv[]){
	int rank, size;
	int buffer_size, *buffer, data[10], num;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Status status;

	if(rank == 0){
		buffer_size = MPI_BSEND_OVERHEAD + sizeof(int);
		buffer = malloc(buffer_size);
		printf("enter %d elements: \n", size-1);
		for(int i = 0; i < size-1; i++){
			scanf("%d", &data[i]);
		}
		int j = 0;
		for(int i = 1; i < size; i++){
			MPI_Buffer_attach(buffer, buffer_size);
			MPI_Bsend(&data[j], 1, MPI_INT, i, 123, MPI_COMM_WORLD);
			MPI_Buffer_detach(buffer, &buffer_size);
			j++;
		}

	}
	else{
		int res;
		MPI_Recv(&num, 1, MPI_INT, 0, 123, MPI_COMM_WORLD, &status);
		if(rank % 2 == 0){
			num = num * num;
		}
		else{
			num = num * num * num;
		}
		printf("process %d computed %d\n", rank, num);
	}
	MPI_Finalize();
}