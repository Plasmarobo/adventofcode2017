#include <iostream>
#include <string.h>

// How to initialize the index pointer
#define INDEX_AT 0
// How to initialize the comparison pointer
#define COMPARE_AT length / 2
// Advances the index pointer
#define ADVANCE_INDEX(x) ++x
// Advances the comparison pointer
#define ADVANCE_COMPARE(x) ++x

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

	uint32_t index_pointer = INDEX_AT;
	uint32_t comparison_pointer = COMPARE_AT; 

	do {
		if (argv[1][index_pointer] == argv[1][comparison_pointer]) {
			sum += argv[1][index_pointer] - '0';
		}		
		ADVANCE_INDEX(index_pointer);
		ADVANCE_COMPARE(comparison_pointer);
		if (comparison_pointer >= length) {
			comparison_pointer = 0;
		}
		if (index_pointer >= length) {
			index_pointer = 0;
		}
	} while(i != INDEX_AT);
	
	std::cout << "Sum is " << sum << std::endl;
	
	return 0;
}

