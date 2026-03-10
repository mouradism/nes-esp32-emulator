# Contributing to NES Emulator on ESP32

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Development Setup

1. Fork and clone the repository
2. Install required tools:
   - CMake 3.16+
   - C++11 compatible compiler
   - PlatformIO (for ESP32 development)
3. Build and run tests to verify setup:
   ```bash
   ./scripts/build_and_test.sh  # Linux/macOS
   .\scripts\build_and_test.ps1  # Windows
   ```

## Coding Standards

### C++ Style
- Use 4 spaces for indentation (no tabs)
- Follow existing code style in the project
- Use meaningful variable and function names
- Keep functions focused and concise

### File Organization
- Header files in `include/`
- Implementation files in `src/`
- Test files in `test/`
- Each class should have its own .h and .cpp file

### Comments
- Use comments to explain "why", not "what"
- Document public APIs
- Keep comments up to date with code changes

## Testing Requirements

**All contributions must include appropriate tests.**

### When to Write Tests
- ? New features must include tests
- ? Bug fixes should include a test that would have caught the bug
- ? Refactoring should maintain existing test coverage

### Running Tests
```bash
# Run all tests
ctest --output-on-failure

# Run specific test suite
./build/test/nes_tests --gtest_filter=CPU6502Test.*

# Run with verbose output
ctest --verbose
```

### Writing Tests
```cpp
#include <gtest/gtest.h>

class MyComponentTest : public ::testing::Test {
protected:
    void SetUp() override {
        // Setup before each test
    }
    
    void TearDown() override {
        // Cleanup after each test
    }
};

TEST_F(MyComponentTest, DescriptiveTestName) {
    // Arrange - set up test data
    
    // Act - perform the action
    
    // Assert - verify results
    EXPECT_EQ(actual, expected);
}
```

## Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write clean, readable code
   - Follow coding standards
   - Add/update tests

3. **Ensure tests pass**
   ```bash
   cmake --build build
   ctest --test-dir build --output-on-failure
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add feature: descriptive message"
   ```
   
   Commit message format:
   - Start with a verb (Add, Fix, Update, Remove, etc.)
   - Keep first line under 50 characters
   - Add detailed description if needed

5. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   - Create pull request on GitHub
   - Provide clear description of changes
   - Reference any related issues

6. **Code Review**
   - Address review comments
   - Keep the PR up to date with main branch
   - Ensure CI checks pass

## Areas for Contribution

### High Priority
- [ ] Complete CPU opcode implementations
- [ ] PPU rendering optimization
- [ ] ROM loader (iNES format)
- [ ] Controller input handling
- [ ] Mapper support (starting with Mapper 0)

### Medium Priority
- [ ] APU (Audio Processing Unit) implementation
- [ ] Save state functionality
- [ ] Performance optimizations
- [ ] Additional mapper support

### Nice to Have
- [ ] Debugging tools
- [ ] Performance profiling
- [ ] Documentation improvements
- [ ] Example ROM projects

## Testing Guidelines

### Unit Tests
- Test individual components in isolation
- Mock dependencies when necessary
- Test edge cases and error conditions
- Aim for high code coverage

### Integration Tests
- Test component interactions
- Test memory mapping
- Test timing synchronization

### Hardware Tests
- Test on actual ESP32 hardware
- Verify display output
- Test performance on target hardware

## Questions?

- Open an issue for bugs or feature requests
- Start a discussion for design questions
- Check existing issues/PRs before creating new ones

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Help others learn and grow

Thank you for contributing! ??
