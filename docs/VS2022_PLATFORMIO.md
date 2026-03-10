# PlatformIO with Visual Studio 2022

## Overview

While PlatformIO is typically used with VS Code, you can still use it effectively with Visual Studio 2022 for ESP32 development. This guide shows you how to integrate PlatformIO with VS2022.

## Setup Options

### Option 1: Using PlatformIO Core with VS2022 (Recommended)

Visual Studio 2022 can work with PlatformIO through the command line and external tools.

#### 1. Install PlatformIO Core

```powershell
# In PowerShell or VS2022 Developer Command Prompt
pip install platformio

# Verify installation
pio --version
```

#### 2. Configure External Tools in VS2022

**Add PlatformIO Build:**
1. Tools ? External Tools
2. Click "Add"
3. Configure:
   - Title: `PlatformIO Build`
   - Command: `pio`
   - Arguments: `run`
   - Initial directory: `$(SolutionDir)`
   - ? Use Output window

**Add PlatformIO Upload:**
1. Tools ? External Tools
2. Click "Add"
3. Configure:
   - Title: `PlatformIO Upload`
   - Command: `pio`
   - Arguments: `run -t upload`
   - Initial directory: `$(SolutionDir)`
   - ? Use Output window

**Add PlatformIO Monitor:**
1. Tools ? External Tools
2. Click "Add"
3. Configure:
   - Title: `PlatformIO Monitor`
   - Command: `pio`
   - Arguments: `device monitor`
   - Initial directory: `$(SolutionDir)`
   - ? Use Output window

**Add PlatformIO Clean:**
1. Tools ? External Tools
2. Click "Add"
3. Configure:
   - Title: `PlatformIO Clean`
   - Command: `pio`
   - Arguments: `run -t clean`
   - Initial directory: `$(SolutionDir)`
   - ? Use Output window

#### 3. Create Keyboard Shortcuts (Optional)

1. Tools ? Options ? Environment ? Keyboard
2. Search for "Tools.ExternalCommand" entries
3. Assign shortcuts:
   - `Ctrl+Shift+B` for Build
   - `Ctrl+Shift+U` for Upload
   - `Ctrl+Shift+M` for Monitor

---

### Option 2: Using PowerShell Scripts in VS2022

You can run the PlatformIO manager scripts directly from VS2022.

#### Configure as External Tool

**PlatformIO Manager:**
1. Tools ? External Tools ? Add
2. Configure:
   - Title: `PlatformIO Manager`
   - Command: `powershell.exe`
   - Arguments: `-ExecutionPolicy Bypass -File "$(SolutionDir)scripts\pio_manager.ps1"`
   - Initial directory: `$(SolutionDir)`
   - ? Use Output window

---

### Option 3: Dual IDE Setup (Best of Both Worlds)

Use both IDEs for their strengths:

**Visual Studio 2022:**
- ? C++ IntelliSense and debugging
- ? Unit testing with Google Test
- ? CMake projects
- ? Code analysis tools

**VS Code with PlatformIO:**
- ? ESP32 building and uploading
- ? Serial monitoring
- ? Library management
- ? Hardware debugging

#### Workflow:
1. **Write and test code in VS2022:**
   ```powershell
   # Run unit tests
   .\scripts\build_and_test.ps1
   ```

2. **Build and upload with VS Code:**
   - Open project in VS Code
   - Use PlatformIO toolbar
   - Upload to ESP32

---

## Using PlatformIO from VS2022 Terminal

### Open Terminal in VS2022
- View ? Terminal
- Or: `Ctrl+` (backtick)

### Run PlatformIO Commands

```powershell
# Build
pio run

# Upload
pio run -t upload

# Monitor
pio device monitor

# Clean
pio run -t clean

# Use the manager script
.\scripts\pio_manager.ps1
```

---

## Project Structure in VS2022

### Current Setup

Your project has two build systems:

```
C:\Users\taha\Desktop\NES on ESP 32\
??? CMakeLists.txt          # For VS2022 (unit testing)
??? platformio.ini          # For ESP32 (hardware)
??? .vs/                    # VS2022 files
??? build/                  # CMake build output
??? .pio/                   # PlatformIO build output
??? include/                # Shared headers
??? src/                    # Shared source
??? test/                   # Unit tests
```

### Opening Projects

**For Unit Testing (CMake):**
1. File ? Open ? Folder
2. Select project root
3. VS2022 will detect CMakeLists.txt
4. Build and run tests

**For ESP32 Development:**
- Use Terminal: `pio run`
- Or use External Tools
- Or use VS Code

---

## Recommended Workflow

### Development Cycle

```
???????????????????????????????????????????
? Visual Studio 2022                       ?
???????????????????????????????????????????
? 1. Write code in src/                   ?
? 2. Write tests in test/                 ?
? 3. Build with CMake                     ?
? 4. Run unit tests (Ctrl+R, A)          ?
? 5. Debug with VS2022 debugger          ?
???????????????????????????????????????????
              ?
         Code Verified
              ?
???????????????????????????????????????????
? PlatformIO (Terminal or VS Code)        ?
???????????????????????????????????????????
? 1. Open Terminal in VS2022              ?
? 2. Run: pio run                         ?
? 3. Run: pio run -t upload               ?
? 4. Run: pio device monitor              ?
? 5. Test on ESP32 hardware               ?
???????????????????????????????????????????
```

---

## CMake vs PlatformIO

| Feature | CMake (VS2022) | PlatformIO |
|---------|----------------|------------|
| **Purpose** | Unit testing on PC | ESP32 hardware |
| **Platform** | Windows/Linux/Mac | ESP32 |
| **Testing** | Google Test (33 tests) | Hardware testing |
| **Debugging** | VS2022 debugger | Serial monitor |
| **Libraries** | None (core only) | TFT_eSPI, SdFat |
| **Build** | `cmake --build build` | `pio run` |

---

## Quick Setup Guide for VS2022

### 1. Install PlatformIO
```powershell
# In VS2022 Terminal
pip install platformio
```

### 2. Configure Build System
In VS2022, you already have CMake configured for unit tests. Keep it!

### 3. Add PlatformIO to Toolbar
- Tools ? External Tools
- Add PlatformIO commands (see above)

### 4. Test the Setup

**Unit Tests (CMake):**
```powershell
# In VS2022 Terminal
.\scripts\build_and_test.ps1
```

**ESP32 Build (PlatformIO):**
```powershell
# In VS2022 Terminal
pio run
```

---

## VS2022 CMake Integration

### Your Current CMake Setup

```cmake
# CMakeLists.txt is configured for:
- Building core library (nes_core)
- Running unit tests with Google Test
- Cross-platform compilation

# NOT configured for:
- ESP32 compilation
- Arduino framework
- Hardware-specific features
```

### Why Keep Both?

**CMake (VS2022):**
- Fast iteration on PC
- Comprehensive debugging
- Unit testing
- Code coverage
- Static analysis

**PlatformIO:**
- ESP32-specific builds
- Hardware testing
- Display/SD card/peripherals
- Optimized for embedded

---

## VS2022 Extensions (Optional)

### Recommended Extensions

1. **Arduino for Visual Studio**
   - Marketplace: Arduino IDE for Visual Studio
   - Provides Arduino/ESP32 support

2. **Serial Monitor**
   - Marketplace: Serial Monitor
   - View serial output in VS2022

3. **Hex Editor**
   - Marketplace: Hex Editor
   - View binary files and ROMs

---

## Common Tasks in VS2022

### Build Unit Tests
```
1. Solution Explorer ? Right-click solution
2. Build Solution (Ctrl+Shift+B)
3. Test ? Run All Tests (Ctrl+R, A)
```

### Build for ESP32
```
1. View ? Terminal
2. Type: pio run
3. Or: Tools ? PlatformIO Build
```

### Upload to ESP32
```
1. View ? Terminal
2. Type: pio run -t upload
3. Or: Tools ? PlatformIO Upload
```

### Monitor Serial
```
1. View ? Terminal
2. Type: pio device monitor
3. Or: Tools ? PlatformIO Monitor
```

---

## Troubleshooting

### PlatformIO Commands Not Found in Terminal

**Solution:**
```powershell
# Add PlatformIO to PATH
$env:Path += ";C:\Users\taha\.platformio\penv\Scripts"

# Or restart VS2022 after installing PlatformIO
```

### CMake and PlatformIO Conflicts

**Solution:**
They don't conflict! They use different build directories:
- CMake: `build/`
- PlatformIO: `.pio/`

### IntelliSense Not Working for Arduino/ESP32

**Solution:**
1. Install "Arduino for Visual Studio" extension
2. Or use VS Code for Arduino IntelliSense
3. VS2022 works best for CMake/testing

---

## Best Practices

### ? DO:
- Use VS2022 for unit testing (fast, great debugger)
- Use PlatformIO for ESP32 builds (optimized)
- Use Terminal for PlatformIO commands
- Keep both build systems

### ? DON'T:
- Try to compile Arduino code with CMake
- Try to run ESP32 tests on PC
- Delete `.pio/` or `build/` directories
- Mix build outputs

---

## Quick Reference

### VS2022 Commands
```
Build Tests:      Ctrl+Shift+B
Run Tests:        Ctrl+R, A
Open Terminal:    Ctrl+`
Stop Build:       Ctrl+Break
```

### PlatformIO Commands (in Terminal)
```
Build:            pio run
Upload:           pio run -t upload
Monitor:          pio device monitor
Clean:            pio run -t clean
Manager:          .\scripts\pio_manager.ps1
```

### Testing Commands
```
CMake Tests:      .\scripts\build_and_test.ps1
CTest:            cd build && ctest -C Debug
Direct:           .\build\test\Debug\nes_tests.exe
```

---

## Summary

You now have a powerful dual-setup:

1. **Visual Studio 2022**
   - Unit testing with Google Test
   - PC-based development
   - Full debugging capabilities
   - CMake build system

2. **PlatformIO** (via Terminal or VS Code)
   - ESP32 hardware builds
   - Upload and monitoring
   - Library management
   - Hardware testing

**Use the right tool for the right job!** ??

---

## Next Steps

1. ? Install PlatformIO: `pip install platformio`
2. ? Test CMake build in VS2022: `Ctrl+Shift+B`
3. ? Test PlatformIO in Terminal: `pio run`
4. ?? Start developing!

For detailed PlatformIO usage, see:
- [PLATFORMIO_COMPLETE.md](../PLATFORMIO_COMPLETE.md)
- [PLATFORMIO_WORKFLOW.md](PLATFORMIO_WORKFLOW.md)
