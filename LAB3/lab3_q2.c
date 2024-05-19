#include "mpi.h"
#include <stdio.h>

int main(int argc, char *argv[]) {
    int rank, size;
    int data[20], row[10];
    float avg_all[10];
    int m;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;

    if (rank == 0) {
        printf("Enter m: \n");
        scanf("%d", &m);
        printf("Enter %d elements: \n", size * m);
        for(int i = 0; i < size * m; i++){
            scanf("%d", &data[i]);
        }
    }

    MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Scatter(data, m, MPI_INT, row, m, MPI_INT, 0, MPI_COMM_WORLD);

    float avg = 0;
    for (int i = 0; i < m; i++) {
        avg += row[i];
    }
    avg /= m;
    printf("Process %d computed average %f\n", rank, avg); 

    MPI_Gather(&avg, 1, MPI_FLOAT, avg_all, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        float total = 0;
        for (int i = 0; i < size; i++) {
            total += avg_all[i];
        }
        printf("The total average is: %f\n", total / size); 
    }

    MPI_Finalize();
    return 0;
}


//DONT USE 2D ARRAY !! some error occurs while scattering