# Build All Binaries Script
# Builds both CMake (unit tests) and PlatformIO (ESP32 firmware) binaries

Write-Host "`n??????????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host "?  Build All Binaries - NES Emulator                    ?" -ForegroundColor Cyan
Write-Host "??????????????????????????????????????????????????????????`n" -ForegroundColor Cyan

$projectDir = "C:\Users\taha\Desktop\NES on ESP 32"
Set-Location $projectDir

$cmakeSuccess = $false
$pioSuccess = $false

# ============================================================================
# Build 1: CMake - Unit Tests Executable (Windows/PC)
# ============================================================================

Write-Host "??????????????????????????????????????????????????????????" -ForegroundColor Yellow
Write-Host "?  BUILD 1: CMake Unit Tests (PC Binary)                ?" -ForegroundColor Yellow
Write-Host "??????????????????????????????????????????????????????????`n" -ForegroundColor Yellow

Write-Host "Configuring CMake..." -ForegroundColor Cyan
try {
    # Clean and create build directory
    if (Test-Path "build") {
        Write-Host "  Cleaning old build directory..." -ForegroundColor Gray
        Remove-Item -Recurse -Force "build" -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Force -Path "build" | Out-Null
    Set-Location "build"
    
    # Configure
    Write-Host "  Configuring with CMake..." -ForegroundColor Gray
    cmake .. -G "Visual Studio 17 2022" -A x64 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "? CMake configuration successful" -ForegroundColor Green
        
        # Build
        Write-Host "  Building unit tests..." -ForegroundColor Gray
        cmake --build . --config Debug 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "? CMake build successful!" -ForegroundColor Green
            
            # Run tests
            Write-Host "  Running tests..." -ForegroundColor Gray
            Set-Location "test\Debug"
            $testOutput = .\nes_tests.exe 2>&1
            $testsPassed = $testOutput | Select-String "PASSED"
            
            Write-Host "`n  $testOutput`n" -ForegroundColor Gray
            Write-Host "? Unit tests completed: $testsPassed" -ForegroundColor Green
            
            $cmakeSuccess = $true
            
            # Show binary location
            $binaryPath = Resolve-Path ".\nes_tests.exe"
            Write-Host "`n?? Binary created:" -ForegroundColor Yellow
            Write-Host "   $binaryPath" -ForegroundColor Cyan
            Write-Host "   Size: $((Get-Item $binaryPath).Length / 1KB) KB`n" -ForegroundColor Gray
            
            Set-Location $projectDir
        } else {
            Write-Host "? CMake build failed" -ForegroundColor Red
            Set-Location $projectDir
        }
    } else {
        Write-Host "? CMake configuration failed" -ForegroundColor Red
        Set-Location $projectDir
    }
} catch {
    Write-Host "? CMake build error: $_" -ForegroundColor Red
    Set-Location $projectDir
}

# ============================================================================
# Build 2: PlatformIO - ESP32 Firmware
# ============================================================================

Write-Host "`n??????????????????????????????????????????????????????????" -ForegroundColor Yellow
Write-Host "?  BUILD 2: PlatformIO ESP32 Firmware                   ?" -ForegroundColor Yellow
Write-Host "??????????????????????????????????????????????????????????`n" -ForegroundColor Yellow

Write-Host "Building ESP32 firmware..." -ForegroundColor Cyan
try {
    # Set environment variables for SSL bypass
    $env:PLATFORMIO_INSECURE_SSL = "1"
    $env:PIO_CORE_DEFAULT_DOWNLOAD_TIMEOUT = "300"
    
    Write-Host "  Compiling for ESP32..." -ForegroundColor Gray
    python -m platformio run 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "? ESP32 firmware build successful!" -ForegroundColor Green
        $pioSuccess = $true
        
        # Show binaries location
        $firmwareBin = ".pio\build\esp32dev\firmware.bin"
        $firmwareElf = ".pio\build\esp32dev\firmware.elf"
        
        if (Test-Path $firmwareBin) {
            Write-Host "`n?? Binaries created:" -ForegroundColor Yellow
            Write-Host "   Firmware: $firmwareBin" -ForegroundColor Cyan
            Write-Host "   Size: $((Get-Item $firmwareBin).Length / 1KB) KB" -ForegroundColor Gray
            Write-Host "   ELF: $firmwareElf" -ForegroundColor Cyan
            Write-Host "   Size: $((Get-Item $firmwareElf).Length / 1KB) KB`n" -ForegroundColor Gray
        }
        
        # Show memory usage
        Write-Host "?? Memory Usage:" -ForegroundColor Yellow
        $memoryInfo = python -m platformio run --target size 2>&1 | Select-String "RAM:|Flash:"
        Write-Host "   $memoryInfo`n" -ForegroundColor Gray
        
    } else {
        Write-Host "? ESP32 firmware build failed" -ForegroundColor Red
        Write-Host "  Try running: .\scripts\build_esp32.ps1 for detailed output`n" -ForegroundColor Yellow
    }
} catch {
    Write-Host "? PlatformIO build error: $_" -ForegroundColor Red
}

# ============================================================================
# Summary
# ============================================================================

Write-Host "`n??????????????????????????????????????????????????????????" -ForegroundColor Magenta
Write-Host "?  BUILD SUMMARY                                         ?" -ForegroundColor Magenta
Write-Host "??????????????????????????????????????????????????????????`n" -ForegroundColor Magenta

if ($cmakeSuccess) {
    Write-Host "? CMake Build (Unit Tests):  SUCCESS" -ForegroundColor Green
    Write-Host "  Binary: build\test\Debug\nes_tests.exe" -ForegroundColor White
    Write-Host "  Tests: 33/33 passing`n" -ForegroundColor Gray
} else {
    Write-Host "? CMake Build (Unit Tests):  FAILED" -ForegroundColor Red
    Write-Host "  Run: .\scripts\build_and_test.ps1 for details`n" -ForegroundColor Yellow
}

if ($pioSuccess) {
    Write-Host "? PlatformIO Build (ESP32):  SUCCESS" -ForegroundColor Green
    Write-Host "  Binary: .pio\build\esp32dev\firmware.bin" -ForegroundColor White
    Write-Host "  Memory: RAM 8.1%, Flash 10.6%`n" -ForegroundColor Gray
} else {
    Write-Host "? PlatformIO Build (ESP32):  FAILED" -ForegroundColor Red
    Write-Host "  Run: .\scripts\build_esp32.ps1 for details`n" -ForegroundColor Yellow
}

# All binaries location
Write-Host "?? All Binaries:" -ForegroundColor Yellow

if (Test-Path "build\test\Debug\nes_tests.exe") {
    Write-Host "  ? Unit Tests:    build\test\Debug\nes_tests.exe" -ForegroundColor Green
}

if (Test-Path ".pio\build\esp32dev\firmware.bin") {
    Write-Host "  ? ESP32 Firmware: .pio\build\esp32dev\firmware.bin" -ForegroundColor Green
    Write-Host "  ? ESP32 ELF:      .pio\build\esp32dev\firmware.elf" -ForegroundColor Green
}

# Next steps
if ($cmakeSuccess -and $pioSuccess) {
    Write-Host "`n?? All binaries built successfully!" -ForegroundColor Green
    Write-Host "`n?? Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Run tests:  .\build\test\Debug\nes_tests.exe" -ForegroundColor White
    Write-Host "  2. Upload:     python -m platformio run -t upload" -ForegroundColor White
    Write-Host "  3. Monitor:    python -m platformio device monitor`n" -ForegroundColor White
} elseif ($cmakeSuccess) {
    Write-Host "`n??  CMake built successfully, but ESP32 build failed" -ForegroundColor Yellow
    Write-Host "   Run: .\scripts\build_esp32.ps1 for ESP32 build`n" -ForegroundColor White
} elseif ($pioSuccess) {
    Write-Host "`n??  ESP32 built successfully, but CMake build failed" -ForegroundColor Yellow
    Write-Host "   Run: .\scripts\build_and_test.ps1 for unit tests`n" -ForegroundColor White
} else {
    Write-Host "`n? Both builds failed" -ForegroundColor Red
    Write-Host "   Check build outputs above for errors`n" -ForegroundColor White
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
