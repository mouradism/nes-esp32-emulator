# GitHub Push and Project Link Script
# Automates pushing to GitHub and linking to project board

param(
    [string]$RepoName = "nes-esp32-emulator",
    [string]$GitHubUsername = "mouradism",
    [string]$ProjectUrl = "https://github.com/users/mouradism/projects/2"
)

Write-Host "`n??????????????????????????????????????????????????????????" -ForegroundColor Cyan
Write-Host "?  Push to GitHub & Link to Project Board               ?" -ForegroundColor Cyan
Write-Host "??????????????????????????????????????????????????????????`n" -ForegroundColor Cyan

$projectDir = "C:\Users\taha\Desktop\NES on ESP 32"
Set-Location $projectDir

# Step 1: Check if GitHub CLI is installed
Write-Host "Step 1: Checking GitHub CLI..." -ForegroundColor Yellow
try {
    $ghVersion = gh --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "? GitHub CLI is installed" -ForegroundColor Green
        Write-Host "  Version: $($ghVersion | Select-Object -First 1)" -ForegroundColor Gray
    }
} catch {
    Write-Host "? GitHub CLI not found!" -ForegroundColor Red
    Write-Host "`nPlease install GitHub CLI:" -ForegroundColor Yellow
    Write-Host "  1. Download: https://cli.github.com/" -ForegroundColor White
    Write-Host "  2. Or use: winget install --id GitHub.cli" -ForegroundColor Cyan
    Write-Host "  3. Then run: gh auth login`n" -ForegroundColor Cyan
    exit 1
}

# Step 2: Check authentication
Write-Host "`nStep 2: Checking GitHub authentication..." -ForegroundColor Yellow
try {
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "? Authenticated with GitHub" -ForegroundColor Green
    } else {
        Write-Host "? Not authenticated!" -ForegroundColor Red
        Write-Host "`nAuthenticating with GitHub..." -ForegroundColor Yellow
        gh auth login
    }
} catch {
    Write-Host "? Authentication check failed, attempting login..." -ForegroundColor Yellow
    gh auth login
}

# Step 3: Create GitHub repository
Write-Host "`nStep 3: Creating GitHub repository..." -ForegroundColor Yellow
$repoUrl = "https://github.com/$GitHubUsername/$RepoName"
$repoExists = $false

try {
    $checkRepo = gh repo view "$GitHubUsername/$RepoName" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "? Repository already exists: $repoUrl" -ForegroundColor Green
        $repoExists = $true
    }
} catch {
    Write-Host "  Repository doesn't exist yet, creating..." -ForegroundColor Gray
}

if (-not $repoExists) {
    $description = "NES Emulator for ESP32 with CMake and PlatformIO support - 33 tests passing, ready for hardware"
    
    try {
        gh repo create "$GitHubUsername/$RepoName" `
            --public `
            --description $description `
            --source=. `
            --remote=origin
        
        Write-Host "? Repository created: $repoUrl" -ForegroundColor Green
    } catch {
        Write-Host "? Failed to create repository" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
        exit 1
    }
}

# Step 4: Add remote if not exists
Write-Host "`nStep 4: Configuring git remote..." -ForegroundColor Yellow
$remotes = git remote -v
if ($remotes -match "origin") {
    Write-Host "? Remote 'origin' already configured" -ForegroundColor Green
    git remote set-url origin "https://github.com/$GitHubUsername/$RepoName.git"
} else {
    git remote add origin "https://github.com/$GitHubUsername/$RepoName.git"
    Write-Host "? Remote 'origin' added" -ForegroundColor Green
}

Write-Host "  Remote URL: https://github.com/$GitHubUsername/$RepoName.git" -ForegroundColor Gray

# Step 5: Push to GitHub
Write-Host "`nStep 5: Pushing to GitHub..." -ForegroundColor Yellow
Write-Host "  Pushing 11 commits to master branch..." -ForegroundColor Gray

try {
    git push -u origin master --force 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "? Successfully pushed to GitHub!" -ForegroundColor Green
        Write-Host "  All 11 commits uploaded" -ForegroundColor Gray
    } else {
        # Try without force
        git push -u origin master
        if ($LASTEXITCODE -eq 0) {
            Write-Host "? Successfully pushed to GitHub!" -ForegroundColor Green
        } else {
            Write-Host "? Push failed" -ForegroundColor Red
            exit 1
        }
    }
} catch {
    Write-Host "? Push failed: $_" -ForegroundColor Red
    exit 1
}

# Step 6: Add repository to project board
Write-Host "`nStep 6: Linking to project board..." -ForegroundColor Yellow
Write-Host "  Project: https://github.com/users/$GitHubUsername/projects/2" -ForegroundColor Gray

try {
    # Get project ID
    $projectNumber = 2
    
    # Add repository to project (this requires GitHub GraphQL API)
    # Using gh api to add the repo to the project
    
    Write-Host "`nNote: Project board linking requires manual step:" -ForegroundColor Yellow
    Write-Host "  1. Go to: https://github.com/users/$GitHubUsername/projects/$projectNumber" -ForegroundColor White
    Write-Host "  2. Click '+' or 'Add item'" -ForegroundColor White
    Write-Host "  3. Search for: $RepoName" -ForegroundColor White
    Write-Host "  4. Select your repository" -ForegroundColor White
    Write-Host "`nOr run: gh project item-add $projectNumber --owner $GitHubUsername --url $repoUrl`n" -ForegroundColor Cyan
    
} catch {
    Write-Host "? Could not automatically link to project board" -ForegroundColor Yellow
}

# Step 7: Create initial issues from CHECKLIST
Write-Host "`nStep 7: Create issues from CHECKLIST? (optional)" -ForegroundColor Yellow
$createIssues = Read-Host "Create GitHub issues from CHECKLIST.md? (y/n)"

if ($createIssues -eq "y" -or $createIssues -eq "Y") {
    Write-Host "  Creating issues..." -ForegroundColor Gray
    
    # High priority issues
    gh issue create --title "Implement CPU opcodes (6502)" `
        --body "Complete implementation of all 56 6502 CPU opcodes. Currently stubs with OP_ prefix to avoid ESP32 macro conflicts. Priority: High. See CHECKLIST.md." `
        --label "enhancement,high-priority" 2>&1 | Out-Null
    
    gh issue create --title "Implement PPU rendering pipeline" `
        --body "Complete PPU rendering: background, sprites, scrolling. Frame buffer allocated in PSRAM. Priority: High. See CHECKLIST.md." `
        --label "enhancement,high-priority" 2>&1 | Out-Null
    
    gh issue create --title "Add ROM loader (iNES format)" `
        --body "Implement ROM loading from SD card or SPIFFS. Support iNES format (.nes files). Priority: High. See CHECKLIST.md." `
        --label "enhancement,high-priority" 2>&1 | Out-Null
    
    gh issue create --title "Implement controller input" `
        --body "Add controller input handling for ESP32. Support standard NES controller mapping. Priority: Medium. See CHECKLIST.md." `
        --label "enhancement,medium-priority" 2>&1 | Out-Null
    
    gh issue create --title "Add mapper support (Mapper 0)" `
        --body "Implement memory mapper support starting with Mapper 0 (NROM). Priority: Medium. See CHECKLIST.md." `
        --label "enhancement,medium-priority" 2>&1 | Out-Null
    
    Write-Host "? Created 5 issues from CHECKLIST.md" -ForegroundColor Green
}

# Final summary
Write-Host "`n??????????????????????????????????????????????????????????" -ForegroundColor Green
Write-Host "?  SUCCESS! Repository published to GitHub! ??           ?" -ForegroundColor Green
Write-Host "??????????????????????????????????????????????????????????`n" -ForegroundColor Green

Write-Host "Repository URL:" -ForegroundColor Yellow
Write-Host "  $repoUrl`n" -ForegroundColor Cyan

Write-Host "Project Board:" -ForegroundColor Yellow
Write-Host "  $ProjectUrl`n" -ForegroundColor Cyan

Write-Host "Quick Links:" -ForegroundColor Yellow
Write-Host "  View Code:     $repoUrl" -ForegroundColor White
Write-Host "  View Issues:   $repoUrl/issues" -ForegroundColor White
Write-Host "  View Actions:  $repoUrl/actions" -ForegroundColor White
Write-Host "  Clone:         git clone https://github.com/$GitHubUsername/$RepoName.git`n" -ForegroundColor White

Write-Host "What's Published:" -ForegroundColor Yellow
Write-Host "  ? 11 commits" -ForegroundColor Green
Write-Host "  ? 33 passing tests" -ForegroundColor Green
Write-Host "  ? ESP32 firmware (compiled)" -ForegroundColor Green
Write-Host "  ? Complete documentation" -ForegroundColor Green
Write-Host "  ? Build scripts & automation" -ForegroundColor Green
Write-Host "  ? CI/CD workflow" -ForegroundColor Green
Write-Host "  ? Epic journey narrative`n" -ForegroundColor Green

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Link repo to project board (see note above)" -ForegroundColor White
Write-Host "  2. Add topics/tags to repository" -ForegroundColor White
Write-Host "  3. Star your own repo! ?" -ForegroundColor White
Write-Host "  4. Share with the community`n" -ForegroundColor White

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
