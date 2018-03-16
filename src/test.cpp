#include <iostream>
#include "test.h"
#include "common.h"

int main(int argc, char **argv) {

    Util::checkVersion(argc, argv);
    std::cout << "this works" << std::endl;
    return 0;
}
