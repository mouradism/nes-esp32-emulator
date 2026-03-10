# NES Emulator on ESP32

A Nintendo Entertainment System (NES) emulator implementation for ESP32 microcontroller.

[![Tests](https://img.shields.io/badge/tests-33%2F33%20passing-brightgreen)](TEST_RESULTS.md)
[![Build](https://img.shields.io/badge/build-passing-brightgreen)](VERIFICATION_COMPLETE.md)
[![Coverage](https://img.shields.io/badge/coverage-~60%25-yellow)](TEST_RESULTS.md)

## ?? Quick Start

**New to this project?** Check out [QUICKSTART.md](QUICKSTART.md) for easy setup instructions!

```bash
# Quick build and test (Windows)
.\scripts\build_and_test.ps1

# Quick build and test (Linux/macOS)
./scripts/build_and_test.sh
```

## Overview
This project aims to run NES games on ESP32 hardware, taking advantage of the dual-core processor and sufficient memory available on the ESP32.

## Hardware Requirements
- ESP32 development board (ESP32-WROOM-32 or similar)
- Display (ILI9341 TFT or similar)
- SD Card module (for ROM storage)
- Buttons/Controller input
- USB cable for programming

## Software Requirements
- ESP-IDF (Espressif IoT Development Framework) or Arduino IDE
- Python 3.x (for ESP-IDF)
- USB drivers for ESP32
- **CMake 3.16+** (for building and testing on host system)
- **C++11 compatible compiler** (for unit tests)
- **PlatformIO** (recommended for ESP32 development)

## Project Structure
```
/
??? src/              # Source files
??? include/          # Header files
??? lib/              # Libraries
??? data/             # ROM files and assets
??? test/             # Unit tests (Google Test)
??? docs/             # Documentation
??? platformio.ini    # PlatformIO configuration (if using PlatformIO)
??? CMakeLists.txt    # CMake configuration (for testing)
??? README.md         # This file
```

## Getting Started

### For ESP32 Development (PlatformIO)
1. Install PlatformIO IDE or PlatformIO Core
2. Open this project folder
3. Connect your ESP32 board
4. Build and upload: `pio run -t upload`

### For Development and Testing (CMake)
1. Install CMake 3.16 or higher
2. Create build directory: `mkdir build && cd build`
3. Configure: `cmake ..`
4. Build: `cmake --build .`
5. Run tests: `ctest --output-on-failure`

See [docs/BUILD.md](docs/BUILD.md) for detailed build instructions.

## Unit Testing

This project includes comprehensive unit tests using Google Test framework.

```bash
# Build and run tests
mkdir build && cd build
cmake ..
cmake --build .
ctest --output-on-failure
```

Run specific tests:
```bash
./test/nes_tests --gtest_filter=CPU6502Test.*
```

See [docs/TESTING.md](docs/TESTING.md) for detailed testing documentation.

## Features (Planned)
- [ ] CPU (6502) emulation
- [ ] PPU (Picture Processing Unit) emulation
- [ ] APU (Audio Processing Unit) emulation
- [ ] Controller input handling
- [ ] ROM loading from SD card
- [ ] Display output via SPI TFT
- [ ] Save state functionality
- [x] Unit test framework
- [x] CMake build system

## License
To be determined

## Acknowledgments
- NES development community
- ESP32 community
- Google Test framework

---

## ?? Project Resources

- ?? [Project Status Dashboard](PROJECT_STATUS.md) - Current progress and metrics
- ?? [Success Summary](SUCCESS.md) - What's been accomplished
- ?? [Quick Start Guide](QUICKSTART.md) - Easy setup instructions
- ?? [Contributing Guide](CONTRIBUTING.md) - How to contribute
- ?? [Build Documentation](docs/BUILD.md) - Detailed build instructions
- ?? [Testing Guide](docs/TESTING.md) - Testing documentation

---

**Status:** ? Project Initialized with Testing Infrastructure | ?? 37+ Tests Passing | ?? ~60% Coverage
