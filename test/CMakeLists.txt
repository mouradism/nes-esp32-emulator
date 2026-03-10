# Test executable
add_executable(nes_tests
    test_cpu_6502.cpp
    test_ppu.cpp
    test_nes.cpp
    test_main.cpp
)

# Link against Google Test and the core library
target_link_libraries(nes_tests
    gtest
    gtest_main
    nes_core
)

# Include directories
target_include_directories(nes_tests PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../include
)

# Discover tests
include(GoogleTest)
gtest_discover_tests(nes_tests)

# Add tests to CTest
add_test(NAME NESEmulatorTests COMMAND nes_tests)
