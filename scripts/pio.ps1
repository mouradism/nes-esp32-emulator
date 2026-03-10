# PlatformIO Wrapper for Windows (No PATH Required)
# This script works even if 'pio' is not in PATH

param(
    [Parameter(Position=0, ValueFromRemainingArguments=$true)]
    [string[]]$Arguments
)

Write-Host "PlatformIO Wrapper (using Python module)" -ForegroundColor Cyan

# Run PlatformIO using Python module
python -m platformio @Arguments
