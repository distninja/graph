#include <iostream>
#include <cstdlib>

#include "graph.h"

int main() {
    char* result = Hello(const_cast<char*>("World"));
    std::cout << result << std::endl;
    FreeString(result);

    return 0;
}
