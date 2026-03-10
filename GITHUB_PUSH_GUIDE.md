# Push to GitHub and Link to Project Board

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `nes-esp32-emulator` (or your preferred name)
3. Description: `NES Emulator for ESP32 with CMake and PlatformIO support`
4. Visibility: Public (or Private if preferred)
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click "Create repository"

## Step 2: Add Remote and Push

After creating the repo, GitHub will show you commands. Use these:

```powershell
# Add GitHub as remote
git remote add origin https://github.com/mouradism/nes-esp32-emulator.git

# Verify remote was added
git remote -v

# Push all commits to GitHub
git push -u origin master

# Or if you prefer main branch:
# git branch -M main
# git push -u origin main
```

## Step 3: Link to Project Board

### Option A: Through GitHub Web UI

1. Go to your repository: https://github.com/mouradism/nes-esp32-emulator
2. Click "Projects" tab
3. Click "Link a project"
4. Select your project: https://github.com/users/mouradism/projects/2
5. Done!

### Option B: Through Project Board

1. Go to https://github.com/users/mouradism/projects/2
2. Click "+" to add items
3. Search for and select your `nes-esp32-emulator` repository
4. Add it to the project board

## Step 4: Create Project Issues (Optional)

You can create issues from your CHECKLIST.md:

```powershell
# Use GitHub CLI (if installed)
gh issue create --title "Implement CPU opcodes" --body "From CHECKLIST.md - Priority: High"
gh issue create --title "Implement PPU rendering" --body "From CHECKLIST.md - Priority: High"
gh issue create --title "Add ROM loader (iNES format)" --body "From CHECKLIST.md - Priority: High"
```

Or create them manually on GitHub.

## Automated Script

I'll create a script to help with this process!
