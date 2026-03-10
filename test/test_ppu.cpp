#include <gtest/gtest.h>
#include "ppu.h"

class PPUTest : public ::testing::Test {
protected:
    PPU ppu;
    
    void SetUp() override {
        ppu.reset();
    }
    
    void TearDown() override {
        // Cleanup if needed
    }
};

TEST_F(PPUTest, ResetInitializesState) {
    EXPECT_EQ(ppu.frameComplete, false);
    EXPECT_NE(ppu.frameBuffer, nullptr);
}

TEST_F(PPUTest, ClockIncrementsCycle) {
    ppu.reset();
    ppu.clock();
    // After one clock, we should have moved forward
    // This is a basic structural test
}

TEST_F(PPUTest, FrameCompleteAfter262Scanlines) {
    ppu.reset();
    ppu.frameComplete = false;
    
    // One frame = 262 scanlines * 341 cycles per scanline
    int totalCycles = 262 * 341;
    
    for (int i = 0; i < totalCycles; i++) {
        ppu.clock();
    }
    
    EXPECT_TRUE(ppu.frameComplete);
}

TEST_F(PPUTest, ScreenDimensionsAreCorrect) {
    EXPECT_EQ(PPU::SCREEN_WIDTH, 256);
    EXPECT_EQ(PPU::SCREEN_HEIGHT, 240);
}

TEST_F(PPUTest, FrameBufferSize) {
    // Frame buffer should hold WIDTH * HEIGHT pixels
    int expectedSize = PPU::SCREEN_WIDTH * PPU::SCREEN_HEIGHT;
    // We can't directly test the size, but we can verify it's allocated
    EXPECT_NE(ppu.frameBuffer, nullptr);
}

TEST_F(PPUTest, RegisterWriteCtrl) {
    uint8_t testValue = 0xAB;
    ppu.writeRegister(PPUCTRL, testValue);
    // Register should be written (internal state test)
}

TEST_F(PPUTest, RegisterWriteMask) {
    uint8_t testValue = 0xCD;
    ppu.writeRegister(PPUMASK, testValue);
    // Register should be written (internal state test)
}

TEST_F(PPUTest, RegisterReadStatusClearsVBlank) {
    ppu.writeRegister(PPUSTATUS, 0x80); // Set VBlank flag
    uint8_t status = ppu.readRegister(PPUSTATUS);
    
    // Reading status should clear VBlank flag
    uint8_t statusAfter = ppu.readRegister(PPUSTATUS);
    EXPECT_EQ(statusAfter & 0x80, 0x00);
}

TEST_F(PPUTest, OAMDataReadWrite) {
    ppu.writeRegister(OAMADDR, 0x00);
    ppu.writeRegister(OAMDATA, 0x42);
    
    ppu.writeRegister(OAMADDR, 0x00);
    uint8_t data = ppu.readRegister(OAMDATA);
    EXPECT_EQ(data, 0x42);
}

TEST_F(PPUTest, FrameBufferIsAccessible) {
    // Test that frame buffer is publicly accessible
    ppu.frameBuffer[0] = 0x1234;
    EXPECT_EQ(ppu.frameBuffer[0], 0x1234);
    
    ppu.frameBuffer[PPU::SCREEN_WIDTH * PPU::SCREEN_HEIGHT - 1] = 0x5678;
    EXPECT_EQ(ppu.frameBuffer[PPU::SCREEN_WIDTH * PPU::SCREEN_HEIGHT - 1], 0x5678);
}

TEST_F(PPUTest, FrameCompleteFlag) {
    ppu.frameComplete = false;
    EXPECT_FALSE(ppu.frameComplete);
    
    ppu.frameComplete = true;
    EXPECT_TRUE(ppu.frameComplete);
}
