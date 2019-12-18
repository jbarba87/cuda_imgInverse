CC = nvcc
FLAGS = -O2 -Wall

all: clean imagen_neg
	@ echo "Compilado "

clean:
	@rm -f *.o *~ image_neg

imagen_neg: image_neg.cu
	$(CC) -o image_neg image_neg.cu pgm_library.cu	-I/usr/local/cuda/include/ -L/usr/local/cuda/include/lib

