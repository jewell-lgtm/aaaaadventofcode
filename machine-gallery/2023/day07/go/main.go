// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
package main

import (
	"fmt"
	"io"
	"os"
)

func main() {
	input, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}
	solve := part1
	if os.Getenv("AOC_PART") == "2" {
		solve = part2
	}
	fmt.Println(solve(string(input)))
}
