#include <pthread.h>
#include <cstdlib>
#include <iostream>

int var = 0;

void* child_fn ( void* arg ) {
	var++; /* Unprotected relative to parent */
	return NULL;
}

int main(int argc, char** argv) {

	std::cout << "You have entered " << argc 
         << " arguments:" << "\n"; 
  
    for (int i = 0; i < argc; ++i) 
        std::cout << argv[i] << "\n"; 

	int *p =(int *)malloc(10 * sizeof(int));
	//free(p);
	pthread_t child;
	pthread_create(&child, NULL, child_fn, NULL);
	var++; /* Unprotected relative to child */
	pthread_join(child, NULL);
	return 0;
}