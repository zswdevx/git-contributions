# 更新日志

本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.0.0] - 2026-03-27

### 新增功能 ✨

- 🎉 **首次发布** - Git 贡献热力图 CLI 工具
- 📊 **GitHub 风格热力图** - 完美复刻 GitHub 贡献热力图显示风格
  - 动态计算过去一年的数据（从今天往前推一年）
  - 智能月份标签对齐
  - 彩色输出：灰/绿/黄/紫/红表示不同提交频率
- 📈 **详细统计信息**
  - 总提交数统计
  - 活跃天数统计
  - 平均每天提交次数
  - 最活跃的 5 天排名表格
- 👤 **多作者过滤** - 支持按作者名称过滤提交（可多次指定 `-a` 参数）
- 📅 **年份选择** - 支持查看特定年份的贡献数据
- 🎯 **完全本地运行** - 无需联网，直接解析本地 Git 仓库
- 🔍 **版本命令** - `git-contrib version` 显示详细的版本信息

### 技术特性 🛠️

- 使用 Go 1.21+ 开发
- 支持跨平台编译（Windows/Linux/macOS）
- 零依赖运行时，单文件部署
- 版本信息注入（通过 `-ldflags`）
- Cobra CLI 框架，提供友好的命令行界面
- 完善的构建系统（Makefile）

### 文档 📚

- 完整的 README 文档
- 安装指南 (INSTALL.md)
- 项目结构说明 (PROJECT_STRUCTURE.md)
- 更新日志 (CHANGELOG.md)

### CI/CD 🚀

- GitHub Actions 自动发布流程
- 支持 Windows/Linux/macOS 多平台构建
- 自动创建 GitHub Release
- 提供预编译二进制文件下载

---

## 版本命名规则

- **主版本号 (MAJOR)**: 不兼容的 API 修改
- **次版本号 (MINOR)**: 向下兼容的功能新增
- **修订号 (PATCH)**: 向下兼容的问题修复

## 发布说明

每个版本发布包含：

1. **源代码**: 完整的源代码压缩包
2. **预编译二进制**:
   - Windows (amd64): `git-contrib-windows-amd64.exe.tar.gz`
   - Linux (amd64): `git-contrib-linux-amd64.tar.gz`
   - macOS Intel (amd64): `git-contrib-darwin-amd64.tar.gz`
   - macOS Apple Silicon (arm64): `git-contrib-darwin-arm64.tar.gz`
3. **校验文件**: SHA256 校验和

## 安装方式

详见 [INSTALL.md](INSTALL.md)

## 使用示例

```bash
# 显示过去一年的贡献（默认）
git-contrib heatmap

# 查看特定年份
git-contrib heatmap --year 2025

# 按作者过滤
git-contrib heatmap -a "zsw"

# 多个作者
git-contrib heatmap -a "Author1" -a "Author2"

# 指定仓库路径
git-contrib heatmap -p /path/to/repo

# 查看版本信息
git-contrib version
```

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

[MIT License](LICENSE)
