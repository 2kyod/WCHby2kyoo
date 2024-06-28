#include <cstdlib>
#include <iostream>

int main() {
    // Path to your .cmd file
    const char* cmdFilePath = "clean_history_windefender.cmd";

    // Command to run the .cmd file
    std::string command = "cmd /c ";
    command += cmdFilePath;

    // Execute the command
    int result = std::system(command.c_str());

    if (result == 0) {
        std::cout << "Command executed successfully." << std::endl;
    } else {
        std::cerr << "Failed to execute command." << std::endl;
    }

    return result;
}
