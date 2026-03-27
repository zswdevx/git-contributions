# 更新日志

## v1.1.0 (2026-03-27)

### 重大改进 🎉

#### 1. GitHub 风格时间范围显示
- **之前**: 显示整个年份的数据，导致大部分时间为空白
- **现在**: 自动显示从今天往前推一年的数据
- **效果**: 最新数据显示在右侧，类似 GitHub 的显示方式

#### 2. 月份标签智能对齐
- **之前**: 月份标签固定显示，占位不均匀
- **现在**: 根据实际日期位置动态计算月份标签位置
- **效果**: 月份标签准确对齐到对应的列，完美复刻 GitHub 风格

#### 3. 构建优化
- 编译后自动复制到 `D:\tools\bin\` 目录
- 更新 Makefile 支持自动部署

### 技术细节

**时间范围计算**:
```go
now := time.Now()
startDate := now.AddDate(-1, 0, 0)  // 从今天往前推一年
```

**月份位置映射**:
```go
monthPositions := make(map[int]int)
for week := 0; week < totalWeeks; week++ {
    // 计算该周的日期并记录月份位置
    date := startDate.AddDate(0, 0, daysFromStart)
    monthPositions[int(date.Month())] = week
}
```

### 使用示例

```bash
# 显示过去一年的贡献（默认）
./git-contrib heatmap

# 查看特定年份
./git-contrib heatmap --year 2025

# 按作者过滤
./git-contrib heatmap -a "zsw"
```

---

## v1.0.0 (2026-03-27)

### 初始版本

- ✅ 基本的 Git 仓库解析功能
- ✅ 彩色热力图输出
- ✅ 统计信息显示
- ✅ 按年份和作者过滤
- ✅ 命令行参数支持
