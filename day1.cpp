#include <iostream>
#include <string.h>

int main(int argc, char** argv) {
	if (argc != 2) {
		std::cout << "Usage: " << argv[0] << " [0-9]+" << std::endl;
		return 0;
	}

	uint32_t length = strlen(argv[1]);
	uint32_t sum = 0;

	if (length == 0) {
		return 0;
	}

	for(uint32_t i = 1; i < length; ++i) {
		//if a digit matches the NEXT sum it
		if (argv[1][i-1] == argv[1][i])
			sum += argv[1][i-1] - '0'; //Quick trick to get int
	}
	if (argv[1][length-1] == argv[1][0]) {
		sum += argv[1][length-1] - '0';
	}
	
	std::cout << "Sum is " << sum << std::endl;
	
	return 0;
}

