#include "ppu.h"
#include <cstring>

#ifdef ESP32
#include <esp_heap_caps.h>
#endif

PPU::PPU() {
    // Allocate frame buffer in PSRAM on ESP32
    #ifdef ESP32
    frameBuffer = (uint16_t*)heap_caps_malloc(SCREEN_WIDTH * SCREEN_HEIGHT * sizeof(uint16_t), MALLOC_CAP_SPIRAM);
    if (frameBuffer == nullptr) {
        // Fallback to regular RAM if PSRAM not available
        frameBuffer = new uint16_t[SCREEN_WIDTH * SCREEN_HEIGHT];
    }
    #else
    frameBuffer = new uint16_t[SCREEN_WIDTH * SCREEN_HEIGHT];
    #endif
    
    reset();
}

PPU::~PPU() {
    #ifdef ESP32
    if (frameBuffer) {
        heap_caps_free(frameBuffer);
    }
    #else
    delete[] frameBuffer;
    #endif
}

void PPU::reset() {
    ctrl = 0x00;
    mask = 0x00;
    status = 0x00;
    oamAddr = 0x00;
    
    scanline = 0;
    cycle = 0;
    frameComplete = false;
    
    memset(nameTable, 0, sizeof(nameTable));
    memset(paletteTable, 0, sizeof(paletteTable));
    memset(oam, 0, sizeof(oam));
    
    if (frameBuffer) {
        memset(frameBuffer, 0, SCREEN_WIDTH * SCREEN_HEIGHT * sizeof(uint16_t));
    }
}

void PPU::clock() {
    // PPU runs 3 times faster than CPU
    cycle++;
    
    if (cycle >= 341) {
        cycle = 0;
        scanline++;
        
        if (scanline >= 261) {
            scanline = -1;
            frameComplete = true;
        }
    }
}

uint8_t PPU::readRegister(uint16_t addr) {
    uint8_t data = 0x00;
    
    switch (addr) {
        case PPUSTATUS:
            data = status;
            status &= 0x7F; // Clear VBlank flag
            break;
        case OAMDATA:
            data = oam[oamAddr];
            break;
        case PPUDATA:
            // Read from PPU memory
            break;
    }
    
    return data;
}

void PPU::writeRegister(uint16_t addr, uint8_t data) {
    switch (addr) {
        case PPUCTRL:
            ctrl = data;
            break;
        case PPUMASK:
            mask = data;
            break;
        case OAMADDR:
            oamAddr = data;
            break;
        case OAMDATA:
            oam[oamAddr++] = data;
            break;
        case PPUSCROLL:
            // Handle scroll
            break;
        case PPUADDR:
            // Handle address
            break;
        case PPUDATA:
            // Write to PPU memory
            break;
    }
}

uint8_t PPU::ppuRead(uint16_t addr) {
    addr &= 0x3FFF;
    
    if (addr >= 0x0000 && addr <= 0x1FFF) {
        // CHR ROM/RAM
        return 0x00;
    } else if (addr >= 0x2000 && addr <= 0x3EFF) {
        // Name tables
        addr &= 0x0FFF;
        return nameTable[addr / 0x400][addr % 0x400];
    } else if (addr >= 0x3F00 && addr <= 0x3FFF) {
        // Palette
        addr &= 0x001F;
        return paletteTable[addr];
    }
    
    return 0x00;
}

void PPU::ppuWrite(uint16_t addr, uint8_t data) {
    addr &= 0x3FFF;
    
    if (addr >= 0x0000 && addr <= 0x1FFF) {
        // CHR ROM/RAM
    } else if (addr >= 0x2000 && addr <= 0x3EFF) {
        // Name tables
        addr &= 0x0FFF;
        nameTable[addr / 0x400][addr % 0x400] = data;
    } else if (addr >= 0x3F00 && addr <= 0x3FFF) {
        // Palette
        addr &= 0x001F;
        paletteTable[addr] = data;
    }
}

void PPU::renderBackground() {
    // Placeholder for background rendering
}

void PPU::renderSprites() {
    // Placeholder for sprite rendering
}
