# Build ESP32 Project with Network Workarounds
# Handles SSL and DNS download issues automatically

Write-Host "`n??????????????????????????????????????????" -ForegroundColor Cyan
Write-Host "?  ESP32 Build - Network Workaround      ?" -ForegroundColor Cyan
Write-Host "??????????????????????????????????????????`n" -ForegroundColor Cyan

Write-Host "Preparing to build for ESP32..." -ForegroundColor Yellow
Write-Host "Applying network workarounds...`n" -ForegroundColor Yellow

# Set environment variables for better compatibility
$env:PLATFORMIO_INSECURE_SSL = "1"
$env:PIO_CORE_DEFAULT_DOWNLOAD_TIMEOUT = "300"
Write-Host "? SSL verification bypass enabled" -ForegroundColor Green
Write-Host "? Extended timeout set (5 minutes)" -ForegroundColor Green

# Flush DNS cache to resolve DNS issues
Write-Host "`nFlushing DNS cache..." -ForegroundColor Yellow
try {
    ipconfig /flushdns | Out-Null
    Write-Host "? DNS cache flushed" -ForegroundColor Green
} catch {
    Write-Host "? Could not flush DNS (may need admin)" -ForegroundColor Yellow
}

# Navigate to project directory
$projectDir = "C:\Users\taha\Desktop\NES on ESP 32"
if (Test-Path $projectDir) {
    Set-Location $projectDir
    Write-Host "? Changed to project directory" -ForegroundColor Green
} else {
    Write-Host "? Project directory not found!" -ForegroundColor Red
    exit 1
}

Write-Host "`nAttempting build..." -ForegroundColor Yellow
Write-Host "This may take a while on first run (downloading ESP32 framework)..." -ForegroundColor Yellow
Write-Host "The download is ~50MB - please be patient...`n" -ForegroundColor Yellow

# Try with retry logic
$maxAttempts = 3
$attempt = 1
$success = $false

while ($attempt -le $maxAttempts -and -not $success) {
    Write-Host "Build attempt $attempt of $maxAttempts..." -ForegroundColor Cyan
    
    try {
        python -m platformio run 2>&1 | Tee-Object -Variable buildOutput
        
        if ($LASTEXITCODE -eq 0) {
            $success = $true
            Write-Host "`n??????????????????????????????????????????" -ForegroundColor Green
            Write-Host "?  BUILD SUCCESSFUL! ?                   ?" -ForegroundColor Green
            Write-Host "??????????????????????????????????????????`n" -ForegroundColor Green
            
            Write-Host "Firmware compiled successfully!" -ForegroundColor Green
            Write-Host "`nNext steps:" -ForegroundColor Yellow
            Write-Host "  1. Connect ESP32 via USB" -ForegroundColor White
            Write-Host "  2. Upload: python -m platformio run -t upload" -ForegroundColor Cyan
            Write-Host "  3. Monitor: python -m platformio device monitor`n" -ForegroundColor Cyan
        } else {
            if ($buildOutput -match "NameResolutionError|getaddrinfo failed") {
                Write-Host "? DNS resolution failed - retrying..." -ForegroundColor Yellow
                Start-Sleep -Seconds 2
            } elseif ($buildOutput -match "SSL") {
                Write-Host "? SSL error - retrying..." -ForegroundColor Yellow
                Start-Sleep -Seconds 2
            } else {
                Write-Host "? Build failed with other error" -ForegroundColor Red
                break
            }
        }
    } catch {
        Write-Host "? Exception occurred: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    $attempt++
}

if (-not $success) {
    Write-Host "`n??????????????????????????????????????????" -ForegroundColor Red
    Write-Host "?  BUILD FAILED ?                        ?" -ForegroundColor Red
    Write-Host "??????????????????????????????????????????`n" -ForegroundColor Red
    
    Write-Host "Network download is failing. Try these solutions:`n" -ForegroundColor Yellow
    
    Write-Host "Option 1: Check Network" -ForegroundColor Cyan
    Write-Host "  • Disable VPN if active" -ForegroundColor White
    Write-Host "  • Try different WiFi/network" -ForegroundColor White
    Write-Host "  • Disable antivirus SSL scanning" -ForegroundColor White
    Write-Host "  • Check firewall settings`n" -ForegroundColor White
    
    Write-Host "Option 2: Use VS Code PlatformIO Extension" -ForegroundColor Cyan
    Write-Host "  • Install PlatformIO IDE in VS Code" -ForegroundColor White
    Write-Host "  • Open this project" -ForegroundColor White
    Write-Host "  • Let VS Code download packages`n" -ForegroundColor White
    
    Write-Host "Option 3: Manual Download" -ForegroundColor Cyan
    Write-Host "  • Visit: https://github.com/platformio/platform-espressif32" -ForegroundColor White
    Write-Host "  • Download framework manually" -ForegroundColor White
    Write-Host "  • See: docs\PLATFORMIO_SSL_FIX.md`n" -ForegroundColor White
    
    Write-Host "Option 4: Build Unit Tests Instead" -ForegroundColor Cyan
    Write-Host "  • Run: .\scripts\build_and_test.ps1" -ForegroundColor White
    Write-Host "  • Test on PC while troubleshooting ESP32 build`n" -ForegroundColor White
}

Write-Host "`nPress any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
