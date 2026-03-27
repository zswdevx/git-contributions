# Git Contributions Heatmap

一个类似于 GitHub 贡献热力图的本地 Git 仓库可视化 CLI 工具。

## 功能特性

- 📊 生成类似 GitHub 的贡献热力图（从今天往前推一年）
- 🎨 彩色终端输出，直观显示提交频率
- 📅 动态计算过去一年的数据
- 👤 支持按作者过滤（支持多个作者）
- 📈 显示统计信息和活跃天数排名
- 🎯 无需联网，完全本地运行
- ✅ 智能月份对齐，完美复刻 GitHub 风格

## 安装

### 一键安装（推荐）

**Windows** (PowerShell):
```powershell
iwr -useb https://raw.githubusercontent.com/zswdevx/git-contributions/main/install.ps1 | iex
```

**Linux / macOS**:
```bash
curl -fsSL https://raw.githubusercontent.com/zswdevx/git-contributions/main/install.sh | bash
```

安装后即可全局使用：
```bash
git-contrib version
git-contrib heatmap
```

详细安装说明请查看 [INSTALL.md](INSTALL.md)。

### 其他安装方式

<details>
<summary>点击展开</summary>

#### 手动下载

从 [Releases](https://github.com/zswdevx/git-contributions/releases) 页面下载对应平台的二进制文件。

#### Go install

```bash
go install github.com/zswdevx/git-contributions@latest
```

#### 从源码编译

```bash
git clone https://github.com/zswdevx/git-contributions.git
cd git-contributions
go mod tidy
go build -o git-contrib .
```

</details>

## 使用方法

### 基本使用

在 Git 仓库目录中运行:

```bash
git-contrib heatmap
```

工具会自动显示从今天往前推一年的提交历史。

### 指定仓库路径

```bash
git-contrib heatmap --path /path/to/your/repo
```

### 指定年份（查看特定年份）

```bash
git-contrib heatmap --year 2025
```

### 按作者过滤

```bash
# 单个作者
git-contrib heatmap --author "Your Name"

# 多个作者（多次使用 -a 参数）
git-contrib heatmap -a "Author1" -a "Author2"
```

## 参数说明

| 参数 | 短参数 | 说明 | 默认值 |
|------|--------|------|--------|
| `--path` | `-p` | Git 仓库路径 | 当前目录 |
| `--author` | `-a` | 作者名称(可多次指定) | 所有作者 |
| `--year` | `-y` | 年份(可选) | 显示过去一年 |

**注意**:
- 如果不指定年份，工具会显示从今天往前推一年的数据（类似 GitHub 风格）
- 支持多个作者过滤，需多次使用 `-a` 参数：`-a "Author1" -a "Author2"`

## 输出说明

### 热力图颜色

- ⬜ **灰色**: 无提交
- 🟩 **绿色**: 低频提交 (1-25%)
- 🟨 **黄色**: 中频提交 (25-50%)
- 🟪 **紫色**: 高频提交 (50-75%)
- 🟥 **红色**: 超高频提交 (75-100%)

### 统计信息

工具会显示以下统计信息:
- 总提交数
- 活跃天数
- 平均每天提交次数
- 最活跃的5天排名

## 示例输出

```
 2025年3月 - 2026年3月27日 Git 贡献热力图

      Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan Feb
日  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
一  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
二  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
三  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
四  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
五  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
六  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

颜色说明:
■ 无提交  ■ 低频(1-25%)  ■ 中频(25-50%)  ■ 高频(50-75%)  ■ 超高频(75-100%)

统计信息:
  总提交数: 523
  活跃天数: 187
  平均每天: 2.8 次

最活跃的5天:
+------+------------+--------+
| 排名 |    日期    | 提交数 |
+------+------------+--------+
|    1 | 2025-03-15 |     23 |
|    2 | 2025-07-22 |     18 |
|    3 | 2025-11-08 |     15 |
|    4 | 2025-05-30 |     12 |
|    5 | 2025-09-12 |     11 |
+------+------------+--------+
```

## 技术栈

- **Go 1.21+** - 编程语言
- **go-git** - Git 仓库解析
- **cobra** - CLI 框架
- **gookit/color** - 终端颜色输出
- **tablewriter** - 表格输出

## 开发计划

- [ ] 支持导出为图片
- [ ] 添加月度/季度视图
- [ ] 支持多仓库对比
- [ ] Web 界面展示
- [ ] 支持更多 Git 托管平台格式

## 贡献

欢迎提交 Issue 和 Pull Request!

## 许可证

MIT License
