
#include"pgm_library.h"

int read_pgm(char *input_name, image *img){

	FILE *input_fd = fopen(input_name, "r+");

	if(input_fd == NULL) {
		printf("Error al abrir el archivo : %s\n", input_name);
		exit(1);
	}

  char mark[10];
  char comment[256];
  char raw_row[50];

  fscanf(input_fd, "%s\n", mark);

  // 'P5' denote pgm image
	if (strncmp(mark, "P5", 2) != 0){
		printf("El archivo no es PGM\n");
		exit(1);
	}

	int rows, cols, depth;
	
  // Getting comments
  fgets(comment, 256, input_fd);

  // Getting image size
  fgets(raw_row, 50, input_fd);
  sscanf(raw_row, "%i %i", &rows, &cols);

  // Getting image depth
  fgets(raw_row, 50, input_fd);
  sscanf(raw_row, "%i", &depth);

	img->data = (char*) malloc(rows*cols);
	img->cols = cols;
	img->rows = rows;
	img->depth = depth;

	fread(img->data, sizeof(char), rows*cols, input_fd);

  printf("Readed PGM image: %s, %ix%i\n", input_name, img->rows, img->cols);

	fclose(input_fd);

	return 1;
}

int write_pgm(char *output_name, image *img){

	FILE *output_fd;
	int ndata = img->rows*img->cols;

	output_fd = fopen(output_name, "w");

	fprintf(output_fd, "%s\n", "P5");
	fprintf(output_fd, "#\n");
	fprintf(output_fd, "%i %i\n", img->rows, img->cols);
	fprintf(output_fd, "%i\n", img->depth);

	fwrite(img->data, sizeof(char), ndata, output_fd);

  printf("Saved PGM image: %s\n", output_name);

	fclose(output_fd);

	return 1;
}

