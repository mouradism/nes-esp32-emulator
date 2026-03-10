#include "nes.h"
#include <cstring>

NES::NES() : prgROM(nullptr), chrROM(nullptr), prgROMSize(0), chrROMSize(0), mapperID(0), systemClock(0) {
    memset(ram, 0, sizeof(ram));
}

void NES::reset() {
    cpu.reset();
    ppu.reset();
    systemClock = 0;
}

void NES::clock() {
    // PPU runs 3 times faster than CPU
    ppu.clock();
    
    if (systemClock % 3 == 0) {
        cpu.clock();
    }
    
    systemClock++;
}

bool NES::loadROM(const char* filename) {
    // Placeholder for ROM loading
    // This will read .nes file format (iNES)
    // Format: 16-byte header + PRG ROM + CHR ROM
    return false;
}

uint8_t NES::cpuRead(uint16_t addr) {
    if (addr >= 0x0000 && addr <= 0x1FFF) {
        // RAM (2KB, mirrored 4 times)
        return ram[addr & 0x07FF];
    } else if (addr >= 0x2000 && addr <= 0x3FFF) {
        // PPU registers (mirrored)
        return ppu.readRegister(0x2000 + (addr & 0x0007));
    } else if (addr >= 0x8000 && addr <= 0xFFFF) {
        // Cartridge ROM
        if (prgROM != nullptr) {
            addr -= 0x8000;
            if (prgROMSize == 16384) {
                // 16KB, mirrored
                return prgROM[addr & 0x3FFF];
            } else {
                // 32KB
                return prgROM[addr];
            }
        }
    }
    
    return 0x00;
}

void NES::cpuWrite(uint16_t addr, uint8_t data) {
    if (addr >= 0x0000 && addr <= 0x1FFF) {
        // RAM (2KB, mirrored 4 times)
        ram[addr & 0x07FF] = data;
    } else if (addr >= 0x2000 && addr <= 0x3FFF) {
        // PPU registers (mirrored)
        ppu.writeRegister(0x2000 + (addr & 0x0007), data);
    } else if (addr >= 0x8000 && addr <= 0xFFFF) {
        // Cartridge ROM (usually read-only, but mapper may handle writes)
    }
}
