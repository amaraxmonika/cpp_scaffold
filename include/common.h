#include <iostream>
#include <cstring>

class Util {
    public:
        static bool checkVersion(int argc, char** argv) {
            // check no args
            if(argc < 2) {
                return false;
            }

            // argc at least 2
            const char* shortV = "-v";
            const char* longV = "--version";
            int argLength = strlen(argv[1]);
            bool isShortVersion = strcmp(shortV, argv[1]);
            bool isLongVersion = strcmp(longV, argv[1]);
            bool hasVersion = (isShortVersion || isLongVersion);
            bool correctLength = (argLength == strlen(shortV)) || (argLength == strlen(longV));
            if (hasVersion && !correctLength) {
                std::cout << "Did you intend to check the version...?" << std::endl;
                return true;
            }
            else if (hasVersion) {
                // print version
                std::cout << MAJOR_VERSION << "." <<
                    MINOR_VERSION << "-" <<
                    MINOR_REVISION << std::endl;
                return true;
            }

            return false;
    }
};
