# Quick Start Guide

## Option 1: Using Build Scripts (Easiest)

### Windows
```powershell
.\scripts\build_and_test.ps1
```

### Linux/macOS
```bash
chmod +x scripts/build_and_test.sh
./scripts/build_and_test.sh
```

## Option 2: Manual Build with CMake

### Step 1: Create Build Directory
```bash
mkdir build
cd build
```

### Step 2: Configure
```bash
cmake .. -DBUILD_TESTS=ON
```

### Step 3: Build
```bash
# Windows
cmake --build . --config Debug

# Linux/macOS
make -j4
```

### Step 4: Run Tests
```bash
# Windows
ctest -C Debug --output-on-failure

# Linux/macOS
ctest --output-on-failure
```

## Option 3: Using VSCode

1. Open the project folder in VSCode
2. Install recommended extensions when prompted
3. Press `Ctrl+Shift+B` (or `Cmd+Shift+B` on macOS)
4. Select "Build and Test"

Or use the Command Palette (`Ctrl+Shift+P`):
- "Tasks: Run Task" ? "CMake: Build"
- "Tasks: Run Task" ? "CTest: Run All Tests"

## Option 4: For ESP32 Development (PlatformIO)

### Using PlatformIO CLI
```bash
# Build
pio run

# Upload to ESP32
pio run -t upload

# Monitor serial output
pio device monitor
```

### Using VSCode with PlatformIO Extension
1. Click PlatformIO icon in sidebar
2. Click "Build" under PROJECT TASKS
3. Click "Upload" to flash to ESP32
4. Click "Monitor" to view serial output

## Running Specific Tests

### Run tests for a specific component
```bash
# Windows
.\build\test\Debug\nes_tests.exe --gtest_filter=CPU6502Test.*

# Linux/macOS
./build/test/nes_tests --gtest_filter=CPU6502Test.*
```

### Run a single test
```bash
# Windows
.\build\test\Debug\nes_tests.exe --gtest_filter=CPU6502Test.ResetInitializesRegisters

# Linux/macOS
./build/test/nes_tests --gtest_filter=CPU6502Test.ResetInitializesRegisters
```

### List all available tests
```bash
# Windows
.\build\test\Debug\nes_tests.exe --gtest_list_tests

# Linux/macOS
./build/test/nes_tests --gtest_list_tests
```

## Troubleshooting

### CMake not found
- **Windows**: Download from https://cmake.org/download/
- **Ubuntu/Debian**: `sudo apt-get install cmake`
- **macOS**: `brew install cmake`

### Compiler not found
- **Windows**: Install Visual Studio 2019 or later with C++ workload
- **Ubuntu/Debian**: `sudo apt-get install build-essential`
- **macOS**: `xcode-select --install`

### PlatformIO not found
```bash
pip install platformio
```

### Build fails with "cannot find -lstdc++"
```bash
# Ubuntu/Debian
sudo apt-get install libstdc++-dev
```

## Project Structure

```
NES on ESP32/
??? include/           # Header files
?   ??? cpu_6502.h
?   ??? ppu.h
?   ??? nes.h
??? src/               # Source files
?   ??? cpu_6502.cpp
?   ??? ppu.cpp
?   ??? nes.cpp
?   ??? main.cpp      # ESP32 entry point
??? test/              # Unit tests
?   ??? test_cpu_6502.cpp
?   ??? test_ppu.cpp
?   ??? test_nes.cpp
?   ??? test_main.cpp
??? docs/              # Documentation
??? scripts/           # Build scripts
??? CMakeLists.txt     # CMake configuration
??? platformio.ini     # PlatformIO configuration
```

## Next Steps

1. ? Build and run tests
2. ?? Read [docs/TESTING.md](docs/TESTING.md) for testing details
3. ?? Read [docs/BUILD.md](docs/BUILD.md) for build options
4. ?? Start implementing CPU opcodes
5. ??? Implement PPU rendering
6. ?? Add APU (audio) support
7. ?? Connect ESP32 hardware
