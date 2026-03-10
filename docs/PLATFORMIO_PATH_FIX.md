# PlatformIO PATH Fix for Windows

## ? PERMANENT FIX APPLIED!

If you're reading this after running the permanent fix script, the PATH has been updated. 
**You must restart Visual Studio 2022 and all terminals for changes to take effect.**

---

## Issue
PlatformIO is installed but `pio` command is not recognized in PowerShell.

## ? Quick Permanent Fix (Recommended)

**Run this script once:**
```powershell
.\scripts\fix_pio_path_permanent.ps1
```

This will:
- ? Add PlatformIO to your Windows User PATH permanently
- ? Work for all future terminal sessions
- ? No need to run fix scripts anymore

**After running, you must:**
1. Close Visual Studio 2022
2. Close all PowerShell/Terminal windows  
3. Reopen Visual Studio 2022

Then `pio` will work everywhere!

---

## Alternative: Manual Permanent Fix

If you prefer to do it manually:

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

---

## Temporary Fix (Current Session Only)

If you need a quick fix for current session only:
```powershell
.\scripts\fix_pio_path.ps1
```

Or manually:
```powershell
$env:Path += ";C:\Users\taha\AppData\Roaming\Python\Python314\Scripts"
pio --version
```

---

## Alternative: Use Python Module (No Fix Needed)

Instead of `pio`, use `python -m platformio`:

```powershell
# Works without any PATH changes
python -m platformio --version
python -m platformio run
python -m platformio run -t upload
python -m platformio device monitor
python -m platformio device list
python -m platformio run -t clean
```

---

## Verification

After permanent fix and restart:
```powershell
# Open new terminal
pio --version
# Should output: PlatformIO Core, version 6.1.19
```

If it still doesn't work, try:
```powershell
# Check if path was added
$env:Path -split ";" | Select-String "Python.*Scripts"

# Should show: C:\Users\taha\AppData\Roaming\Python\Python314\Scripts
```

---

## Troubleshooting

### Still not working after restart?

1. **Verify PATH was updated:**
```powershell
[Environment]::GetEnvironmentVariable("Path", "User") -split ";" | Select-String "Python.*Scripts"
```

2. **Make sure you closed ALL terminals:**
   - Close VS2022 completely
   - Close all PowerShell windows
   - Close Windows Terminal if open
   - Reopen fresh

3. **Check Python location:**
```powershell
python -c "import sys; import os; print(os.path.join(sys.prefix, 'Scripts'))"
```

If location is different, update PATH with correct location.

---

## Summary of Solutions

| Solution | Type | When to Use |
|----------|------|-------------|
| `fix_pio_path_permanent.ps1` | Permanent | **Best choice** - Do once |
| `fix_pio_path.ps1` | Temporary | Quick test, current session |
| `python -m platformio` | Always works | No setup needed |
| `.\scripts\pio_manager.ps1` | Wrapper | Uses Python module internally |
| Manual PATH edit | Permanent | If scripts don't work |

---

**Recommended:** Run `fix_pio_path_permanent.ps1` once, restart VS2022, and never worry about it again!
