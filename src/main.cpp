#include <Arduino.h>
#include "nes.h"
#include <TFT_eSPI.h>
#include <SPI.h>

// Display
TFT_eSPI tft = TFT_eSPI();

// NES Instance
NES nes;

// Timing
unsigned long lastFrameTime = 0;
const unsigned long frameInterval = 16667; // ~60 FPS in microseconds

void setup() {
    Serial.begin(115200);
    Serial.println("NES Emulator on ESP32");
    Serial.println("Initializing...");
    
    // Initialize display
    tft.init();
    tft.setRotation(1);
    tft.fillScreen(TFT_BLACK);
    tft.setTextColor(TFT_WHITE, TFT_BLACK);
    tft.setTextSize(2);
    tft.setCursor(20, 100);
    tft.println("NES Emulator");
    tft.setCursor(20, 130);
    tft.println("Initializing...");
    
    // Initialize NES
    nes.reset();
    
    Serial.println("Initialization complete");
    Serial.println("Waiting for ROM file...");
    
    tft.setCursor(20, 160);
    tft.println("Ready!");
    
    delay(2000);
}

void loop() {
    unsigned long currentTime = micros();
    
    // Run emulation for one frame
    if (currentTime - lastFrameTime >= frameInterval) {
        lastFrameTime = currentTime;
        
        // Run NES for one frame worth of cycles
        // NES runs at ~1.79 MHz CPU, ~5.37 MHz PPU
        // One frame = ~29780 CPU cycles
        for (int i = 0; i < 29780; i++) {
            nes.clock();
            
            if (nes.ppu.frameComplete) {
                nes.ppu.frameComplete = false;
                
                // Render frame to display
                // This is a simplified version - actual rendering would need optimization
                // for (int y = 0; y < PPU::SCREEN_HEIGHT; y++) {
                //     for (int x = 0; x < PPU::SCREEN_WIDTH; x++) {
                //         tft.drawPixel(x, y, nes.ppu.frameBuffer[y * PPU::SCREEN_WIDTH + x]);
                //     }
                // }
                
                break;
            }
        }
    }
    
    // Handle input
    // TODO: Read controller inputs
    
    // Small delay to prevent watchdog timeout
    delay(1);
}
