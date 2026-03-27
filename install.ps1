# git-contrib Windows 安装脚本
# 使用方法: iwr -useb https://raw.githubusercontent.com/zswdevx/git-contributions/main/install.ps1 | iex

param(
    [string]$Version = "latest",
    [string]$InstallDir = ""
)

$ErrorActionPreference = "Stop"

# 设置安装目录
if ([string]::IsNullOrEmpty($InstallDir)) {
    $InstallDir = "$env:LOCALAPPDATA\git-contrib"
}

$BinDir = Join-Path $InstallDir "bin"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  git-contrib Windows 安装程序" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 检测系统架构
$Arch = "amd64"
if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") {
    $Arch = "arm64"
}
Write-Host "[信息] 检测到系统架构: $Arch" -ForegroundColor Green

# 确定 GitHub 下载 URL
$RepoUrl = "https://github.com/zswdevx/git-contributions"
if ($Version -eq "latest") {
    $DownloadUrl = "$RepoUrl/releases/latest/download/git-contrib-windows-$Arch.exe.tar.gz"
} else {
    $DownloadUrl = "$RepoUrl/releases/download/$Version/git-contrib-windows-$Arch.exe.tar.gz"
}

Write-Host "[信息] 下载地址: $DownloadUrl" -ForegroundColor Yellow

# 创建临时目录
$TempDir = New-TemporaryDirectory
$TempFile = Join-Path $TempDir "git-contrib.tar.gz"

try {
    # 下载文件
    Write-Host "[1/5] 正在下载 git-contrib..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $TempFile -UseBasicParsing
    Write-Host "[完成] 下载完成" -ForegroundColor Green

    # 解压文件
    Write-Host "[2/5] 正在解压..." -ForegroundColor Yellow
    $ExtractDir = Join-Path $TempDir "extracted"
    New-Item -ItemType Directory -Path $ExtractDir -Force | Out-Null

    # 使用 tar 解压（Windows 10 1803+ 内置）
    tar -xzf $TempFile -C $ExtractDir
    Write-Host "[完成] 解压完成" -ForegroundColor Green

    # 创建安装目录
    Write-Host "[3/5] 正在安装..." -ForegroundColor Yellow
    if (-not (Test-Path $BinDir)) {
        New-Item -ItemType Directory -Path $BinDir -Force | Out-Null
    }

    # 移动文件
    $ExeFile = Get-ChildItem -Path $ExtractDir -Filter "*.exe" | Select-Object -First 1
    $DestFile = Join-Path $BinDir "git-contrib.exe"
    Move-Item -Path $ExeFile.FullName -Destination $DestFile -Force
    Write-Host "[完成] 已安装到: $DestFile" -ForegroundColor Green

    # 添加到 PATH
    Write-Host "[4/5] 正在配置环境变量..." -ForegroundColor Yellow
    $UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($UserPath -notlike "*$BinDir*") {
        [Environment]::SetEnvironmentVariable("Path", "$UserPath;$BinDir", "User")
        $env:Path = "$env:Path;$BinDir"
        Write-Host "[完成] 已添加到 PATH" -ForegroundColor Green
    } else {
        Write-Host "[跳过] PATH 中已存在" -ForegroundColor Yellow
    }

    # 验证安装
    Write-Host "[5/5] 正在验证安装..." -ForegroundColor Yellow
    $GitContribCmd = Join-Path $BinDir "git-contrib.exe"
    if (Test-Path $GitContribCmd) {
        Write-Host "[完成] 安装成功！" -ForegroundColor Green
        Write-Host ""
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host "  安装完成！" -ForegroundColor Cyan
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "安装位置: $DestFile" -ForegroundColor White
        Write-Host ""
        Write-Host "现在可以在任意目录运行：" -ForegroundColor Yellow
        Write-Host "  git-contrib version" -ForegroundColor White
        Write-Host "  git-contrib heatmap" -ForegroundColor White
        Write-Host ""
        Write-Host "提示: 请重新打开 PowerShell/CMD 窗口使 PATH 生效" -ForegroundColor Yellow
        Write-Host ""

        # 显示版本信息
        try {
            & $GitContribCmd version
        } catch {
            Write-Host "[警告] 无法显示版本信息" -ForegroundColor Yellow
        }
    } else {
        throw "安装验证失败：找不到 git-contrib.exe"
    }

} catch {
    Write-Host ""
    Write-Host "[错误] 安装失败: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "请尝试手动安装：" -ForegroundColor Yellow
    Write-Host "1. 访问 $RepoUrl/releases" -ForegroundColor White
    Write-Host "2. 下载对应的 Windows 版本" -ForegroundColor White
    Write-Host "3. 解压后将 git-contrib.exe 放到 PATH 目录中" -ForegroundColor White
    Write-Host ""
    exit 1
} finally {
    # 清理临时文件
    if (Test-Path $TempDir) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 辅助函数：创建临时目录
function New-TemporaryDirectory {
    $tempPath = [System.IO.Path]::GetTempPath()
    $tempDir = [System.IO.Path]::Combine($tempPath, [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tempDir | Out-Null
    return $tempDir
}
