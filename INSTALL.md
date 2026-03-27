# 安装指南

## 方式一：下载预编译二进制（推荐）

从 [Releases](https://github.com/zswdevx/git-contributions/releases) 页面下载适合你系统的版本：

### Windows

```powershell
# 下载 git-contrib-windows-amd64.exe.tar.gz
# 解压后重命名为 git-contrib.exe
# 添加到 PATH 环境变量或放在任意目录直接运行
```

### Linux / macOS

```bash
# 下载
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
