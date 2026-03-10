# Quick Reference: NES Emulator Development in Visual Studio 2022

## Your Development Environment

You have **TWO** build systems configured:

### 1?? CMake (for Unit Testing)
- **Platform:** Windows/Linux/Mac (PC)
- **IDE:** Visual Studio 2022
- **Tests:** 33 Google Test unit tests
- **Purpose:** Fast development and testing

### 2?? PlatformIO (for ESP32 Hardware)
- **Platform:** ESP32 microcontroller
- **IDE:** VS2022 Terminal or VS Code
- **Tests:** Hardware/integration testing
- **Purpose:** Final deployment

---

## Quick Commands Cheat Sheet

### In Visual Studio 2022

| Task | Keyboard Shortcut | Menu |
|------|-------------------|------|
| Build Solution | `Ctrl+Shift+B` | Build ? Build Solution |
| Run All Tests | `Ctrl+R, A` | Test ? Run All Tests |
| Open Terminal | `Ctrl+` ` (backtick) | View ? Terminal |
| Solution Explorer | `Ctrl+Alt+L` | View ? Solution Explorer |
| Output Window | `Ctrl+Alt+O` | View ? Output |

### In VS2022 Terminal (for PlatformIO)

```powershell
# Build for ESP32
pio run

# Upload to ESP32
pio run -t upload

# Monitor serial output
pio device monitor

# Clean build
pio run -t clean

# All-in-one: upload and monitor
pio run -t upload && pio device monitor

# Use interactive manager
.\scripts\pio_manager.ps1
```

---

## Typical Workflow

### ?? Development Cycle

```
????????????????????????????????????
? 1. WRITE CODE (VS2022)           ?
?    - Edit src/*.cpp files        ?
?    - Edit include/*.h files      ?
????????????????????????????????????
                ?
????????????????????????????????????
? 2. WRITE TESTS (VS2022)          ?
?    - Edit test/*.cpp files       ?
?    - Add new TEST_F() cases      ?
????????????????????????????????????
                ?
????????????????????????????????????
? 3. BUILD & TEST (VS2022)         ?
?    Press: Ctrl+Shift+B           ?
?    Press: Ctrl+R, A              ?
?    ? All tests passing?         ?
????????????????????????????????????
                ?
????????????????????????????????????
? 4. BUILD FOR ESP32 (Terminal)    ?
?    Press: Ctrl+`                 ?
?    Type: pio run                 ?
?    ? Build successful?          ?
????????????????????????????????????
                ?
????????????????????????????????????
? 5. UPLOAD (Terminal)             ?
?    Type: pio run -t upload       ?
?    ? Upload complete?           ?
????????????????????????????????????
                ?
????????????????????????????????????
? 6. TEST ON HARDWARE (Terminal)   ?
?    Type: pio device monitor      ?
?    Check serial output           ?
?    Verify display output         ?
????????????????????????????????????
```

---

## Project Structure

```
NES on ESP 32/
??? ?? src/                    # Your source code
?   ??? cpu_6502.cpp          # CPU emulator
?   ??? ppu.cpp               # Graphics
?   ??? nes.cpp               # Main system
?   ??? main.cpp              # ESP32 entry point
?
??? ?? include/                # Header files
?   ??? cpu_6502.h
?   ??? ppu.h
?   ??? nes.h
?
??? ?? test/                   # Unit tests (Google Test)
?   ??? test_cpu_6502.cpp
?   ??? test_ppu.cpp
?   ??? test_nes.cpp
?
??? ?? scripts/                # Automation scripts
?   ??? build_and_test.ps1    # Unit testing
?   ??? pio_manager.ps1       # PlatformIO manager
?
??? ?? docs/                   # Documentation
?   ??? VS2022_PLATFORMIO.md  # This guide!
?   ??? PLATFORMIO_SETUP.md
?   ??? PLATFORMIO_WORKFLOW.md
?
??? ?? CMakeLists.txt         # CMake config (unit tests)
??? ?? platformio.ini         # PlatformIO config (ESP32)
?
??? ?? build/                  # CMake output (PC)
??? ?? .pio/                   # PlatformIO output (ESP32)
```

---

## Common Tasks

### ? Task 1: Build and Run Unit Tests

**In Visual Studio 2022:**
1. Open solution in VS2022
2. Press `Ctrl+Shift+B` to build
3. Press `Ctrl+R, A` to run all tests
4. View results in Test Explorer

**Or use PowerShell:**
```powershell
.\scripts\build_and_test.ps1
```

---

### ? Task 2: Build for ESP32

**In VS2022 Terminal:**
1. Press `Ctrl+` ` (backtick) to open terminal
2. Type: `pio run`
3. Wait for build to complete

---

### ? Task 3: Upload to ESP32

**Prerequisites:**
- ESP32 connected via USB
- CP210x drivers installed

**Steps:**
1. Open Terminal: `Ctrl+` `
2. Check connection: `pio device list`
3. Upload: `pio run -t upload`
4. Monitor: `pio device monitor`

---

### ? Task 4: Debug a Test

**In Visual Studio 2022:**
1. Open test file (e.g., `test/test_cpu_6502.cpp`)
2. Set breakpoint: Click left margin (F9)
3. Test Explorer ? Right-click test
4. Select "Debug Selected Tests"
5. Use debugger (F10, F11, etc.)

---

### ? Task 5: Add New Test

**Steps:**
1. Open test file (e.g., `test/test_cpu_6502.cpp`)
2. Add new test:
```cpp
TEST_F(CPU6502Test, MyNewTest) {
    // Arrange
    cpu.A = 0x42;
    
    // Act
    cpu.clock();
    
    // Assert
    EXPECT_EQ(cpu.A, 0x42);
}
```
3. Build: `Ctrl+Shift+B`
4. Run: `Ctrl+R, A`

---

## Installation Checklist

### For Unit Testing (Already Done! ?)
- [x] CMake 3.16+ installed
- [x] Visual Studio 2022 installed
- [x] Google Test configured
- [x] 33 tests passing

### For ESP32 Development (To Do:)
- [ ] Python installed
- [ ] PlatformIO installed: `pip install platformio`
- [ ] ESP32 board connected
- [ ] CP210x drivers installed
- [ ] First build successful: `pio run`

---

## Keyboard Shortcuts Summary

### Visual Studio 2022
```
Build:                Ctrl+Shift+B
Run Tests:            Ctrl+R, A
Open Terminal:        Ctrl+`
Solution Explorer:    Ctrl+Alt+L
Find in Files:        Ctrl+Shift+F
Go to Definition:     F12
Format Document:      Ctrl+K, Ctrl+D
Comment/Uncomment:    Ctrl+K, Ctrl+C / Ctrl+K, Ctrl+U
```

### PowerShell Terminal
```
Clear:                cls
Stop Command:         Ctrl+C
Previous Command:     ?
Autocomplete:         Tab
```

---

## Troubleshooting

### ? Tests Fail in VS2022

**Solution:**
1. Clean build: Build ? Clean Solution
2. Rebuild: Build ? Rebuild Solution
3. Run tests: `Ctrl+R, A`

### ? PlatformIO Not Found

**Solution:**
```powershell
# Install PlatformIO
pip install platformio

# Verify
pio --version

# If still not found, restart VS2022
```

### ? ESP32 Not Detected

**Solution:**
1. Check USB cable (must be data cable)
2. Install CP210x drivers
3. Check Device Manager
4. Try: `pio device list`

### ? Upload Fails

**Solution:**
1. Hold BOOT button on ESP32
2. Run: `pio run -t upload`
3. Release BOOT when "Connecting..." appears

---

## External Tools Setup (Optional)

Add PlatformIO to VS2022 menu:

### Configure External Tools
1. Tools ? External Tools ? Add
2. For Build:
   - Title: `PlatformIO Build`
   - Command: `pio`
   - Arguments: `run`
   - Initial directory: `$(SolutionDir)`
   - ? Use Output window

3. For Upload:
   - Title: `PlatformIO Upload`  
   - Command: `pio`
   - Arguments: `run -t upload`
   - Initial directory: `$(SolutionDir)`
   - ? Use Output window

4. For Monitor:
   - Title: `PlatformIO Monitor`
   - Command: `pio`
   - Arguments: `device monitor`
   - Initial directory: `$(SolutionDir)`
   - ? Use Output window

Now access via: Tools ? PlatformIO Build/Upload/Monitor

---

## Resources

### Documentation
- [VS2022_PLATFORMIO.md](VS2022_PLATFORMIO.md) - Full VS2022 guide
- [PLATFORMIO_SETUP.md](PLATFORMIO_SETUP.md) - PlatformIO setup
- [PLATFORMIO_WORKFLOW.md](PLATFORMIO_WORKFLOW.md) - Development workflow
- [QUICKSTART.md](../QUICKSTART.md) - Project quick start

### Commands
- [build_and_test.ps1](../scripts/build_and_test.ps1) - Unit testing
- [pio_manager.ps1](../scripts/pio_manager.ps1) - PlatformIO manager

---

## Quick Install

### Install Everything in One Go

```powershell
# In VS2022 Terminal (Ctrl+`)

# Install PlatformIO
pip install platformio

# Verify installation
pio --version

# Build unit tests
.\scripts\build_and_test.ps1

# Build for ESP32
pio run

# Done! ?
```

---

## Summary

You're using **Visual Studio 2022** with a **dual build system**:

| System | Purpose | Command |
|--------|---------|---------|
| **CMake** | Unit testing on PC | `Ctrl+Shift+B` |
| **PlatformIO** | ESP32 hardware | `pio run` |

**Best Practice:**
1. Develop and test in VS2022 (fast feedback)
2. Deploy to ESP32 with PlatformIO (hardware testing)

**You get the best of both worlds!** ??

---

*Keep this file open for quick reference while developing!*
