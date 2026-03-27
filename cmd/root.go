package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "git-contrib",
	Short: "Git贡献热力图可视化工具",
	Long: `一个类似于GitHub贡献热力图的本地Git仓库可视化CLI工具。
可以显示你的Git提交历史，生成漂亮的贡献热力图。`,
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func init() {
	rootCmd.AddCommand(heatmapCmd)
}
