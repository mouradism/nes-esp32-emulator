# NES Emulator ESP32 - Build and Test Script
# Windows PowerShell Script

Write-Host "NES Emulator on ESP32 - Build and Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if CMake is installed
$cmake = Get-Command cmake -ErrorAction SilentlyContinue
if (-not $cmake) {
    Write-Host "ERROR: CMake is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install CMake from: https://cmake.org/download/" -ForegroundColor Yellow
    exit 1
}

Write-Host "CMake found: $($cmake.Version)" -ForegroundColor Green
Write-Host ""

# Create build directory
if (Test-Path "build") {
    Write-Host "Cleaning existing build directory..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "build"
}

Write-Host "Creating build directory..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path "build" | Out-Null
Set-Location "build"

# Configure
Write-Host ""
Write-Host "Configuring project with CMake..." -ForegroundColor Cyan
cmake .. -DBUILD_TESTS=ON -DBUILD_ESP32=OFF
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: CMake configuration failed" -ForegroundColor Red
    Set-Location ..
    exit 1
}

# Build
Write-Host ""
Write-Host "Building project..." -ForegroundColor Cyan
cmake --build . --config Debug
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Build failed" -ForegroundColor Red
    Set-Location ..
    exit 1
}

# Run tests
Write-Host ""
Write-Host "Running tests..." -ForegroundColor Cyan
ctest -C Debug --output-on-failure --verbose
if ($LASTEXITCODE -ne 0) {
    Write-Host "WARNING: Some tests failed" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "All tests passed!" -ForegroundColor Green
}

Set-Location ..

Write-Host ""
Write-Host "Build complete!" -ForegroundColor Green
Write-Host "Test executable location: build/test/Debug/nes_tests.exe" -ForegroundColor Cyan
Write-Host ""
Write-Host "To run tests again:" -ForegroundColor Yellow
Write-Host "  cd build" -ForegroundColor Gray
Write-Host "  ctest -C Debug --output-on-failure" -ForegroundColor Gray
Write-Host ""
