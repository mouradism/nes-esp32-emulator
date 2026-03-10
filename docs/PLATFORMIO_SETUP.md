# PlatformIO Setup Guide for NES Emulator on ESP32

## Installation

### Option 1: Install PlatformIO Core (Command Line)

**Windows:**
```powershell
# Install Python first if not already installed
# Download from: https://www.python.org/downloads/

# Install PlatformIO Core
pip install platformio

# Verify installation
pio --version
```

**Linux/macOS:**
```bash
# Install using pip
pip install platformio

# Or use the installer script
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py -o get-platformio.py
python3 get-platformio.py

# Verify installation
pio --version
```

### Option 2: Install PlatformIO IDE (Visual Studio Code Extension)

1. Open Visual Studio Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search for "PlatformIO IDE"
4. Click "Install"
5. Restart VS Code

---

## Quick Start with PlatformIO

### 1. Build the Project
```bash
# Navigate to project directory
cd "C:\Users\taha\Desktop\NES on ESP 32"

# Build the project
pio run
```

### 2. Upload to ESP32
```bash
# List available ports
pio device list

# Upload to ESP32 (auto-detect port)
pio run -t upload

# Or specify port manually
pio run -t upload --upload-port COM3
```

### 3. Monitor Serial Output
```bash
# Open serial monitor
pio device monitor

# Or combine upload and monitor
pio run -t upload && pio device monitor
```

### 4. Clean Build
```bash
pio run -t clean
```

---

## PlatformIO Commands Reference

### Build Commands
```bash
pio run                    # Build project
pio run -e esp32dev        # Build specific environment
pio run -t upload          # Build and upload
pio run -t clean           # Clean build files
pio run -t monitor         # Open serial monitor
```

### Device Commands
```bash
pio device list            # List connected devices
pio device monitor         # Open serial monitor
pio device monitor -b 115200  # Monitor with specific baud rate
```

### Library Management
```bash
pio lib list               # List installed libraries
pio lib search "library"   # Search for libraries
pio lib install "library"  # Install library
pio lib update             # Update all libraries
```

### Project Commands
```bash
pio project init           # Initialize new project
pio project config         # Show project configuration
```

---

## Troubleshooting

### Issue: PlatformIO not found
**Solution:**
```powershell
# Add to PATH (Windows)
$env:Path += ";C:\Users\YourUsername\.platformio\penv\Scripts"

# Or reinstall
pip install --upgrade platformio
```

### Issue: USB driver not found
**Solution:**
- Install CP210x USB to UART Bridge VCP Drivers
- Download from: https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers

### Issue: Permission denied on Linux
**Solution:**
```bash
# Add user to dialout group
sudo usermod -a -G dialout $USER
# Logout and login again
```

### Issue: Upload fails
**Solution:**
1. Hold BOOT button on ESP32
2. Run upload command
3. Release BOOT button when upload starts

---

## Current Project Configuration

Your `platformio.ini` is configured with:

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200

build_flags = 
    -DCORE_DEBUG_LEVEL=3
    -DBOARD_HAS_PSRAM
    -mfix-esp32-psram-cache-issue

lib_deps = 
    bodmer/TFT_eSPI@^2.5.43
    greiman/SdFat@^2.2.2
```

### Required Libraries
- **TFT_eSPI** - Display driver (version ^2.5.43)
- **SdFat** - SD card support (version ^2.2.2)

---

## Next Steps

1. **Install PlatformIO**
   ```powershell
   pip install platformio
   ```

2. **Verify Installation**
   ```bash
   pio --version
   ```

3. **Build Project**
   ```bash
   cd "C:\Users\taha\Desktop\NES on ESP 32"
   pio run
   ```

4. **Connect ESP32 and Upload**
   ```bash
   pio run -t upload
   ```

5. **Monitor Output**
   ```bash
   pio device monitor
   ```

---

## Expected Output

When you run the project, you should see:
```
NES Emulator on ESP32
Initializing...
Initialization complete
Waiting for ROM file...
Ready!
```

---

## Hardware Setup Required

### ESP32 Connections
- **Display (TFT):** Connect via SPI
- **SD Card:** Connect via SPI
- **Power:** USB or external 3.3V/5V

### Pin Configuration
You'll need to configure TFT_eSPI pins in:
`C:\Users\YourUsername\.platformio\lib\TFT_eSPI\User_Setup.h`

Or create `platformio_override.ini` with custom pins.

---

## Alternative: Use PlatformIO IDE

If command-line isn't preferred:

1. Open VS Code
2. Install PlatformIO IDE extension
3. Open project folder
4. Use PlatformIO toolbar:
   - ? Build
   - ? Upload
   - ?? Serial Monitor

---

For detailed configuration, see: https://docs.platformio.org/
