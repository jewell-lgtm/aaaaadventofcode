// Two-sum with a set: for each entry, check whether its complement was already seen.
// Go has no set type; map[int]bool is the idiomatic stand-in.
package main

import (
	"strconv"
	"strings"
)

func part1(input string) any {
	seen := map[int]bool{}
	for _, n := range parseEntries(input) {
		if seen[2020-n] {
			return n * (2020 - n)
		}
		seen[n] = true
	}
	return "no pair"
}

func parseEntries(input string) []int {
	var entries []int
	for _, field := range strings.Fields(input) {
		n, err := strconv.Atoi(field)
		if err != nil {
			panic(err)
		}
		entries = append(entries, n)
	}
	return entries
}
