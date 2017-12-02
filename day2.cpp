#include <iostream>
#include <fstream>
#include <string>
#include <vector>

#define DELIMITER "\t"

uint32_t checksum(std::vector<uint32_t> &values) {
  uint32_t min = INT32_MAX, max = 0;
  for(std::vector<uint32_t>::iterator iter = values.begin();
      iter != values.end();
      ++iter) {
    if(*iter < min) min = *iter;
    if(*iter > max) max = *iter;
  }
  return max - min;
}

int main(int argc, char **argv) {
  std::string line_buffer;
  std::ifstream input;
  uint32_t checksum_value = 0;

  if (argc != 2) {
    std::cout << "Usage: " << argv[0] << " input_file.txt" << std::endl;
    return 0;
  }

  input.open(argv[1]);
  if (input.is_open()) {
    while (std::getline(input, line_buffer)) {
      std::vector<uint32_t> values;
      while (line_buffer.length() > 0) {
        uint32_t index = line_buffer.find(DELIMITER);
        if (index >= line_buffer.length()) {
          break;
        }
        values.push_back(std::stoi(line_buffer.substr(0, index)));
        line_buffer.erase(0, index+1);
      }
      checksum_value += checksum(values);
    }
  }

  std::cout << "Checksum: " << checksum_value << std::endl;

  return 0;
}