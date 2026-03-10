# Quick GitHub Push Commands
# Copy and paste these commands one by one

# 1. Check if GitHub CLI is installed
gh --version

# If not installed, install it:
# winget install --id GitHub.cli

# 2. Login to GitHub (if not already logged in)
gh auth login

# 3. Create repository and push (all in one!)
gh repo create mouradism/nes-esp32-emulator --public --source=. --remote=origin --push

# 4. View your repository
gh repo view --web

# 5. Add to project board (Option A: Using gh CLI)
gh project item-add 2 --owner mouradism --url https://github.com/mouradism/nes-esp32-emulator

# OR Option B: Manual web UI
# Go to: https://github.com/users/mouradism/projects/2
# Click "+" ? Search for "nes-esp32-emulator" ? Add it

# 6. (Optional) Create issues from CHECKLIST
gh issue create --title "Implement CPU opcodes (6502)" --body "Complete implementation of all 56 6502 CPU opcodes" --label "enhancement,high-priority"
gh issue create --title "Implement PPU rendering pipeline" --body "Complete PPU rendering: background, sprites, scrolling" --label "enhancement,high-priority"
gh issue create --title "Add ROM loader (iNES format)" --body "Implement ROM loading from SD card" --label "enhancement,high-priority"

# 7. Add topics to repository
gh repo edit mouradism/nes-esp32-emulator --add-topic "nes-emulator,esp32,embedded,retro-gaming,platformio,cmake,arduino"

# Done! View your repo:
# https://github.com/mouradism/nes-esp32-emulator
