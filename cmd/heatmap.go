package cmd

import (
	"fmt"
	"os"
	"time"

	"github.com/go-git/go-git/v5"
	"github.com/go-git/go-git/v5/plumbing/object"
	"github.com/gookit/color"
	"github.com/olekukonko/tablewriter"
	"github.com/spf13/cobra"
)

var (
	repoPath   string
	authorName string
	year       int
)

var heatmapCmd = &cobra.Command{
	Use:   "heatmap",
	Short: "显示Git贡献热力图",
	Long:  `生成类似GitHub的贡献热力图，显示过去一年的提交统计。`,
	Run: func(cmd *cobra.Command, args []string) {
		if repoPath == "" {
			repoPath = "."
		}

		// 如果没有指定年份，则显示过去一年（从今天往前推一年）
		if year == 0 {
			year = time.Now().Year()
		}

		err := generateHeatmap(repoPath, authorName, year)
		if err != nil {
			fmt.Fprintf(os.Stderr, "错误: %v\n", err)
			os.Exit(1)
		}
	},
}

func init() {
	heatmapCmd.Flags().StringVarP(&repoPath, "path", "p", ".", "Git仓库路径")
	heatmapCmd.Flags().StringVarP(&authorName, "author", "a", "", "作者名称(可选)")
	heatmapCmd.Flags().IntVarP(&year, "year", "y", time.Now().Year(), "年份")
}

func generateHeatmap(repoPath, authorName string, year int) error {
	// 打开Git仓库
	repo, err := git.PlainOpen(repoPath)
	if err != nil {
		return fmt.Errorf("无法打开Git仓库: %w", err)
	}

	// 获取提交历史
	commitIter, err := repo.Log(&git.LogOptions{
		Order: git.LogOrderCommitterTime,
	})
	if err != nil {
		return fmt.Errorf("无法读取提交历史: %w", err)
	}

	// 统计每天的提交数量
	commitCounts := make(map[string]int)

	// 计算日期范围：从今天往前推一年
	now := time.Now()
	startDate := now.AddDate(-1, 0, 0)

	err = commitIter.ForEach(func(c *object.Commit) error {
		commitTime := c.Author.When

		// 只统计过去一年的提交
		if commitTime.Before(startDate) || commitTime.After(now) {
			return nil
		}

		// 如果指定了作者，则过滤作者
		if authorName != "" && c.Author.Name != authorName {
			return nil
		}

		// 按日期统计
		dateStr := commitTime.Format("2006-01-02")
		commitCounts[dateStr]++
		return nil
	})

	if err != nil {
		return fmt.Errorf("遍历提交历史失败: %w", err)
	}

	// 渲染热力图
	renderHeatmap(commitCounts, startDate, now)

	return nil
}

func renderHeatmap(commitCounts map[string]int, startDate, endDate time.Time) {
	// 月份名称
	months := []string{"Jan", "Feb", "Mar", "Apr", "May", "Jun",
		"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}

	// 计算起始日期所在的星期（从周日开始）
	startWeekday := int(startDate.Weekday())

	// 计算总周数（一年大约52-53周）
	totalDays := int(endDate.Sub(startDate).Hours() / 24)
	totalWeeks := (totalDays + startWeekday + 6) / 7
	if totalWeeks > 53 {
		totalWeeks = 53
	}

	// 创建网格 (每行代表星期，共7行，totalWeeks列)
	grid := make([][]int, 7)
	for i := range grid {
		grid[i] = make([]int, totalWeeks)
	}

	// 填充提交数据
	for dateStr, count := range commitCounts {
		t, err := time.Parse("2006-01-02", dateStr)
		if err != nil {
			continue
		}

		// 计算从起始日期到该日期的天数
		daysFromStart := int(t.Sub(startDate).Hours() / 24)
		if daysFromStart < 0 {
			continue
		}

		// 计算周数和星期
		week := daysFromStart / 7
		weekday := int(t.Weekday())

		if week < totalWeeks && weekday < 7 {
			grid[weekday][week] = count
		}
	}

	// 找出最大提交数用于计算颜色深度
	maxCount := 0
	for _, row := range grid {
		for _, count := range row {
			if count > maxCount {
				maxCount = count
			}
		}
	}

	// 打印标题
	startYear, startMonth, _ := startDate.Date()
	endYear, endMonth, endDay := endDate.Date()
	fmt.Printf("\n %d年%d月 - %d年%d月%d日 Git 贡献热力图\n\n",
		startYear, startMonth, endYear, endMonth, endDay)

	// 打印月份标签
	fmt.Print("     ") // 星期标签的宽度（2个中文字符 + 1个空格 = 大约5个字符宽度）
	lastMonth := 0
	for week := 0; week < totalWeeks; week++ {
		// 计算该周的日期
		daysFromStart := week*7 - startWeekday
		if daysFromStart < 0 {
			daysFromStart = 0
		}
		date := startDate.AddDate(0, 0, daysFromStart)
		month := int(date.Month())

		// 如果是新的月份，在该周的第一天打印月份标签
		if month != lastMonth {
			// 月份名称占3个字符，我们需要在正确的位置打印
			fmt.Printf("%-3s", months[month-1])
			lastMonth = month
		} else {
			// 打印空格来填充（每个格子是2个字符）
			fmt.Print("  ")
		}
	}
	fmt.Println()

	// 打印热力图
	weekDaysShort := []string{"日", "一", "二", "三", "四", "五", "六"}

	for weekday := 0; weekday < 7; weekday++ {
		fmt.Printf("  %s ", weekDaysShort[weekday])

		for week := 0; week < totalWeeks; week++ {
			count := grid[weekday][week]

			if count == 0 {
				// 无提交 - 浅灰色
				fmt.Print(color.Gray.Sprint("■ "))
			} else {
				// 根据提交数量显示不同颜色
				intensity := float64(count) / float64(maxCount)
				if intensity < 0.25 {
					fmt.Print(color.Green.Sprint("■ "))
				} else if intensity < 0.5 {
					fmt.Print(color.Yellow.Sprint("■ "))
				} else if intensity < 0.75 {
					fmt.Print(color.Magenta.Sprint("■ "))
				} else {
					fmt.Print(color.Red.Sprint("■ "))
				}
			}
		}
		fmt.Println()
	}

	// 打印统计信息
	fmt.Println()
	fmt.Println("颜色说明:")
	fmt.Printf("%s 无提交  %s 低频(1-25%%)  %s 中频(25-50%%)  %s 高频(50-75%%)  %s 超高频(75-100%%)\n",
		color.Gray.Sprint("■"),
		color.Green.Sprint("■"),
		color.Yellow.Sprint("■"),
		color.Magenta.Sprint("■"),
		color.Red.Sprint("■"))

	// 统计总数
	totalCommits := 0
	for _, count := range commitCounts {
		totalCommits += count
	}
	daysWithCommits := len(commitCounts)

	fmt.Printf("\n统计信息:\n")
	fmt.Printf("  总提交数: %d\n", totalCommits)
	fmt.Printf("  活跃天数: %d\n", daysWithCommits)
	if daysWithCommits > 0 {
		fmt.Printf("  平均每天: %.1f 次\n", float64(totalCommits)/float64(daysWithCommits))
	}

	// 显示活跃度表格
	showTopDays(commitCounts)
}

func showTopDays(commitCounts map[string]int) {
	// 找出最活跃的5天
	type dayCount struct {
		date  string
		count int
	}

	var days []dayCount
	for date, count := range commitCounts {
		days = append(days, dayCount{date, count})
	}

	// 按提交数排序
	for i := 0; i < len(days); i++ {
		for j := i + 1; j < len(days); j++ {
			if days[j].count > days[i].count {
				days[i], days[j] = days[j], days[i]
			}
		}
	}

	if len(days) > 5 {
		days = days[:5]
	}

	if len(days) > 0 {
		fmt.Println("\n最活跃的5天:")
		table := tablewriter.NewWriter(os.Stdout)
		table.Header([]string{"排名", "日期", "提交数"})

		for i, day := range days {
			table.Append([]string{
				fmt.Sprintf("%d", i+1),
				day.date,
				fmt.Sprintf("%d", day.count),
			})
		}

		table.Render()
	}
}
