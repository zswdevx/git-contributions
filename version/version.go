package version

import (
	"fmt"
	"runtime"
)

var (
	// 版本信息，编译时通过 -ldflags 注入
	Version   = "dev"
	GitCommit = "unknown"
	BuildDate = "unknown"
)

// Info 版本信息结构
type Info struct {
	Version   string
	GitCommit string
	BuildDate string
	GoVersion string
	Platform  string
}

// GetVersionInfo 获取版本信息
func GetVersionInfo() Info {
	return Info{
		Version:   Version,
		GitCommit: GitCommit,
		BuildDate: BuildDate,
		GoVersion: runtime.Version(),
		Platform:  fmt.Sprintf("%s/%s", runtime.GOOS, runtime.GOARCH),
	}
}

// String 格式化版本信息
func (i Info) String() string {
	return fmt.Sprintf(
		"git-contrib version %s\n  Git commit: %s\n  Build date: %s\n  Go version: %s\n  Platform: %s",
		i.Version, i.GitCommit, i.BuildDate, i.GoVersion, i.Platform,
	)
}
