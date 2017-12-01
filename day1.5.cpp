#include <iostream>
#include <string.h>

int main(int argc, char** argv) {
	if (argc != 2) {
		std::cout << "Usage: " << argv[0] << " [0-9]+" << std::endl;
		return 0;
	}

	uint32_t length = strlen(argv[1]);
	uint32_t sum = 0;

	std::cout << "Length is " << length << std::endl;	

	if (length == 0) {
		return 0;
	}

	uint32_t i = 0;
	uint32_t j = length / 2; // Even number of elements

	std::cout << "Starting with " << i << " and " << j << std::endl;

	do {
		if (argv[1][i] == argv[1][j]) {
			sum += argv[1][i] - '0';
		}		
		i += 1;
		j += 1;
		if (j >= length) {
			j = 0;
		}
		if (i >= length) {
			i = 0;
		}
	} while(i != 0);
	
	std::cout << "Sum is " << sum << std::endl;
	
	return 0;
}

