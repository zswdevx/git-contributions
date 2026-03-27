.PHONY: build install clean test

# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GOMOD=$(GOCMD) mod

BINARY_NAME=git-contrib
BINARY_UNIX=$(BINARY_NAME)_unix

# 版本信息
VERSION=$(shell git describe --tags --always --dirty="-dev" 2>/dev/null || echo "dev")
GIT_COMMIT=$(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# 构建参数
LDFLAGS=-ldflags "-X github.com/zsw/git-contributions/version.Version=$(VERSION) \
	-X github.com/zsw/git-contributions/version.GitCommit=$(GIT_COMMIT) \
	-X github.com/zsw/git-contributions/version.BuildDate=$(BUILD_DATE)"

# Build the project
build:
	$(GOBUILD) $(LDFLAGS) -o $(BINARY_NAME).exe .
	@echo "Build complete: $(BINARY_NAME).exe (Version: $(VERSION), Commit: $(GIT_COMMIT))"

# Install dependencies
deps:
	$(GOMOD) download
	$(GOMOD) tidy

# Clean build files
clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME).exe
	rm -f $(BINARY_UNIX)

# Run tests
test:
	$(GOTEST) -v ./...

# Install binary to GOPATH
install:
	$(GOBUILD) $(LDFLAGS) -o $(GOPATH)/bin/$(BINARY_NAME).exe .
	@echo "Installed to $(GOPATH)/bin/$(BINARY_NAME).exe"

# Run the tool on current directory
run:
	./$(BINARY_NAME).exe heatmap

# Cross-compilation for Linux
build-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BINARY_UNIX) .

# Cross-compilation for macOS
build-darwin:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BINARY_NAME)_darwin .

# Build all platforms
build-all: build build-linux build-darwin
