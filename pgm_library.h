#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include <string.h>

// Estructura que contiene datos de la imagen
typedef struct image{
	char *data;
	int cols;
	int rows;
	int depth;
} image;

int read_pgm(char *input_name, image *img);
int write_pgm(char *output_name, image *img);
