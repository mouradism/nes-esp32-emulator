# PlatformIO SSL Download Error Fix

## Issue
When running `pio run` for the first time, you may encounter SSL errors:
```
[SSL: DECRYPTION_FAILED_OR_BAD_RECORD_MAC] decryption failed or bad record mac
```

This happens when PlatformIO tries to download the ESP32 Arduino framework and toolchain.

## Quick Fixes

### Fix 1: Disable SSL Verification (Quick but less secure)

**Temporary (Current Session):**
```powershell
$env:PLATFORMIO_INSECURE_SSL = "1"
pio run
```

**Permanent:**
Add to your environment variables or create a `.env` file in project root:
```
PLATFORMIO_INSECURE_SSL=1
```

### Fix 2: Update Certificates

```powershell
# Update pip
python -m pip install --upgrade pip

# Update certifi
python -m pip install --upgrade certifi

# Retry
pio run
```

### Fix 3: Use Different Mirror

PlatformIO will try different mirrors automatically. Sometimes just retrying helps:
```powershell
# Clean cache
pio run -t clean

# Retry several times - it may work on retry
pio run
pio run
pio run
```

### Fix 4: Manual Download and Extract

If automatic download fails repeatedly:

1. **Download framework manually:**
   - Go to: https://github.com/platformio/platform-espressif32/releases
   - Download the latest framework package

2. **Extract to PlatformIO packages:**
   ```
   C:\Users\taha\.platformio\packages\
   ```

3. **Retry build:**
   ```powershell
   pio run
   ```

### Fix 5: Check Network/Firewall

- Disable VPN temporarily
- Check firewall settings
- Try different network
- Check antivirus SSL scanning

### Fix 6: Update PlatformIO

```powershell
# Update PlatformIO itself
python -m pip install --upgrade platformio

# Retry
pio run
```

## Recommended Solution for Now

Try this sequence:

```powershell
# 1. Set environment variable to bypass SSL
$env:PLATFORMIO_INSECURE_SSL = "1"

# 2. Clean any partial downloads
Remove-Item -Recurse -Force "$env:USERPROFILE\.platformio\packages\framework-arduinoespressif32*" -ErrorAction SilentlyContinue

# 3. Retry download
pio run
```

## If Still Failing

Use the manager script which handles retries:
```powershell
.\scripts\pio_manager.ps1
# Select: 1. Build project
```

Or build using CMake for unit testing while we troubleshoot ESP32 build:
```powershell
.\scripts\build_and_test.ps1
```

## Alternative: Use PlatformIO IDE

The VS Code PlatformIO IDE extension sometimes handles downloads better:

1. Install PlatformIO IDE extension in VS Code
2. Open project in VS Code
3. Let PlatformIO IDE handle the downloads
4. Once packages are downloaded, CLI will work too

## Status Check

Check what's already downloaded:
```powershell
ls "$env:USERPROFILE\.platformio\packages\"
```

You should see:
- `toolchain-xtensa-esp32` - ? Already downloaded
- `framework-arduinoespressif32` - ? This is failing

## Network Issues?

If you're behind a corporate firewall or using VPN:

```powershell
# Set proxy if needed
$env:HTTP_PROXY = "http://proxy:port"
$env:HTTPS_PROXY = "http://proxy:port"

pio run
```

## Last Resort: Offline Installation

1. Download packages on another computer
2. Copy to: `C:\Users\taha\.platformio\packages\`
3. Retry build

---

**Most likely fix:** Run with SSL bypass flag and retry a few times.
```powershell
$env:PLATFORMIO_INSECURE_SSL = "1"
pio run
```
