package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"github.com/zsw/git-contributions/version"
)

var rootCmd = &cobra.Command{
	Use:   "git-contrib",
	Short: "Git贡献热力图可视化工具",
	Long: `一个类似于GitHub贡献热力图的本地Git仓库可视化CLI工具。
可以显示你的Git提交历史，生成漂亮的贡献热力图。`,
}

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "显示版本信息",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(version.GetVersionInfo())
	},
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func init() {
	rootCmd.AddCommand(heatmapCmd)
	rootCmd.AddCommand(versionCmd)
}
