#ifndef PPU_H
#define PPU_H

#include <stdint.h>

// PPU Registers
#define PPUCTRL   0x2000
#define PPUMASK   0x2001
#define PPUSTATUS 0x2002
#define OAMADDR   0x2003
#define OAMDATA   0x2004
#define PPUSCROLL 0x2005
#define PPUADDR   0x2006
#define PPUDATA   0x2007

class PPU {
public:
    PPU();
    ~PPU();
    void reset();
    void clock();
    
    // Screen dimensions
    static const int SCREEN_WIDTH = 256;
    static const int SCREEN_HEIGHT = 240;
    
    // Frame buffer (allocated dynamically, in PSRAM on ESP32)
    uint16_t* frameBuffer;
    
    // Frame complete flag
    bool frameComplete;
    
    // PPU Registers
    uint8_t readRegister(uint16_t addr);
    void writeRegister(uint16_t addr, uint8_t data);
    
private:
    // Internal registers
    uint8_t ctrl;
    uint8_t mask;
    uint8_t status;
    uint8_t oamAddr;
    
    // Internal memory
    uint8_t nameTable[2][1024];
    uint8_t paletteTable[32];
    uint8_t oam[256];
    
    // Counters
    int16_t scanline;
    int16_t cycle;
    
    // Background rendering
    void renderBackground();
    void renderSprites();
    
    // Memory access
    uint8_t ppuRead(uint16_t addr);
    void ppuWrite(uint16_t addr, uint8_t data);
};

#endif // PPU_H
