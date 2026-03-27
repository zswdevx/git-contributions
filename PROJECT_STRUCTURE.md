# 项目结构

```
git-contributions/
├── cmd/                 # 命令行相关代码
│   ├── root.go         # 根命令定义
│   └── heatmap.go      # 热力图命令实现
├── main.go             # 程序入口
├── go.mod              # Go 模块定义
├── go.sum              # 依赖校验文件
├── Makefile            # 构建脚本
├── README.md           # 项目说明文档
├── LICENSE             # MIT 许可证
├── .gitignore          # Git 忽略文件
├── demo.sh             # 演示脚本
└── git-contrib.exe     # 编译后的可执行文件
```

## 代码说明

### main.go
程序入口文件,导入并执行 `cmd` 包中的命令。

### cmd/root.go
- 定义了根命令 `rootCmd`
- 使用 Cobra 框架管理 CLI 命令
- 添加了 `heatmap` 子命令

### cmd/heatmap.go
核心功能实现:

1. **参数解析**:
   - `--path` / `-p`: Git 仓库路径
   - `--author` / `-a`: 作者过滤
   - `--year` / `-y`: 指定年份

2. **主要函数**:
   - `generateHeatmap()`: 读取 Git 仓库并统计提交数据
   - `renderHeatmap()`: 渲染彩色热力图到终端
   - `showTopDays()`: 显示最活跃的 5 天统计表格

3. **颜色映射**:
   - 灰色: 无提交
   - 绿色: 低频 (1-25%)
   - 黄色: 中频 (25-50%)
   - 紫色: 高频 (50-75%)
   - 红色: 超高频 (75-100%)

## 依赖库

- **github.com/go-git/go-git/v5**: Git 仓库解析
- **github.com/spf13/cobra**: CLI 框架
- **github.com/gookit/color**: 终端彩色输出
- **github.com/olekukonko/tablewriter**: 表格格式化输出

## 构建流程

1. 下载依赖: `go mod tidy`
2. 编译项目: `go build -o git-contrib.exe .`
3. 运行工具: `./git-contrib.exe heatmap`

或使用 Makefile:
```bash
make deps   # 下载依赖
make build  # 编译项目
make run    # 运行工具
```
