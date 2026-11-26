// Count arrangements with a memoised recursion over (position, group index).
// The memo is a 2D slice; a recursive closure keeps it in scope.
package main

import (
	"strconv"
	"strings"
)

func part1(input string) any {
	total := 0
	for _, line := range strings.Split(strings.TrimSpace(input), "\n") {
		springs, groups := parseRecord(line)
		total += arrangements(springs, groups)
	}
	return total
}

func parseRecord(line string) (string, []int) {
	springs, groupText, _ := strings.Cut(line, " ")
	var groups []int
	for _, g := range strings.Split(groupText, ",") {
		n, _ := strconv.Atoi(g)
		groups = append(groups, n)
	}
	return springs, groups
}

func arrangements(springs string, groups []int) int {
	memo := make([][]int, len(springs)+2)
	for i := range memo {
		memo[i] = make([]int, len(groups)+1)
		for g := range memo[i] {
			memo[i][g] = -1
		}
	}

	// fits reports whether a run of n damaged springs can start at i.
	fits := func(i, n int) bool {
		if i+n > len(springs) || strings.Contains(springs[i:i+n], ".") {
			return false
		}
		return i+n == len(springs) || springs[i+n] != '#'
	}

	var count func(i, g int) int
	count = func(i, g int) int {
		if i >= len(springs) {
			if g == len(groups) {
				return 1
			}
			return 0
		}
		if memo[i][g] >= 0 {
			return memo[i][g]
		}
		ways := 0
		if springs[i] != '#' { // treat as operational
			ways += count(i+1, g)
		}
		if springs[i] != '.' && g < len(groups) && fits(i, groups[g]) { // start a damaged run here
			ways += count(i+groups[g]+1, g+1)
		}
		memo[i][g] = ways
		return ways
	}
	return count(0, 0)
}
