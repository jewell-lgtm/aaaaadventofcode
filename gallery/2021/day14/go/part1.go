// Track pair frequencies instead of the polymer itself: each step maps every
// pair AB (with rule AB -> C) to AC and CB. Maps keyed by 2-char strings.
package main

import (
	"maps"
	"slices"
	"strings"
)

func part1(input string) any {
	return polymerStrength(input, 10)
}

func polymerStrength(input string, steps int) int {
	template, ruleText, _ := strings.Cut(strings.TrimSpace(input), "\n\n")
	rules := map[string]byte{}
	for _, line := range strings.Split(strings.TrimSpace(ruleText), "\n") {
		pair, insert, _ := strings.Cut(line, " -> ")
		rules[pair] = insert[0]
	}

	pairs := map[string]int{}
	for i := 0; i+1 < len(template); i++ {
		pairs[template[i:i+2]]++
	}
	for range steps {
		next := map[string]int{}
		for pair, n := range pairs {
			if c, ok := rules[pair]; ok {
				next[string([]byte{pair[0], c})] += n
				next[string([]byte{c, pair[1]})] += n
			} else {
				next[pair] += n
			}
		}
		pairs = next
	}

	// Every element is the first letter of exactly one pair, except the last one.
	counts := map[byte]int{template[len(template)-1]: 1}
	for pair, n := range pairs {
		counts[pair[0]] += n
	}
	totals := slices.Collect(maps.Values(counts))
	return slices.Max(totals) - slices.Min(totals)
}
