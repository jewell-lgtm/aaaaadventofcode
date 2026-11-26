FROM golang:1.27-bookworm
ENV GOFLAGS=-buildvcs=false GOTOOLCHAIN=local
WORKDIR /aoc
# Warm the build cache with the std packages the template and gallery use.
RUN mkdir /tmp/warm && cd /tmp/warm && go mod init warm && \
    printf 'package main\nimport (_ "encoding/json"; _ "regexp"; _ "sort"; _ "slices"; _ "maps"; _ "container/heap"; _ "math/big"; _ "strconv"; _ "fmt"; _ "strings")\nfunc main() {}\n' > main.go && \
    go build -o /dev/null . && rm -rf /tmp/warm
