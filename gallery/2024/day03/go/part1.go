// Regex scan: find every well-formed mul(X,Y) and sum the products.
// regexp is RE2, so it's linear-time and has no backtracking surprises.
package main

import (
	"regexp"
	"strconv"
)

var mulPattern = regexp.MustCompile(`mul\((\d{1,3}),(\d{1,3})\)`)

func part1(input string) any {
	total := 0
	for _, m := range mulPattern.FindAllStringSubmatch(input, -1) {
		total += product(m[1], m[2])
	}
	return total
}

func product(a, b string) int {
	x, _ := strconv.Atoi(a)
	y, _ := strconv.Atoi(b)
	return x * y
}
