#include <gtest/gtest.h>

// Main entry point for tests
// Google Test will handle the rest
int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
