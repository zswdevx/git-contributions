# git-contrib Windows Installation Script
# Usage: iwr -useb https://raw.githubusercontent.com/zswdevx/git-contributions/main/install.ps1 | iex

param(
    [string]$Version = "latest",
    [string]$InstallDir = ""
)

$ErrorActionPreference = "Stop"

# Helper function to create temporary directory
function New-TemporaryDirectory {
    $tempPath = [System.IO.Path]::GetTempPath()
    $tempDir = [System.IO.Path]::Combine($tempPath, [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tempDir | Out-Null
    return $tempDir
}

# Set installation directory
if ([string]::IsNullOrEmpty($InstallDir)) {
    $InstallDir = "$env:LOCALAPPDATA\git-contrib"
}

$BinDir = Join-Path $InstallDir "bin"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  git-contrib Windows Installer" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Detect system architecture
$Arch = "amd64"
if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") {
    $Arch = "arm64"
}
Write-Host "[INFO] Detected architecture: $Arch" -ForegroundColor Green

# Determine GitHub download URL
$RepoUrl = "https://github.com/zswdevx/git-contributions"
if ($Version -eq "latest") {
    $DownloadUrl = "$RepoUrl/releases/latest/download/git-contrib-windows-$Arch.exe.zip"
} else {
    $DownloadUrl = "$RepoUrl/releases/download/$Version/git-contrib-windows-$Arch.exe.zip"
}

Write-Host "[INFO] Download URL: $DownloadUrl" -ForegroundColor Yellow

# Create temporary directory
$TempDir = New-TemporaryDirectory
$TempFile = Join-Path $TempDir "git-contrib.zip"

try {
    # Download file
    Write-Host "[1/5] Downloading git-contrib..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $TempFile -UseBasicParsing
    Write-Host "[DONE] Download completed" -ForegroundColor Green

    # Extract file using PowerShell
    Write-Host "[2/5] Extracting..." -ForegroundColor Yellow
    $ExtractDir = Join-Path $TempDir "extracted"
    Expand-Archive -Path $TempFile -DestinationPath $ExtractDir -Force
    Write-Host "[DONE] Extraction completed" -ForegroundColor Green

    # Create installation directory
    Write-Host "[3/5] Installing..." -ForegroundColor Yellow
    if (-not (Test-Path $BinDir)) {
        New-Item -ItemType Directory -Path $BinDir -Force | Out-Null
    }

    # Move file
    $ExeFiles = Get-ChildItem -Path $ExtractDir -Filter "*.exe" -Recurse
    if ($ExeFiles.Count -eq 0) {
        throw "No .exe file found after extraction"
    }

    $ExeFile = $ExeFiles | Select-Object -First 1
    $DestFile = Join-Path $BinDir "git-contrib.exe"
    Copy-Item -Path $ExeFile.FullName -Destination $DestFile -Force
    Write-Host "[DONE] Installed to: $DestFile" -ForegroundColor Green

    # Add to PATH
    Write-Host "[4/5] Configuring environment..." -ForegroundColor Yellow
    $UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($UserPath -notlike "*$BinDir*") {
        [Environment]::SetEnvironmentVariable("Path", "$UserPath;$BinDir", "User")
        Write-Host "[DONE] Added to PATH" -ForegroundColor Green
    } else {
        Write-Host "[SKIP] Already in PATH" -ForegroundColor Yellow
    }

    # Verify installation
    Write-Host "[5/5] Verifying installation..." -ForegroundColor Yellow
    if (Test-Path $DestFile) {
        Write-Host "[DONE] Installation successful!" -ForegroundColor Green
        Write-Host ""
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host "  Installation Complete!" -ForegroundColor Cyan
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Location: $DestFile" -ForegroundColor White
        Write-Host ""
        Write-Host "You can now run:" -ForegroundColor Yellow
        Write-Host "  git-contrib version" -ForegroundColor White
        Write-Host "  git-contrib heatmap" -ForegroundColor White
        Write-Host ""
        Write-Host "Note: Restart PowerShell/CMD to refresh PATH" -ForegroundColor Yellow
        Write-Host ""

        # Show version
        try {
            & $DestFile version
        } catch {
            Write-Host "[WARNING] Cannot display version" -ForegroundColor Yellow
        }
    } else {
        throw "Installation failed: git-contrib.exe not found"
    }

} catch {
    Write-Host ""
    Write-Host "[ERROR] Installation failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please try manual installation:" -ForegroundColor Yellow
    Write-Host "1. Visit $RepoUrl/releases" -ForegroundColor White
    Write-Host "2. Download the Windows version" -ForegroundColor White
    Write-Host "3. Extract and place git-contrib.exe in a PATH directory" -ForegroundColor White
    Write-Host ""
    exit 1
} finally {
    # Cleanup temporary files
    if (Test-Path $TempDir) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
