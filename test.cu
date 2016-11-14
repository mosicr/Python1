#define N (2048*2048)
#define THREADS_PER_BLOCK 512

#include <stdio.h>
#include <stdlib.h>

// GPU kernel function to add two vectors
__global__ void add_gpu( int *a, int *b, int *c, int n){
  int index = threadIdx.x + blockIdx.x * blockDim.x;
    if (index < n)
        c[index] = a[index] + b[index];
	}

// CPU function to add two vectors
void add_cpu (int *a, int *b, int *c, int n) {
  for (int i=0; i < n; i++)
      c[i] = a[i] + b[i];
      }

// CPU function to generate a vector of random integers
void random_ints (int *a, int n) {
  for (int i = 0; i < n; i++)
    a[i] = rand() % 10000; // random number between 0 and 9999
    }

// CPU function to compare two vectors
int compare_ints( int *a, int *b, int n ){
  int pass = 0;
    for (int i = 0; i < N; i++){
        if (a[i] != b[i]) {
	      printf("Value mismatch at location %d, values %d and %d\n",i, a[i], b[i]);
	            pass = 1;
		        }
			  }

if (pass == 0) printf ("Test passed\n"); else printf ("Test Failed\n");
			      return pass;
			      }


int main( void ) {

    int *a, *b, *c; // host copies of a, b, c
    int *dev_a, *dev_b, *dev_c; // device copies of a, b, c
    int size = N * sizeof( int ); // we need space for N integers
//    printf("N = %d\n", N);
  // Allocate GPU/device copies of dev_a, dev_b, dev_c
    cudaMalloc( (void**)&dev_a, size );
    cudaMalloc( (void**)&dev_b, size );
    cudaMalloc( (void**)&dev_c, size );

  // Allocate CPU/host copies of a, b, c
    a = (int*)malloc( size );
    b = (int*)malloc( size );
    c = (int*)malloc( size );

  // Fill input vectors with random integer numbers
    random_ints( a, N );
    random_ints( b, N );
/*    printf("a = %d\n", a[2048]);
      printf("a = %d\n", a[2]);
      printf("b = %d\n", b[1]);
      printf("b = %d\n", b[2]);
*/
// copy inputs to device
    cudaMemcpy( dev_a, a, size, cudaMemcpyHostToDevice );
    cudaMemcpy( dev_b, b, size, cudaMemcpyHostToDevice );

  // launch add_gpu() kernel with blocks and threads
    add_gpu<<< N/THREADS_PER_BLOCK, THREADS_PER_BLOCK >>>( dev_a, dev_b, dev_c, N );

  // copy device result back to host copy of c
    cudaMemcpy( c, dev_c, size, cudaMemcpyDeviceToHost );
    printf("c_gpu %d\n", *c);
  //Check the results with CPU implementation
    int *c_h; c_h = (int*)malloc( size );
      add_cpu (a, b, c_h, N);
    printf("c_host %d\n", *c_h);
      
        compare_ints(c, c_h, N);

  // Clean CPU memory allocations
    free( a ); free( b ); free( c ); free (c_h);

  // Clean GPU memory allocations
    cudaFree( dev_a );
      cudaFree( dev_b );
        cudaFree( dev_c );

  return 0;
  }