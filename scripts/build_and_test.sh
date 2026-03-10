#!/bin/bash

# NES Emulator ESP32 - Build and Test Script
# Linux/macOS Bash Script

echo -e "\033[1;36mNES Emulator on ESP32 - Build and Test\033[0m"
echo "========================================"
echo ""

# Check if CMake is installed
if ! command -v cmake &> /dev/null; then
    echo -e "\033[1;31mERROR: CMake is not installed or not in PATH\033[0m"
    echo -e "\033[1;33mPlease install CMake:\033[0m"
    echo "  Ubuntu/Debian: sudo apt-get install cmake"
    echo "  macOS: brew install cmake"
    exit 1
fi

echo -e "\033[1;32mCMake found: $(cmake --version | head -n 1)\033[0m"
echo ""

# Create build directory
if [ -d "build" ]; then
    echo -e "\033[1;33mCleaning existing build directory...\033[0m"
    rm -rf build
fi

echo -e "\033[1;36mCreating build directory...\033[0m"
mkdir build
cd build

# Configure
echo ""
echo -e "\033[1;36mConfiguring project with CMake...\033[0m"
cmake .. -DBUILD_TESTS=ON -DBUILD_ESP32=OFF
if [ $? -ne 0 ]; then
    echo -e "\033[1;31mERROR: CMake configuration failed\033[0m"
    cd ..
    exit 1
fi

# Build
echo ""
echo -e "\033[1;36mBuilding project...\033[0m"
cmake --build . -- -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
if [ $? -ne 0 ]; then
    echo -e "\033[1;31mERROR: Build failed\033[0m"
    cd ..
    exit 1
fi

# Run tests
echo ""
echo -e "\033[1;36mRunning tests...\033[0m"
ctest --output-on-failure --verbose
if [ $? -ne 0 ]; then
    echo -e "\033[1;33mWARNING: Some tests failed\033[0m"
else
    echo ""
    echo -e "\033[1;32mAll tests passed!\033[0m"
fi

cd ..

echo ""
echo -e "\033[1;32mBuild complete!\033[0m"
echo -e "\033[1;36mTest executable location: build/test/nes_tests\033[0m"
echo ""
echo -e "\033[1;33mTo run tests again:\033[0m"
echo -e "\033[0;37m  cd build\033[0m"
echo -e "\033[0;37m  ctest --output-on-failure\033[0m"
echo ""
