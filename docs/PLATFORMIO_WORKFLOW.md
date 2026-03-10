# PlatformIO Development Workflow

## Quick Commands

### Build
```bash
pio run
```

### Upload
```bash
pio run -t upload
```

### Monitor
```bash
pio device monitor
```

### All-in-One
```bash
pio run -t upload && pio device monitor
```

---

## Using the PlatformIO Manager

### Windows
```powershell
.\scripts\pio_manager.ps1
```

### Linux/macOS
```bash
python3 scripts/pio_manager.py
```

### Command-Line Usage
```bash
# Windows
.\scripts\pio_manager.ps1 build
.\scripts\pio_manager.ps1 upload -Port COM3
.\scripts\pio_manager.ps1 monitor -BaudRate 115200
.\scripts\pio_manager.ps1 full

# Linux/macOS
python3 scripts/pio_manager.py build
python3 scripts/pio_manager.py upload /dev/ttyUSB0
python3 scripts/pio_manager.py monitor 115200
python3 scripts/pio_manager.py full
```

---

## Development Workflow

### 1. Initial Setup
```bash
# Install PlatformIO
pip install platformio

# Navigate to project
cd "C:\Users\taha\Desktop\NES on ESP 32"

# First build (downloads dependencies)
pio run
```

### 2. Daily Development
```bash
# Make code changes in src/

# Build and test
pio run

# Upload to ESP32
pio run -t upload

# Monitor output
pio device monitor
```

### 3. Testing Cycle
```bash
# Clean build
pio run -t clean

# Full rebuild
pio run

# Upload and monitor
pio run -t upload && pio device monitor
```

---

## Hardware Setup

### Required Components
1. ESP32 Development Board (ESP32-WROOM-32 or similar)
2. ILI9341 TFT Display (320x240) or compatible
3. SD Card Module (optional, for ROM loading)
4. USB Cable (for programming and power)
5. Breadboard and jumper wires

### Pin Connections

#### TFT Display (ILI9341)
```
ESP32 Pin -> TFT Pin
-----------------------
GPIO 23   -> MOSI
GPIO 19   -> MISO
GPIO 18   -> SCK
GPIO 15   -> CS
GPIO 2    -> DC
GPIO 4    -> RST
3.3V      -> VCC
GND       -> GND
GPIO 22   -> LED (optional, backlight)
```

#### SD Card Module (Optional)
```
ESP32 Pin -> SD Pin
-----------------------
GPIO 23   -> MOSI (shared with TFT)
GPIO 19   -> MISO (shared with TFT)
GPIO 18   -> SCK (shared with TFT)
GPIO 5    -> CS
3.3V      -> VCC
GND       -> GND
```

### Pin Configuration

Default pins are defined in `lib/TFT_eSPI_Config.h`:
```cpp
#define TFT_MISO 19
#define TFT_MOSI 23
#define TFT_SCLK 18
#define TFT_CS   15
#define TFT_DC   2
#define TFT_RST  4
```

---

## Troubleshooting

### Build Errors

**Error: Platform 'espressif32' not found**
```bash
pio platform install espressif32
```

**Error: Library not found**
```bash
pio lib install
# Or manually:
pio lib install "TFT_eSPI"
pio lib install "SdFat"
```

### Upload Errors

**Error: Serial port not found**
1. Check USB connection
2. Install CP210x drivers
3. List available ports: `pio device list`
4. Specify port: `pio run -t upload --upload-port COM3`

**Error: Failed to connect**
1. Hold BOOT button on ESP32
2. Run upload command
3. Release BOOT button after "Connecting..."

**Error: Permission denied (Linux)**
```bash
sudo usermod -a -G dialout $USER
# Logout and login again
```

### Runtime Errors

**Display not working**
1. Check pin connections
2. Verify TFT_eSPI configuration
3. Check power supply (3.3V, sufficient current)
4. Test with TFT_eSPI examples

**No serial output**
1. Check baud rate (115200)
2. Check USB cable (data cable, not charge-only)
3. Check serial monitor settings

---

## Performance Optimization

### Build Optimizations

In `platformio.ini`:
```ini
board_build.f_cpu = 240000000L  ; Max CPU frequency
board_build.partitions = huge_app.csv  ; More space for code
build_flags = 
    -O2                          ; Optimization level
    -DARDUINO_RUNNING_CORE=1     ; Run Arduino on core 1
```

### Runtime Optimizations

```cpp
// Use hardware SPI
#define SPI_FREQUENCY 27000000

// Use DMA for display updates
#define USE_DMA_TO_TFT

// Use PSRAM for frame buffer
#define BOARD_HAS_PSRAM
```

---

## Library Management

### List Installed Libraries
```bash
pio lib list
```

### Install Library
```bash
pio lib install "LibraryName"
pio lib install "LibraryName@version"
```

### Update Libraries
```bash
pio lib update
```

### Search for Libraries
```bash
pio lib search "nes"
pio lib search "display"
```

---

## Advanced Features

### Custom Build Flags

Add to `platformio.ini`:
```ini
build_flags = 
    -DDEBUG_MODE
    -DTEST_PATTERN
    -DFRAME_SKIP=0
```

Use in code:
```cpp
#ifdef DEBUG_MODE
    Serial.println("Debug info");
#endif
```

### Multiple Environments

```ini
[env:esp32dev]
; Standard build

[env:esp32dev_debug]
build_flags = ${env:esp32dev.build_flags} -DDEBUG_MODE
monitor_speed = 921600

[env:esp32dev_release]
build_flags = ${env:esp32dev.build_flags} -O3
build_type = release
```

Build specific environment:
```bash
pio run -e esp32dev_debug
```

### Pre/Post Build Scripts

Add to `platformio.ini`:
```ini
extra_scripts = 
    pre:scripts/pre_build.py
    post:scripts/post_build.py
```

---

## Testing on Hardware

### Expected Boot Sequence
1. ESP32 starts
2. Serial output: "NES Emulator on ESP32"
3. Display initializes (white screen briefly)
4. Text appears: "NES Emulator" / "Initializing..."
5. Text changes: "Ready!"

### Test Display
```cpp
// Add to setup() for testing
tft.fillScreen(TFT_RED);    delay(500);
tft.fillScreen(TFT_GREEN);  delay(500);
tft.fillScreen(TFT_BLUE);   delay(500);
tft.fillScreen(TFT_BLACK);
```

### Monitor Frame Rate
```cpp
// In loop()
unsigned long frameStart = micros();
// ... emulation code ...
unsigned long frameTime = micros() - frameStart;
Serial.printf("Frame time: %lu us (%.1f FPS)\n", 
              frameTime, 1000000.0 / frameTime);
```

---

## Resources

- [PlatformIO Docs](https://docs.platformio.org/)
- [ESP32 Arduino Core](https://github.com/espressif/arduino-esp32)
- [TFT_eSPI Library](https://github.com/Bodmer/TFT_eSPI)
- [SdFat Library](https://github.com/greiman/SdFat)

---

## Quick Reference Card

```
???????????????????????????????????????????????
? PlatformIO Quick Reference                  ?
???????????????????????????????????????????????
? Build:           pio run                    ?
? Upload:          pio run -t upload          ?
? Monitor:         pio device monitor         ?
? Clean:           pio run -t clean           ?
? Devices:         pio device list            ?
? Libraries:       pio lib list               ?
? Update libs:     pio lib update             ?
?                                             ?
? Interactive:     .\scripts\pio_manager.ps1  ?
???????????????????????????????????????????????
```
