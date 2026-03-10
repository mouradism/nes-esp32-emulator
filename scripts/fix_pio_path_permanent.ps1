# Permanent PlatformIO PATH Fix for Windows
# This script adds PlatformIO to User PATH permanently
# Requires: Run as current user (not admin needed)

Write-Host "`n??????????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host "?  PlatformIO Permanent PATH Fix                        ?" -ForegroundColor Cyan
Write-Host "??????????????????????????????????????????????????????????`n" -ForegroundColor Cyan

$pythonScriptsPath = "C:\Users\taha\AppData\Roaming\Python\Python314\Scripts"

Write-Host "This script will add PlatformIO to your Windows PATH permanently." -ForegroundColor Yellow
Write-Host "Path to add: " -NoNewline
Write-Host $pythonScriptsPath -ForegroundColor Cyan
Write-Host ""

# Check if path exists
if (-not (Test-Path $pythonScriptsPath)) {
    Write-Host "? ERROR: Python Scripts folder not found!" -ForegroundColor Red
    Write-Host "Expected location: $pythonScriptsPath" -ForegroundColor Yellow
    Write-Host "`nTrying to find the correct path..." -ForegroundColor Yellow
    
    try {
        $actualPath = python -c "import sys; import os; print(os.path.join(sys.prefix, 'Scripts'))"
        Write-Host "Found Python Scripts at: " -NoNewline
        Write-Host $actualPath -ForegroundColor Cyan
        $pythonScriptsPath = $actualPath
    }
    catch {
        Write-Host "Could not determine Python Scripts location." -ForegroundColor Red
        exit 1
    }
}

# Get current User PATH
Write-Host "Reading current User PATH..." -ForegroundColor Yellow
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Check if already in PATH
if ($currentPath -like "*$pythonScriptsPath*") {
    Write-Host "`n? PlatformIO is already in your PATH!" -ForegroundColor Green
    Write-Host "No changes needed." -ForegroundColor Cyan
}
else {
    Write-Host "`nAdding to User PATH..." -ForegroundColor Yellow
    
    try {
        # Add to PATH
        $newPath = $currentPath + ";" + $pythonScriptsPath
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        
        Write-Host "? Successfully added to User PATH!" -ForegroundColor Green
        Write-Host "`n??  IMPORTANT: You must restart applications for changes to take effect:" -ForegroundColor Yellow
        Write-Host "  1. Close Visual Studio 2022" -ForegroundColor White
        Write-Host "  2. Close all PowerShell/Terminal windows" -ForegroundColor White
        Write-Host "  3. Reopen Visual Studio 2022" -ForegroundColor White
        Write-Host "`nAfter restart, 'pio' command will work in all new terminals." -ForegroundColor Cyan
    }
    catch {
        Write-Host "? ERROR: Failed to update PATH" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host "`nYou can add it manually:" -ForegroundColor Yellow
        Write-Host "1. Press Win+X ? System" -ForegroundColor White
        Write-Host "2. Advanced system settings ? Environment Variables" -ForegroundColor White
        Write-Host "3. User PATH ? Edit ? New" -ForegroundColor White
        Write-Host "4. Add: $pythonScriptsPath" -ForegroundColor Cyan
        exit 1
    }
}

# Show current status
Write-Host "`n" -NoNewline
Write-Host "???????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host "Current Status:" -ForegroundColor Yellow
Write-Host "???????????????????????????????????????????????????????" -ForegroundColor Cyan

Write-Host "`nUser PATH now includes:" -ForegroundColor Yellow
$updatedPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathEntries = $updatedPath -split ";"
foreach ($entry in $pathEntries) {
    if ($entry -like "*Python*Scripts*" -or $entry -like "*platformio*") {
        Write-Host "  ? $entry" -ForegroundColor Green
    }
}

Write-Host "`nTest after restart:" -ForegroundColor Yellow
Write-Host "  pio --version" -ForegroundColor Cyan
Write-Host "  pio device list" -ForegroundColor Cyan
Write-Host "  pio run" -ForegroundColor Cyan

Write-Host "`n? Permanent fix complete!" -ForegroundColor Green
Write-Host "Remember to restart VS2022 and terminals!`n" -ForegroundColor Yellow
