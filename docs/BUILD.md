# Building with CMake

This project supports building with CMake for development and testing on host systems.

## Prerequisites

- CMake 3.16 or higher
- C++11 compatible compiler (GCC, Clang, MSVC)
- Git (for fetching Google Test)

## Building the Project

### On Windows (Visual Studio)

```bash
# Create build directory
mkdir build
cd build

# Configure with CMake
cmake ..

# Build
cmake --build . --config Debug

# Run tests
ctest -C Debug --output-on-failure
```

### On Linux/macOS

```bash
# Create build directory
mkdir build
cd build

# Configure with CMake
cmake ..

# Build
make -j4

# Run tests
ctest --output-on-failure
```

## Build Options

- `BUILD_TESTS` - Build unit tests (default: ON)
- `BUILD_ESP32` - Build for ESP32 target (default: OFF)

Example with custom options:
```bash
cmake -DBUILD_TESTS=ON -DBUILD_ESP32=OFF ..
```

## Running Tests

After building, you can run tests using:

```bash
# Using CTest
ctest --output-on-failure

# Or run the test executable directly
./test/nes_tests

# On Windows
.\test\Debug\nes_tests.exe
```

## IDE Support

### Visual Studio
```bash
cmake -G "Visual Studio 17 2022" ..
```

Then open the generated `.sln` file.

### Visual Studio Code
Install the CMake Tools extension and open the workspace folder.

### CLion
Open the folder containing `CMakeLists.txt` and CLion will automatically configure the project.
