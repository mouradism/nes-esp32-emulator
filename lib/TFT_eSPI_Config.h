// User Setup for TFT_eSPI library
// This file should be placed in: lib/TFT_eSPI/User_Setup.h
// Or configure these settings in your main project

// ##################################################################################
//
// ESP32 NES Emulator - TFT Display Configuration
//
// ##################################################################################

// Define the display driver
#define ILI9341_DRIVER      // ILI9341 240x320 display (common TFT)
// #define ST7735_DRIVER    // Alternative: ST7735 128x160 display
// #define ILI9488_DRIVER   // Alternative: ILI9488 320x480 display

// ESP32 Pin Configuration
#define TFT_MISO 19
#define TFT_MOSI 23
#define TFT_SCLK 18
#define TFT_CS   15  // Chip select control pin
#define TFT_DC    2  // Data Command control pin
#define TFT_RST   4  // Reset pin (could connect to RST pin)
// #define TFT_BL   22  // LED back-light control pin (optional)

// For ESP32 use hardware SPI
#define SPI_FREQUENCY  27000000  // 27MHz (safe speed)
#define SPI_READ_FREQUENCY  20000000
#define SPI_TOUCH_FREQUENCY  2500000

// Optional: Use PSRAM for larger frame buffers
#define USE_DMA_TO_TFT

// Font settings
#define LOAD_GLCD   // Font 1. Original Adafruit 8 pixel font needs ~1820 bytes in FLASH
#define LOAD_FONT2  // Font 2. Small 16 pixel high font, needs ~3534 bytes in FLASH
#define LOAD_FONT4  // Font 4. Medium 26 pixel high font, needs ~5848 bytes in FLASH
#define LOAD_FONT6  // Font 6. Large 48 pixel font, needs ~2666 bytes in FLASH
#define LOAD_FONT7  // Font 7. 7 segment 48 pixel font, needs ~2438 bytes in FLASH
#define LOAD_FONT8  // Font 8. Large 75 pixel font needs ~3256 bytes in FLASH
#define LOAD_GFXFF  // FreeFonts

#define SMOOTH_FONT

// NES Display Settings (256x240)
// The NES output will be scaled to fit the display
// For 320x240 displays (ILI9341 rotated), NES output fits nicely with some scaling

// Color depth (16-bit RGB565 is standard for most TFT displays)
#define TFT_RGB_ORDER TFT_RGB  // Colour order Red-Green-Blue
// #define TFT_RGB_ORDER TFT_BGR  // Alternative: Blue-Green-Red

// ##################################################################################
// End of User Setup
// ##################################################################################
