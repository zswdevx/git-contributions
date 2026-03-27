#!/bin/bash

# Git Contributions Heatmap 演示脚本

echo "====================================="
echo "Git Contributions Heatmap 演示"
echo "====================================="
echo ""

# 显示帮助
echo "1. 显示帮助信息:"
./git-contrib.exe --help
echo ""
echo "按 Enter 继续..."
read

# 显示 heatmap 帮助
echo "2. 显示 heatmap 命令帮助:"
./git-contrib.exe heatmap --help
echo ""
echo "按 Enter 继续..."
read

# 当前目录热力图(如果有 Git 仓库)
if [ -d .git ]; then
    echo "3. 显示当前仓库的热力图:"
    ./git-contrib.exe heatmap
    echo ""
fi

echo "演示完成!"
