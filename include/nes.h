#ifndef NES_H
#define NES_H

#include "cpu_6502.h"
#include "ppu.h"
#include <stdint.h>

class NES {
public:
    NES();
    void reset();
    void clock();
    bool loadROM(const char* filename);
    
    // Components
    CPU6502 cpu;
    PPU ppu;
    
    // RAM
    uint8_t ram[2048];
    
    // Memory bus access
    uint8_t cpuRead(uint16_t addr);
    void cpuWrite(uint16_t addr, uint8_t data);
    
private:
    // ROM data
    uint8_t* prgROM;
    uint8_t* chrROM;
    uint32_t prgROMSize;
    uint32_t chrROMSize;
    
    // Mapper
    uint8_t mapperID;
    
    // Cycle synchronization
    uint32_t systemClock;
};

#endif // NES_H
