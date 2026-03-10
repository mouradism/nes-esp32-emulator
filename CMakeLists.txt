cmake_minimum_required(VERSION 3.16)

# Project configuration
project(NES_Emulator_ESP32 VERSION 1.0.0 LANGUAGES CXX C)

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 99)

# Build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

# Options
option(BUILD_TESTS "Build unit tests" ON)
option(BUILD_ESP32 "Build for ESP32 target" OFF)

# Include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Source files for the core emulator (platform-independent)
set(CORE_SOURCES
    src/cpu_6502.cpp
    src/ppu.cpp
    src/nes.cpp
)

set(CORE_HEADERS
    include/cpu_6502.h
    include/ppu.h
    include/nes.h
)

# Create core library (for testing)
add_library(nes_core STATIC ${CORE_SOURCES} ${CORE_HEADERS})
target_include_directories(nes_core PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

# ESP32 build
if(BUILD_ESP32)
    # This section is for ESP-IDF native build
    # For PlatformIO, use platformio.ini instead
    message(STATUS "Building for ESP32 target")
    
    # ESP32 specific sources
    set(ESP32_SOURCES
        src/main.cpp
        ${CORE_SOURCES}
    )
    
    # This would integrate with ESP-IDF
    # idf_component_register(SRCS ${ESP32_SOURCES} INCLUDE_DIRS "include")
else()
    message(STATUS "Building for host (testing/development)")
endif()

# Unit Tests
if(BUILD_TESTS AND NOT BUILD_ESP32)
    enable_testing()
    
    # Download and configure Google Test
    include(FetchContent)
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG release-1.12.1
    )
    
    # For Windows: Prevent overriding the parent project's compiler/linker settings
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)
    
    # Add test subdirectory
    add_subdirectory(test)
    
    message(STATUS "Unit tests enabled")
endif()

# Installation
install(TARGETS nes_core
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(DIRECTORY include/
    DESTINATION include
    FILES_MATCHING PATTERN "*.h"
)
