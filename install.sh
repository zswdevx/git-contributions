#!/bin/bash
# git-contrib Linux/macOS 安装脚本
# 使用方法: curl -fsSL https://raw.githubusercontent.com/zswdevx/git-contributions/main/install.sh | bash

set -e

REPO_URL="https://github.com/zswdevx/git-contributions"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
VERSION="${VERSION:-latest}"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}=========================================="
echo -e "  git-contrib 安装程序"
echo -e "==========================================${NC}"
echo ""

# 检测系统信息
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
    x86_64|amd64)
        ARCH="amd64"
        ;;
    aarch64|arm64)
        ARCH="arm64"
        ;;
    i386|i686)
        ARCH="386"
        ;;
    *)
        echo -e "${RED}[错误] 不支持的架构: $ARCH${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}[信息] 检测到系统: $OS $ARCH${NC}"

# 确定下载 URL
if [ "$VERSION" = "latest" ]; then
    DOWNLOAD_URL="$REPO_URL/releases/latest/download/git-contrib-$OS-$ARCH.tar.gz"
else
    DOWNLOAD_URL="$REPO_URL/releases/download/$VERSION/git-contrib-$OS-$ARCH.tar.gz"
fi

echo -e "${YELLOW}[信息] 下载地址: $DOWNLOAD_URL${NC}"

# 创建临时目录
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# 下载
echo -e "${YELLOW}[1/4] 正在下载 git-contrib...${NC}"
if command -v wget &> /dev/null; then
    wget -q --show-progress "$DOWNLOAD_URL" -O "$TEMP_DIR/git-contrib.tar.gz"
elif command -v curl &> /dev/null; then
    curl -fsSL "$DOWNLOAD_URL" -o "$TEMP_DIR/git-contrib.tar.gz"
else
    echo -e "${RED}[错误] 需要 wget 或 curl${NC}"
    exit 1
fi
echo -e "${GREEN}[完成] 下载完成${NC}"

# 解压
echo -e "${YELLOW}[2/4] 正在解压...${NC}"
tar -xzf "$TEMP_DIR/git-contrib.tar.gz" -C "$TEMP_DIR"
echo -e "${GREEN}[完成] 解压完成${NC}"

# 安装
echo -e "${YELLOW}[3/4] 正在安装...${NC}"
mkdir -p "$INSTALL_DIR"

# 查找可执行文件
BINARY=$(find "$TEMP_DIR" -type f -name "git-contrib*" ! -name "*.tar.gz" | head -n1)
if [ -z "$BINARY" ]; then
    echo -e "${RED}[错误] 找不到可执行文件${NC}"
    exit 1
fi

mv "$BINARY" "$INSTALL_DIR/git-contrib"
chmod +x "$INSTALL_DIR/git-contrib"
echo -e "${GREEN}[完成] 已安装到: $INSTALL_DIR/git-contrib${NC}"

# 配置 PATH
echo -e "${YELLOW}[4/4] 正在配置环境变量...${NC}"
SHELL_RC=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "git-contrib" "$SHELL_RC" 2>/dev/null; then
        echo "" >> "$SHELL_RC"
        echo "# git-contrib" >> "$SHELL_RC"
        echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
        echo -e "${GREEN}[完成] 已添加到 $SHELL_RC${NC}"
    else
        echo -e "${YELLOW}[跳过] PATH 中已存在${NC}"
    fi
fi

# 添加到当前会话
export PATH="$PATH:$INSTALL_DIR"

echo ""
echo -e "${CYAN}=========================================="
echo -e "  安装完成！"
echo -e "==========================================${NC}"
echo ""
echo -e "安装位置: $INSTALL_DIR/git-contrib"
echo ""
echo -e "${YELLOW}现在可以在任意目录运行：${NC}"
echo -e "  git-contrib version"
echo -e "  git-contrib heatmap"
echo ""
echo -e "${YELLOW}提示: 请运行以下命令使 PATH 生效：${NC}"
if [ -n "$SHELL_RC" ]; then
    echo -e "  source $SHELL_RC"
fi
echo ""

# 显示版本信息
"$INSTALL_DIR/git-contrib" version
