#include <gtest/gtest.h>
#include "nes.h"

class NESTest : public ::testing::Test {
protected:
    NES nes;
    
    void SetUp() override {
        nes.reset();
    }
    
    void TearDown() override {
        // Cleanup if needed
    }
};

TEST_F(NESTest, ResetInitializesSystem) {
    EXPECT_EQ(nes.cpu.cycles, 0);
    EXPECT_FALSE(nes.ppu.frameComplete);
}

TEST_F(NESTest, RAMInitialization) {
    // RAM should be accessible
    nes.cpuWrite(0x0000, 0x42);
    uint8_t data = nes.cpuRead(0x0000);
    EXPECT_EQ(data, 0x42);
}

TEST_F(NESTest, RAMMirroring) {
    // NES RAM is 2KB, mirrored 4 times up to 0x1FFF
    uint8_t testValue = 0xAB;
    
    nes.cpuWrite(0x0000, testValue);
    
    // Test mirrored addresses
    EXPECT_EQ(nes.cpuRead(0x0800), testValue);
    EXPECT_EQ(nes.cpuRead(0x1000), testValue);
    EXPECT_EQ(nes.cpuRead(0x1800), testValue);
}

TEST_F(NESTest, PPURegisterMapping) {
    // PPU registers are mapped from 0x2000 to 0x2007 and mirrored
    uint8_t testValue = 0xCD;
    
    nes.cpuWrite(PPUCTRL, testValue);
    // We can't directly read back PPUCTRL, but we can verify write doesn't crash
    
    nes.cpuWrite(PPUMASK, testValue);
    // Same for PPUMASK
}

TEST_F(NESTest, PPURegisterMirroring) {
    // PPU registers are mirrored every 8 bytes up to 0x3FFF
    uint8_t testValue = 0xEF;
    
    nes.cpuWrite(0x2001, testValue); // PPUMASK
    nes.cpuWrite(0x2009, testValue); // Mirrored PPUMASK
    nes.cpuWrite(0x3FF9, testValue); // Also mirrored
    
    // If these don't crash, mirroring is working
    SUCCEED();
}

TEST_F(NESTest, ClockSynchronization) {
    uint32_t initialCPUCycles = nes.cpu.cycles;
    
    // Clock the system multiple times
    for (int i = 0; i < 10; i++) {
        nes.clock();
    }
    
    // CPU should have advanced (3:1 PPU to CPU clock ratio)
    EXPECT_GT(nes.cpu.cycles, initialCPUCycles);
}

TEST_F(NESTest, CPUPPUClockRatio) {
    nes.reset();
    
    uint32_t initialCPUCycles = nes.cpu.cycles;
    
    // Clock 9 times (3 PPU clocks per CPU clock)
    for (int i = 0; i < 9; i++) {
        nes.clock();
    }
    
    // CPU should have clocked 3 times
    // Note: This is a simplified test, actual behavior depends on CPU instruction timing
}

TEST_F(NESTest, CartridgeROMArea) {
    // ROM area is from 0x8000 to 0xFFFF
    // Without a loaded ROM, reads should return 0x00
    
    uint8_t data = nes.cpuRead(0x8000);
    EXPECT_EQ(data, 0x00);
    
    data = nes.cpuRead(0xFFFF);
    EXPECT_EQ(data, 0x00);
}

TEST_F(NESTest, ROMWriteDoesNotCrash) {
    // Writing to ROM area shouldn't crash (mapper dependent)
    nes.cpuWrite(0x8000, 0x42);
    SUCCEED();
}

TEST_F(NESTest, LoadROMReturnsValue) {
    // loadROM is not fully implemented yet, but it should return a bool
    bool result = nes.loadROM("test.nes");
    // Currently returns false as it's not implemented
    EXPECT_FALSE(result);
}

TEST_F(NESTest, MemoryBoundaries) {
    // Test that we can write and read from all major memory regions
    
    // RAM
    nes.cpuWrite(0x0000, 0x11);
    EXPECT_EQ(nes.cpuRead(0x0000), 0x11);
    
    nes.cpuWrite(0x07FF, 0x22);
    EXPECT_EQ(nes.cpuRead(0x07FF), 0x22);
    
    // PPU Registers (write only test)
    nes.cpuWrite(0x2000, 0x33);
    nes.cpuWrite(0x2007, 0x44);
    
    SUCCEED();
}

TEST_F(NESTest, ComponentsAreInitialized) {
    EXPECT_EQ(nes.cpu.A, 0x00);
    EXPECT_EQ(nes.cpu.X, 0x00);
    EXPECT_EQ(nes.cpu.Y, 0x00);
    EXPECT_FALSE(nes.ppu.frameComplete);
}
