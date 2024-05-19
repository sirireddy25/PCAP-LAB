__global__ void convolution_1D_basic_kernel(float *N, float *P, int mask_width, int width){
	int i = blockDim.x*blockIdx.x + threadIdx.x;

	__shared__ NS[TW + mask_width - 1];

	int n = mask_width/2;

	halo_index_left = (blockIdx.x - 1)*blockDim.x + threadIdx.x;
	if (threadIdx.x >= blockDim.x - n){
		NS[threadIdx.x - (blockDim.x - n)] = (halo_index_left < 0 ) ? 0 : N[halo_index_left];
	}

	NS[n + threadIdx.x] = N[i];

	int halo_index_right = (blockIdx.x + 1)*blockDim.x + threadIdx.x;
	if (threadIdx.x < n){
		NS[threadIdx.x + blockDim.x + n] = (halo_index_right >= width) ? 0 : N[halo_index_right];
	}

	__syncthreads();

	int pvalue;
	for(int j = 0; j < mask_width; j++){
		pvalue += NS[threadIdx.x + j] * M[j];
	}
	P[i] = pvalue;

}

grid size = width/TW
block size  = TW 