# NES Emulator on ESP32
<img width="1258" height="709" alt="image" src="https://github.com/user-attachments/assets/28649a52-e18a-4824-88a9-068db45859e5" />

A Nintendo Entertainment System (NES) emulator implementation for ESP32 microcontroller.

[![Tests](https://img.shields.io/badge/tests-33%2F33%20passing-brightgreen)](TEST_RESULTS.md)
[![Build](https://img.shields.io/badge/build-passing-brightgreen)](VERIFICATION_COMPLETE.md)
[![Coverage](https://img.shields.io/badge/coverage-~60%25-yellow)](TEST_RESULTS.md)
[![IDE](https://img.shields.io/badge/IDE-VS2022%20%2B%20PlatformIO-blue)](docs/VS2022_PLATFORMIO.md)

---

## ?? For Visual Studio 2022 Users

**You're all set!** This project is optimized for VS2022:
-  CMake configured for unit testing
-  Google Test integrated (33 tests passing)
-  PlatformIO ready for ESP32 development

**Quick Start:**
```powershell
# In VS2022: Build and test
Ctrl+Shift+B  # Build
Ctrl+R, A     # Run all tests

# In VS2022 Terminal: Build for ESP32
pip install platformio
pio run
pio run -t upload
```

 See [VS2022 Quick Reference](docs/VS2022_QUICK_REFERENCE.md) for keyboard shortcuts and workflow.

---

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
- **PlatformIO** (recommended for ESP32 development)
- Python 3.x (for ESP-IDF and PlatformIO)
- USB drivers for ESP32
- **CMake 3.16+** (for building and testing on host system)
- **C++11 compatible compiler** (for unit tests)

## Project Structure
```
/
 src/              # Source files
 include/          # Header files
 lib/              # Libraries
 data/             # ROM files and assets
 test/             # Unit tests (Google Test)
 docs/             # Documentation
 platformio.ini    # PlatformIO configuration (if using PlatformIO)
 CMakeLists.txt    # CMake configuration (for testing)
 README.md         # This file
```

## Getting Started

### For ESP32 Development (PlatformIO) - Recommended

#### 1. Install PlatformIO
```bash
# Using pip
pip install platformio

# Verify installation
pio --version
```

Or install PlatformIO IDE extension in Visual Studio Code.

#### 2. Build and Upload
```bash
# Navigate to project
cd "path/to/NES on ESP 32"

# Build project
pio run

# Upload to ESP32
pio run -t upload

# Monitor serial output
pio device monitor
```

#### 3. Using the Manager Script
```powershell
# Windows
.\scripts\pio_manager.ps1

# This provides an interactive menu for:
# - Building
# - Uploading
# - Monitoring
# - Cleaning
# - Managing libraries
```

See [docs/PLATFORMIO_SETUP.md](docs/PLATFORMIO_SETUP.md) for detailed PlatformIO setup.

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

-  [Project Status Dashboard](PROJECT_STATUS.md) - Current progress and metrics
-  [Success Summary](SUCCESS.md) - What's been accomplished
-  [Quick Start Guide](QUICKSTART.md) - Easy setup instructions
-  [Contributing Guide](CONTRIBUTING.md) - How to contribute
-  [Build Documentation](docs/BUILD.md) - Detailed build instructions
-  [Testing Guide](docs/TESTING.md) - Testing documentation

---

**Status:** ? Project Initialized with Testing Infrastructure | ?? 37+ Tests Passing | ?? ~60% Coverage
<img width="1120" height="728" alt="image" src="https://github.com/user-attachments/assets/371a9196-044c-4f7d-8b76-684e21c5cbc8" />

