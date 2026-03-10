# Unit Testing

This project uses Google Test framework for unit testing.

## Test Structure

Tests are organized by component:
- `test_cpu_6502.cpp` - Tests for the 6502 CPU emulator
- `test_ppu.cpp` - Tests for the PPU (Picture Processing Unit)
- `test_nes.cpp` - Tests for the main NES system integration
- `test_main.cpp` - Test runner entry point

## Running Tests

### Build and Run All Tests
```bash
mkdir build && cd build
cmake ..
cmake --build .
ctest --output-on-failure
```

### Run Specific Test Suite
```bash
./test/nes_tests --gtest_filter=CPU6502Test.*
./test/nes_tests --gtest_filter=PPUTest.*
./test/nes_tests --gtest_filter=NESTest.*
```

### Run Individual Test
```bash
./test/nes_tests --gtest_filter=CPU6502Test.ResetInitializesRegisters
```

### Verbose Output
```bash
./test/nes_tests --gtest_verbose
```

## Writing New Tests

### Test Fixture Template
```cpp
#include <gtest/gtest.h>
#include "your_header.h"

class YourComponentTest : public ::testing::Test {
protected:
    YourComponent component;
    
    void SetUp() override {
        // Initialize before each test
        component.reset();
    }
    
    void TearDown() override {
        // Cleanup after each test
    }
};

TEST_F(YourComponentTest, TestName) {
    // Arrange
    component.setSomeValue(42);
    
    // Act
    int result = component.getSomeValue();
    
    // Assert
    EXPECT_EQ(result, 42);
}
```

## Test Coverage

Current test coverage includes:
- ? CPU register initialization
- ? CPU status flags
- ? CPU addressing modes (basic)
- ? PPU initialization
- ? PPU frame timing
- ? PPU memory access
- ? NES system initialization
- ? Memory mapping and mirroring
- ? CPU/PPU clock synchronization

## Future Test Areas

- [ ] Complete CPU opcode implementations
- [ ] CPU instruction execution timing
- [ ] PPU rendering logic
- [ ] PPU sprite evaluation
- [ ] Cartridge mapper logic
- [ ] APU functionality
- [ ] Controller input
- [ ] Save state functionality

## Continuous Integration

The tests can be integrated into CI/CD pipelines:

### GitHub Actions Example
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Configure
      run: cmake -B build
    - name: Build
      run: cmake --build build
    - name: Test
      run: cd build && ctest --output-on-failure
```

## Test Assertions

Common Google Test assertions:
- `EXPECT_EQ(a, b)` - a equals b
- `EXPECT_NE(a, b)` - a not equals b
- `EXPECT_LT(a, b)` - a less than b
- `EXPECT_GT(a, b)` - a greater than b
- `EXPECT_TRUE(condition)` - condition is true
- `EXPECT_FALSE(condition)` - condition is false
- `ASSERT_*` variants - same as EXPECT but stops test on failure
