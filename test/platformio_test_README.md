# PlatformIO Test Environment Configuration

This directory can contain multiple environment configurations for different ESP32 boards and setups.

## Available Environments

### esp32dev (Default)
Standard ESP32-WROOM-32 development board
- 240 MHz CPU
- 520KB RAM
- 4MB Flash
- PSRAM support

### Custom Environments

You can add custom environments in `platformio.ini`:

```ini
[env:esp32_custom]
platform = espressif32
board = esp32dev
framework = arduino
board_build.partitions = min_spiffs.csv
build_flags = 
    -DCUSTOM_CONFIG
    ${env:esp32dev.build_flags}
```

## Testing on Hardware

### 1. Check Connected Devices
```bash
pio device list
```

### 2. Upload and Monitor
```bash
pio run -t upload && pio device monitor
```

### 3. Debug Output
Set `CORE_DEBUG_LEVEL` in `platformio.ini`:
- 0 = None
- 1 = Error
- 2 = Warning
- 3 = Info
- 4 = Debug
- 5 = Verbose

## Performance Testing

### Frame Rate Test
Monitor serial output for:
- Frame rendering time
- CPU usage
- Memory usage

### Expected Performance
- Target: 60 FPS (16.67ms per frame)
- CPU cycles per frame: ~29,780
- PPU cycles per frame: ~89,340

## Hardware Requirements

- ESP32 board with PSRAM (recommended)
- ILI9341 or similar SPI TFT display
- SD card module (for ROM storage)
- USB cable for programming

## Pin Connections

See `lib/TFT_eSPI_Config.h` for pin definitions.

Default pins:
- SPI MOSI: GPIO 23
- SPI MISO: GPIO 19
- SPI CLK: GPIO 18
- TFT CS: GPIO 15
- TFT DC: GPIO 2
- TFT RST: GPIO 4
