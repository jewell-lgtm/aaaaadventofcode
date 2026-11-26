// Unfold each record five times; the memoised count handles the blow-up.
package main

import (
	"slices"
	"strings"
)

func part2(input string) any {
	total := 0
	for _, line := range strings.Split(strings.TrimSpace(input), "\n") {
		springs, groups := parseRecord(line)
		unfolded := strings.Join(slices.Repeat([]string{springs}, 5), "?")
		total += arrangements(unfolded, slices.Repeat(groups, 5))
	}
	return total
}
