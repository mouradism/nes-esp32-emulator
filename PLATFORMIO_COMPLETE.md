# ? PlatformIO Setup Complete!

## What Was Added

### ?? Configuration Files
? **platformio.ini** - Enhanced with optimization settings
  - CPU frequency: 240 MHz
  - Flash frequency: 80 MHz
  - PSRAM support enabled
  - Dual-core configuration
  - Exception decoder for debugging

### ??? Management Scripts
? **scripts/pio_manager.ps1** - Windows PowerShell manager
? **scripts/pio_manager.py** - Python manager (cross-platform)

Both scripts provide:
- Interactive menu interface
- Build project
- Upload to ESP32
- Serial monitoring
- Clean builds
- Library management
- Device listing
- PlatformIO installation

### ?? Documentation
? **docs/PLATFORMIO_SETUP.md** - Complete setup guide
  - Installation instructions
  - Quick start commands
  - Troubleshooting
  - Hardware setup

? **docs/PLATFORMIO_WORKFLOW.md** - Development workflow
  - Daily development cycle
  - Pin configurations
  - Performance optimization
  - Testing procedures
  - Advanced features

? **lib/TFT_eSPI_Config.h** - Display configuration template
  - Pin definitions for ESP32
  - ILI9341 display setup
  - SPI configuration
  - Font settings

? **test/platformio_test_README.md** - Hardware testing guide
  - Test environment setup
  - Performance testing
  - Pin connection reference

### ?? Updated Files
? **README.md** - Added PlatformIO section
? **QUICKSTART.md** - Added PlatformIO quick start

---

## ?? Quick Start with PlatformIO

### 1. Install PlatformIO
```bash
pip install platformio
```

### 2. Navigate to Project
```bash
cd "C:\Users\taha\Desktop\NES on ESP 32"
```

### 3. Build Project
```bash
pio run
```

### 4. Upload to ESP32
```bash
pio run -t upload
```

### 5. Monitor Output
```bash
pio device monitor
```

---

## ?? Or Use the Easy Manager

### Windows
```powershell
.\scripts\pio_manager.ps1
```

### Linux/macOS
```bash
python3 scripts/pio_manager.py
```

This provides a convenient menu with all common operations!

---

## ?? platformio.ini Configuration

Your project is configured with:

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200

; Optimized build flags
build_flags = 
    -DCORE_DEBUG_LEVEL=3          ; Debug output
    -DBOARD_HAS_PSRAM             ; PSRAM support
    -mfix-esp32-psram-cache-issue ; PSRAM fix
    -DARDUINO_RUNNING_CORE=1      ; Core assignment
    
; Required libraries
lib_deps = 
    bodmer/TFT_eSPI@^2.5.43      ; Display driver
    greiman/SdFat@^2.2.2         ; SD card support

; Performance settings
board_build.f_cpu = 240000000L    ; Max CPU speed
board_build.f_flash = 80000000L   ; Flash speed
board_build.partitions = huge_app.csv  ; More space
```

---

## ?? Hardware Connections

### TFT Display (ILI9341)
```
ESP32    ->  TFT Display
?????????????????????????
GPIO 23  ->  MOSI
GPIO 19  ->  MISO  
GPIO 18  ->  SCK
GPIO 15  ->  CS
GPIO 2   ->  DC
GPIO 4   ->  RST
3.3V     ->  VCC
GND      ->  GND
```

### SD Card Module (Optional)
```
ESP32    ->  SD Card
?????????????????????
GPIO 23  ->  MOSI (shared)
GPIO 19  ->  MISO (shared)
GPIO 18  ->  SCK (shared)
GPIO 5   ->  CS
3.3V     ->  VCC
GND      ->  GND
```

---

## ?? Documentation Reference

| Document | Purpose |
|----------|---------|
| [PLATFORMIO_SETUP.md](docs/PLATFORMIO_SETUP.md) | Installation and setup |
| [PLATFORMIO_WORKFLOW.md](docs/PLATFORMIO_WORKFLOW.md) | Development workflow |
| [TFT_eSPI_Config.h](lib/TFT_eSPI_Config.h) | Display configuration |
| [platformio_test_README.md](test/platformio_test_README.md) | Hardware testing |

---

## ?? Common Commands

```bash
# Build
pio run

# Upload
pio run -t upload

# Monitor
pio device monitor

# Clean
pio run -t clean

# List devices
pio device list

# Update libraries
pio lib update

# Full rebuild
pio run -t clean && pio run -t upload && pio device monitor
```

---

## ?? Troubleshooting

### PlatformIO Not Found
```bash
# Install or upgrade
pip install --upgrade platformio

# Verify
pio --version
```

### Upload Fails
1. Hold BOOT button on ESP32
2. Run `pio run -t upload`
3. Release BOOT when upload starts

### No Serial Output
1. Check baud rate (115200)
2. Check USB cable (data, not charge-only)
3. Install CP210x drivers if needed

### Display Issues
1. Verify pin connections
2. Check TFT_eSPI configuration
3. Test with known-good display code

---

## ? What's Next?

### For ESP32 Development
1. Connect your ESP32 and display
2. Run `.\scripts\pio_manager.ps1`
3. Select "Build and upload"
4. Monitor the serial output

### For Code Development
1. Continue with CMake for unit testing
2. Use `.\scripts\build_and_test.ps1`
3. Write tests first (TDD approach)
4. Test on hardware with PlatformIO

### Workflow
```
Write Code -> Unit Test (CMake) -> Hardware Test (PlatformIO)
     ?                                          |
     ????????????????? Fix bugs ????????????????
```

---

## ?? Status

? **PlatformIO configured and ready**
? **Build system optimized for ESP32**
? **Management scripts created**
? **Documentation complete**
? **Hardware pin configuration defined**
? **Ready for ESP32 development**

---

## ?? Checklist for First Upload

- [ ] PlatformIO installed (`pio --version`)
- [ ] ESP32 connected via USB
- [ ] CP210x drivers installed (if needed)
- [ ] TFT display connected (optional for first test)
- [ ] Project builds successfully (`pio run`)
- [ ] Upload successful (`pio run -t upload`)
- [ ] Serial output visible (`pio device monitor`)

---

## ?? Pro Tips

1. **Use the manager scripts** - They make life easier!
2. **Test on hardware regularly** - Catch issues early
3. **Monitor serial output** - Essential for debugging
4. **Check pin connections** - Most common issue
5. **Use debug output** - Enabled with CORE_DEBUG_LEVEL=3

---

## ?? Expected Output on ESP32

When you upload and run, you should see:

```
NES Emulator on ESP32
Initializing...
Initialization complete
Waiting for ROM file...
Ready!
```

And on the display:
```
NES Emulator
Initializing...
Ready!
```

---

**Your ESP32 development environment is now complete and ready!** ??

See the documentation files for detailed information on:
- Hardware setup
- Development workflow
- Performance optimization
- Troubleshooting
