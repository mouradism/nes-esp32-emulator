# PlatformIO Manager for NES Emulator on ESP32
# Windows PowerShell Script

param(
    [Parameter(Position=0)]
    [string]$Command = "menu",
    [string]$Port = "",
    [int]$BaudRate = 115200
)

function Write-Header {
    param([string]$Message)
    Write-Host "`n============================================================" -ForegroundColor Cyan
    Write-Host $Message.PadLeft(30 + $Message.Length/2).PadRight(60) -ForegroundColor Cyan
    Write-Host "============================================================`n" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "? $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "? $Message" -ForegroundColor Red
}

function Write-Info-Custom {
    param([string]$Message)
    Write-Host "? $Message" -ForegroundColor Cyan
}

function Test-PlatformIO {
    try {
        # Try using python module method (works without PATH)
        $result = python -m platformio --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
    }
    catch {
        return $false
    }
    return $false
}

function Install-PlatformIO {
    Write-Header "Installing PlatformIO"
    Write-Info-Custom "Installing PlatformIO via pip..."
    
    try {
        pip install platformio
        Write-Success "PlatformIO installed successfully!"
        Write-Info-Custom "Note: Use 'python -m platformio' or restart terminal for 'pio' command"
        return $true
    }
    catch {
        Write-Error-Custom "Failed to install PlatformIO"
        Write-Info-Custom "Please ensure Python and pip are installed"
        return $false
    }
}

function Build-Project {
    Write-Header "Building Project"
    Write-Info-Custom "Building NES Emulator..."
    
    python -m platformio run
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Build completed successfully!"
        return $true
    }
    else {
        Write-Error-Custom "Build failed"
        return $false
    }
}

function Upload-Project {
    param([string]$UploadPort = "")
    
    Write-Header "Uploading to ESP32"
    Write-Info-Custom "Uploading firmware..."
    
    if ($UploadPort -ne "") {
        python -m platformio run -t upload --upload-port $UploadPort
    }
    else {
        python -m platformio run -t upload
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Upload completed successfully!"
        return $true
    }
    else {
        Write-Error-Custom "Upload failed"
        return $false
    }
}

function Monitor-Serial {
    param([int]$Baud = 115200)
    
    Write-Header "Serial Monitor"
    Write-Info-Custom "Opening serial monitor at $Baud baud..."
    Write-Info-Custom "Press Ctrl+C to exit"
    
    python -m platformio device monitor -b $Baud
}

function Clean-Project {
    Write-Header "Cleaning Project"
    Write-Info-Custom "Cleaning build files..."
    
    python -m platformio run -t clean
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Clean completed successfully!"
        return $true
    }
    else {
        Write-Error-Custom "Clean failed"
        return $false
    }
}

function Show-Devices {
    Write-Header "Connected Devices"
    python -m platformio device list
}

function Update-Libraries {
    Write-Header "Updating Libraries"
    Write-Info-Custom "Updating project libraries..."
    
    python -m platformio lib update
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Libraries updated successfully!"
        return $true
    }
    else {
        Write-Error-Custom "Library update failed"
        return $false
    }
}

function Full-Build {
    param([string]$UploadPort = "")
    
    Write-Header "Full Build and Upload"
    
    if (-not (Clean-Project)) { return $false }
    if (-not (Build-Project)) { return $false }
    if (-not (Upload-Project -UploadPort $UploadPort)) { return $false }
    
    Write-Success "Full build and upload completed!"
    return $true
}

function Show-Menu {
    Write-Header "NES Emulator on ESP32 - PlatformIO Manager"
    
    Write-Host "1. Build project" -ForegroundColor White
    Write-Host "2. Upload to ESP32" -ForegroundColor White
    Write-Host "3. Build and upload" -ForegroundColor White
    Write-Host "4. Monitor serial output" -ForegroundColor White
    Write-Host "5. Clean build files" -ForegroundColor White
    Write-Host "6. List connected devices" -ForegroundColor White
    Write-Host "7. Update libraries" -ForegroundColor White
    Write-Host "8. Full rebuild and upload" -ForegroundColor White
    Write-Host "9. Install PlatformIO" -ForegroundColor White
    Write-Host "0. Exit" -ForegroundColor White
    Write-Host ""
}

# Main script logic
if (-not (Test-PlatformIO)) {
    Write-Error-Custom "PlatformIO is not installed!"
    $install = Read-Host "Would you like to install it now? (y/n)"
    if ($install -eq "y" -or $install -eq "Y") {
        if (Install-PlatformIO) {
            Write-Success "PlatformIO is ready to use!"
        }
        else {
            Write-Error-Custom "Please install PlatformIO manually: pip install platformio"
            exit 1
        }
    }
    else {
        Write-Info-Custom "Please install PlatformIO: pip install platformio"
        exit 1
    }
}

# Command-line mode
if ($Command -ne "menu") {
    switch ($Command.ToLower()) {
        "build" { Build-Project }
        "upload" { Upload-Project -UploadPort $Port }
        "monitor" { Monitor-Serial -Baud $BaudRate }
        "clean" { Clean-Project }
        "devices" { Show-Devices }
        "update" { Update-Libraries }
        "full" { Full-Build -UploadPort $Port }
        "install" { Install-PlatformIO }
        default {
            Write-Host "Usage: .\pio_manager.ps1 [build|upload|monitor|clean|devices|update|full|install]" -ForegroundColor Yellow
            Write-Host "       .\pio_manager.ps1 upload -Port COM3" -ForegroundColor Yellow
            Write-Host "       .\pio_manager.ps1 monitor -BaudRate 115200" -ForegroundColor Yellow
        }
    }
    exit
}

# Interactive menu mode
while ($true) {
    Show-Menu
    $choice = Read-Host "Select option"
    
    switch ($choice) {
        "1" { Build-Project }
        "2" { 
            $portInput = Read-Host "Enter port (or press Enter for auto-detect)"
            Upload-Project -UploadPort $portInput
        }
        "3" {
            $portInput = Read-Host "Enter port (or press Enter for auto-detect)"
            if (Build-Project) {
                Upload-Project -UploadPort $portInput
            }
        }
        "4" {
            $baudInput = Read-Host "Enter baud rate (default 115200)"
            $baud = if ($baudInput) { [int]$baudInput } else { 115200 }
            Monitor-Serial -Baud $baud
        }
        "5" { Clean-Project }
        "6" { Show-Devices }
        "7" { Update-Libraries }
        "8" {
            $portInput = Read-Host "Enter port (or press Enter for auto-detect)"
            Full-Build -UploadPort $portInput
        }
        "9" { Install-PlatformIO }
        "0" {
            Write-Info-Custom "Goodbye!"
            exit
        }
        default { Write-Error-Custom "Invalid option" }
    }
    
    Write-Host ""
    Read-Host "Press Enter to continue"
}
