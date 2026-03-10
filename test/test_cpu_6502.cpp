#include <gtest/gtest.h>
#include "cpu_6502.h"

class CPU6502Test : public ::testing::Test {
protected:
    CPU6502 cpu;
    
    void SetUp() override {
        cpu.reset();
    }
    
    void TearDown() override {
        // Cleanup if needed
    }
};

TEST_F(CPU6502Test, ResetInitializesRegisters) {
    EXPECT_EQ(cpu.A, 0x00);
    EXPECT_EQ(cpu.X, 0x00);
    EXPECT_EQ(cpu.Y, 0x00);
    EXPECT_EQ(cpu.SP, 0xFD);
    EXPECT_EQ(cpu.status & FLAG_UNUSED, FLAG_UNUSED);
}

TEST_F(CPU6502Test, CycleCounterIncrementsOnClock) {
    uint32_t initialCycles = cpu.cycles;
    cpu.clock();
    EXPECT_GT(cpu.cycles, initialCycles);
}

TEST_F(CPU6502Test, StatusFlagsCarry) {
    cpu.status = 0x00;
    cpu.status |= FLAG_CARRY;
    EXPECT_TRUE(cpu.status & FLAG_CARRY);
    
    cpu.status &= ~FLAG_CARRY;
    EXPECT_FALSE(cpu.status & FLAG_CARRY);
}

TEST_F(CPU6502Test, StatusFlagsZero) {
    cpu.status = 0x00;
    cpu.status |= FLAG_ZERO;
    EXPECT_TRUE(cpu.status & FLAG_ZERO);
    
    cpu.status &= ~FLAG_ZERO;
    EXPECT_FALSE(cpu.status & FLAG_ZERO);
}

TEST_F(CPU6502Test, StatusFlagsNegative) {
    cpu.status = 0x00;
    cpu.status |= FLAG_NEGATIVE;
    EXPECT_TRUE(cpu.status & FLAG_NEGATIVE);
    
    cpu.status &= ~FLAG_NEGATIVE;
    EXPECT_FALSE(cpu.status & FLAG_NEGATIVE);
}

TEST_F(CPU6502Test, StatusFlagsOverflow) {
    cpu.status = 0x00;
    cpu.status |= FLAG_OVERFLOW;
    EXPECT_TRUE(cpu.status & FLAG_OVERFLOW);
    
    cpu.status &= ~FLAG_OVERFLOW;
    EXPECT_FALSE(cpu.status & FLAG_OVERFLOW);
}

TEST_F(CPU6502Test, StackPointerInitialization) {
    EXPECT_EQ(cpu.SP, 0xFD);
}

TEST_F(CPU6502Test, ProgramCounterInitialization) {
    // PC should be set from reset vector, but since we don't have memory connected
    // it will be 0x0000 (from read returning 0x00)
    EXPECT_EQ(cpu.PC, 0x0000);
}

TEST_F(CPU6502Test, IsCompleteReturnsTrueWhenCyclesFinish) {
    // Clock until instruction completes
    while (!cpu.isComplete()) {
        cpu.clock();
    }
    EXPECT_TRUE(cpu.isComplete());
}

TEST_F(CPU6502Test, RegistersArePubliclyAccessible) {
    // Test that we can read and write public registers
    cpu.A = 0x42;
    EXPECT_EQ(cpu.A, 0x42);
    
    cpu.X = 0x55;
    EXPECT_EQ(cpu.X, 0x55);
    
    cpu.Y = 0xAA;
    EXPECT_EQ(cpu.Y, 0xAA);
    
    cpu.SP = 0xFF;
    EXPECT_EQ(cpu.SP, 0xFF);
}
