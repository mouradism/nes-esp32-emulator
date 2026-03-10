# PlatformIO PATH Fix for Windows

## Issue
PlatformIO is installed but `pio` command is not recognized in PowerShell.

## Quick Fix: Use Python Module

Instead of `pio`, use `python -m platformio`:

```powershell
# Instead of:
pio --version

# Use:
python -m platformio --version
```

## Permanent Solution 1: Add to PATH (Recommended)

### Find PlatformIO Location
```powershell
# Find where pio.exe is located
python -c "import platformio; import os; print(os.path.dirname(platformio.__file__))"
```

The `pio.exe` should be in your Python Scripts folder, typically:
```
C:\Users\taha\AppData\Roaming\Python\Python314\Scripts\
```

### Add to PATH (Current Session)
```powershell
# Add to PATH for current PowerShell session
$env:Path += ";C:\Users\taha\AppData\Roaming\Python\Python314\Scripts"

# Verify
pio --version
```

### Add to PATH (Permanent)
1. Press `Win + X` and select "System"
2. Click "Advanced system settings"
3. Click "Environment Variables"
4. Under "User variables", select "Path"
5. Click "Edit"
6. Click "New"
7. Add: `C:\Users\taha\AppData\Roaming\Python\Python314\Scripts`
8. Click OK on all dialogs
9. **Restart PowerShell/VS2022**

## Permanent Solution 2: Create Alias

Add this to your PowerShell profile:

```powershell
# Open/create PowerShell profile
notepad $PROFILE

# Add this line:
Set-Alias -Name pio -Value "python -m platformio"

# Save and reload:
. $PROFILE
```

## Permanent Solution 3: Use Batch File Wrapper

Create `pio.bat` in a PATH directory:

```batch
@echo off
python -m platformio %*
```

Save to: `C:\Windows\System32\pio.bat` (requires admin) or add to any directory in your PATH.

## Quick Workaround for This Project

I'll update the scripts to use `python -m platformio` instead of `pio`.

### Updated Commands

```powershell
# Build
python -m platformio run

# Upload
python -m platformio run -t upload

# Monitor
python -m platformio device monitor

# List devices
python -m platformio device list

# Clean
python -m platformio run -t clean
```

## Test the Fix

```powershell
# Test with Python module
python -m platformio --version

# Should show: PlatformIO Core, version 6.1.19
```

## For VS2022 Users

### Temporary Fix (Current Session)
```powershell
# In VS2022 Terminal (Ctrl+`)
$env:Path += ";C:\Users\taha\AppData\Roaming\Python\Python314\Scripts"
pio --version
```

### Permanent Fix
After adding to Windows PATH and restarting VS2022, `pio` will work.

## Verification

After applying any fix:
```powershell
pio --version
# Should output: PlatformIO Core, version 6.1.19
```

---

**Recommended:** Use Solution 1 (Add to PATH) - it's the cleanest and most reliable.
