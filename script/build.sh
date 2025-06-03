#!/bin/bash

ldflags="-s -w"
target="graph"

go env -w GOPROXY=https://goproxy.cn,direct

# Executable
CGO_ENABLED=1 GOARCH=$(go env GOARCH) GOOS=$(go env GOOS) go build -ldflags "$ldflags" -o bin/$target main.go

# Library
CGO_ENABLED=1 GOARCH=$(go env GOARCH) GOOS=$(go env GOOS) go build -ldflags "$ldflags" -buildmode=c-archive -o bin/$target.a main.go

# Test
g++ -o bin/test -I bin test/main.cc bin/$target.a -lpthread
