# 安装指南

## 方式一：下载预编译二进制（推荐）

从 [Releases](https://github.com/zswdevx/git-contributions/releases) 页面下载适合你系统的版本：

### Windows

**选择正确的版本**：
- `git-contrib-windows-amd64.exe.tar.gz` - 64位系统（推荐，适用于大多数现代电脑）
- `git-contrib-windows-arm64.exe.tar.gz` - ARM64 设备（如高通骁龙笔记本）
- `git-contrib-windows-386.exe.tar.gz` - 32位系统（老旧电脑）

**安装步骤**：
```powershell
# 下载对应版本
# 解压后重命名为 git-contrib.exe
# 添加到 PATH 环境变量或放在任意目录直接运行

# 验证
.\git-contrib.exe version
```

### Linux

**选择正确的版本**：
- `git-contrib-linux-amd64.tar.gz` - 64位系统（x86_64）
- `git-contrib-linux-arm64.tar.gz` - ARM64 设备（树莓派、ARM 服务器）

**安装步骤**：
```bash
# 下载（以 amd64 为例）
wget https://github.com/zswdevx/git-contributions/releases/latest/download/git-contrib-linux-amd64.tar.gz

# 解压
tar -xzf git-contrib-linux-amd64.tar.gz

# 赋予执行权限
chmod +x git-contrib-linux-amd64

# 移动到 PATH（可选）
sudo mv git-contrib-linux-amd64 /usr/local/bin/git-contrib

# 验证安装
git-contrib version
```

### macOS

**选择正确的版本**：
- `git-contrib-darwin-arm64.tar.gz` - Apple Silicon (M1/M2/M3)，2020年后的 Mac
- `git-contrib-darwin-amd64.tar.gz` - Intel Mac，2020年前的 Mac

**安装步骤**：
```bash
# 查看 CPU 架构
uname -m
# arm64 -> 下载 arm64 版本
# x86_64 -> 下载 amd64 版本

# 下载并解压
tar -xzf git-contrib-darwin-*.tar.gz

# macOS 可能需要允许运行未签名应用
# 系统偏好设置 -> 安全性与隐私 -> 允许从以下位置下载的 App

# 赋予执行权限并移动到 PATH
chmod +x git-contrib-darwin-*
sudo mv git-contrib-darwin-* /usr/local/bin/git-contrib

# 验证
git-contrib version
```

### macOS (使用 Homebrew)

```bash
# 如果以后发布到 Homebrew
brew install zswdevx/tap/git-contrib
```

## 方式二：从源码编译

### 前置要求

- Go 1.21 或更高版本
- Git

### 编译步骤

```bash
# 克隆仓库
git clone https://github.com/zswdevx/git-contributions.git
cd git-contributions

# 安装依赖
go mod download

# 编译
make build

# 或者安装到 GOPATH/bin
make install

# 验证
./git-contrib version
```

### 跨平台编译

```bash
# 编译所有平台
make build-all

# 或单独编译
make build-linux     # Linux
make build-darwin    # macOS
```

## 方式三：使用 `go install`

```bash
# 直接安装最新版本
go install github.com/zswdevx/git-contributions@latest

# 安装特定版本
go install github.com/zswdevx/git-contributions@v1.0.0
```

## 验证安装

```bash
# 查看版本信息
git-contrib version

# 查看帮助
git-contrib --help

# 运行热力图
git-contrib heatmap
```

## 配置 Shell 补全（可选）

### Bash

```bash
# 生成补全脚本
git-contrib completion bash > /etc/bash_completion.d/git-contrib

# 或添加到 ~/.bashrc
source <(git-contrib completion bash)
```

### Zsh

```bash
# 添加到 ~/.zshrc
source <(git-contrib completion zsh)
```

### Fish

```bash
git-contrib completion fish | source
```

## 更新

### 手动更新

重新下载最新版本并替换旧文件。

### 从源码更新

```bash
cd git-contributions
git pull
make install
```

### 使用 `go install` 更新

```bash
go install github.com/zswdevx/git-contributions@latest
```

## 卸载

删除二进制文件即可：

```bash
# 如果在 PATH 中
rm $(which git-contrib)

# 如果在特定目录
rm /path/to/git-contrib
```

## 故障排除

### 权限错误（Linux/macOS）

```bash
chmod +x git-contrib
```

### 命令找不到

确保 `git-contrib` 在你的 PATH 环境变量中：

```bash
# 检查当前位置
which git-contrib

# 或添加到 PATH
export PATH=$PATH:/path/to/git-contrib
```

### Windows 安全警告

右键点击 `git-contrib.exe` → 属性 → 解除锁定（如果存在）
