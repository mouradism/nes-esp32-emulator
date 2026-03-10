# Quick Fix: Add PlatformIO to PATH (Current Session)
# Run this in your VS2022 Terminal

Write-Host "`n??????????????????????????????????????????" -ForegroundColor Green
Write-Host "?  PlatformIO PATH Quick Fix             ?" -ForegroundColor Green
Write-Host "??????????????????????????????????????????`n" -ForegroundColor Green

# Add Python Scripts to PATH
$pythonScripts = "C:\Users\taha\AppData\Roaming\Python\Python314\Scripts"

Write-Host "Adding to PATH: " -NoNewline -ForegroundColor Yellow
Write-Host $pythonScripts -ForegroundColor Cyan

$env:Path += ";$pythonScripts"

Write-Host "`n? Added to PATH for current session" -ForegroundColor Green

# Test if pio works now
Write-Host "`nTesting pio command..." -ForegroundColor Yellow

try {
    $version = pio --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "? SUCCESS! pio command now works:" -ForegroundColor Green
        Write-Host "  $version" -ForegroundColor Cyan
    }
    else {
        Write-Host "? pio command still not found" -ForegroundColor Red
        Write-Host "`nUse this instead:" -ForegroundColor Yellow
        Write-Host "  python -m platformio" -ForegroundColor Cyan
    }
}
catch {
    Write-Host "? pio command still not found" -ForegroundColor Red
    Write-Host "`nUse this instead:" -ForegroundColor Yellow
    Write-Host "  python -m platformio" -ForegroundColor Cyan
}

Write-Host "`nNote: This fix is temporary (current session only)" -ForegroundColor Yellow
Write-Host "For permanent fix, see: docs\PLATFORMIO_PATH_FIX.md`n" -ForegroundColor Cyan

Write-Host "Quick Test Commands:" -ForegroundColor Yellow
Write-Host "  pio --version" -ForegroundColor White
Write-Host "  pio device list" -ForegroundColor White
Write-Host "  pio run`n" -ForegroundColor White
