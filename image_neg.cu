#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <malloc.h>
#include"pgm_library.h"

// Funcion ejecutada en la GPU
__global__ void negativo(char *input_image, char *output_image, int nRows, int nCols){

	int r = blockDim.x*blockIdx.x + threadIdx.x;
	int i;

	// Each thread compute a row
	
	if (r < nRows){
	  for (i = 0; i < nCols; i++){
		  output_image[nCols*r + i] = 255 - input_image[nCols*r + i];
	  }
	}

}


// Main function
int main(int argc, char **argv){

  if (argc != 3){
    printf("\nUse: ./image_neg <input_file>.pgm <output_file>.pgm\n\n");
    exit(0);
  }


	image lena;

	// Reading image
	read_pgm(argv[1], &lena);

	char *pt = lena.data;
	int ndata = lena.rows*lena.cols;

/*
	//	Secuential programming
  int i;
	for (i = 0; i < lena.rows*lena.cols; i++){
		pt[i] = 255 - pt[i];
	}
*/

	// Parallel programming

	char *device_input_image = NULL;
	char *device_output_image = NULL;
	cudaMalloc((void **) &device_input_image , ndata*sizeof(char));
	cudaMalloc((void **) &device_output_image , ndata*sizeof(char));

	cudaMemcpy(device_input_image, pt, ndata*sizeof(char), cudaMemcpyHostToDevice);

	// Calling device function (using max 512 threads per block)
	int nBlocks = ceil(lena.rows/512.0);
	int nThreads = 512;
	
  negativo<<<nBlocks, nThreads>>>(device_input_image, device_output_image, lena.rows, lena.cols);

	cudaMemcpy(pt, device_output_image, ndata*sizeof(char), cudaMemcpyDeviceToHost);

	// Saving image
	write_pgm(argv[2], &lena);

	return 0;

}


