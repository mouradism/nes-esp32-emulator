# Unit Tests

This directory contains unit tests for the NES emulator components.

## Test Files

- **test_cpu_6502.cpp** - Tests for 6502 CPU emulation
  - Register initialization
  - Status flags
  - Addressing modes
  - Instruction execution

- **test_ppu.cpp** - Tests for Picture Processing Unit
  - Frame timing
  - Memory access (nametables, palettes)
  - Register operations
  - Rendering logic

- **test_nes.cpp** - Tests for NES system integration
  - Memory mapping
  - RAM mirroring
  - Component synchronization
  - CPU/PPU clock coordination

- **test_main.cpp** - Test runner entry point

## Building and Running

See the main [QUICKSTART.md](../QUICKSTART.md) or [docs/TESTING.md](../docs/TESTING.md) for instructions.

## Quick Run

```bash
# From project root
mkdir build && cd build
cmake ..
cmake --build .
ctest --output-on-failure
```

## Writing Tests

Example test structure:

```cpp
#include <gtest/gtest.h>
#include "your_component.h"

TEST(ComponentTest, TestName) {
    // Arrange
    Component component;
    
    // Act
    component.doSomething();
    
    // Assert
    EXPECT_EQ(component.getValue(), expected);
}
```

See [Google Test Primer](https://google.github.io/googletest/primer.html) for more information.
