#!/usr/bin/env pwsh
# Deploy Flutter Web App to GitHub Pages
# Usage: .\deploy.ps1 -GitHubUsername "YOUR_USERNAME" -RepositoryName "website-for-kuya"

param(
    [Parameter(Mandatory=$false)]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory=$false)]
    [string]$RepositoryName = "website-for-kuya",
    
    [Parameter(Mandatory=$false)]
    [string]$CommitMessage = "Deploy: Update Flutter web build"
)

$projectRoot = Get-Location

# Color output
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Error-Msg { Write-Host $args -ForegroundColor Red }
function Write-Info { Write-Host $args -ForegroundColor Cyan }

Write-Info "=== Flutter Web Deployment Script ==="
Write-Info ""

# Check if Git is initialized
if (-not (Test-Path ".git")) {
    Write-Error-Msg "Git not initialized. Run: git init"
    exit 1
}

# Check if remote exists
$remoteExists = git remote | Select-String "origin"
if (-not $remoteExists) {
    if (-not $GitHubUsername) {
        Write-Error-Msg "GitHub username not provided."
        Write-Info "Usage: .\deploy.ps1 -GitHubUsername YOUR_USERNAME"
        exit 1
    }
    
    Write-Info "Adding remote origin..."
    $remoteUrl = "https://github.com/$GitHubUsername/$RepositoryName.git"
    git remote add origin $remoteUrl
    Write-Success "Remote added: $remoteUrl"
}

# Ensure we're on main branch
Write-Info "Checking branch..."
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($currentBranch -ne "main") {
    Write-Info "Current branch: $currentBranch"
    Write-Info "Renaming to 'main'..."
    git branch -M main
    Write-Success "Branch renamed to 'main'"
}

# Build Flutter web
Write-Info ""
Write-Info "Building Flutter web release..."
flutter build web --release --pwa-strategy=none --dart-define=FLUTTER_WEB_USE_SKIA=false
if ($LASTEXITCODE -ne 0) {
    Write-Error-Msg "Build failed!"
    exit 1
}
Write-Success "Build completed!"

# Stage files
Write-Info ""
Write-Info "Staging files..."
git add .
Write-Success "Files staged"

# Commit
Write-Info "Committing..."
git commit -m $CommitMessage
if ($LASTEXITCODE -ne 0) {
    Write-Error-Msg "Commit failed (may be nothing to commit)"
}

# Push
Write-Info "Pushing to GitHub..."
git push -u origin main
if ($LASTEXITCODE -eq 0) {
    Write-Success "Successfully pushed to GitHub!"
    Write-Success ""
    Write-Success "Your site will be deployed by GitHub Actions."
    Write-Success "Check: https://github.com/$GitHubUsername/$RepositoryName/actions"
    Write-Success ""
    Write-Success "Site URL: https://$GitHubUsername.github.io/$RepositoryName"
} else {
    Write-Error-Msg "Push failed!"
    exit 1
}
