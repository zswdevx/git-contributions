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

# Build the project
build:
	$(GOBUILD) -o $(BINARY_NAME).exe .
	@echo "Build complete: $(BINARY_NAME).exe"
	@cp $(BINARY_NAME).exe D:\\tools\\bin\\
	@echo "Copied to D:\\tools\\bin\\$(BINARY_NAME).exe"

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
	$(GOBUILD) -o $(GOPATH)/bin/$(BINARY_NAME).exe .
	@cp $(BINARY_NAME).exe D:\\tools\\bin\\
	@echo "Installed to D:\\tools\\bin\\$(BINARY_NAME).exe"

# Run the tool on current directory
run:
	./$(BINARY_NAME).exe heatmap

# Cross-compilation for Linux
build-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_UNIX) .

# Cross-compilation for macOS
build-darwin:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 $(GOBUILD) -o $(BINARY_NAME)_darwin .

# Build all platforms
build-all: build build-linux build-darwin
