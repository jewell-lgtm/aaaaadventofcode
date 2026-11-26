// Three-sum: sort once, then a two-pointer sweep for each first entry, O(n²).
// A switch with no tag reads like a chain of guards.
package main

import "slices"

func part2(input string) any {
	entries := parseEntries(input)
	slices.Sort(entries)
	for i, a := range entries {
		lo, hi := i+1, len(entries)-1
		for lo < hi {
			switch sum := a + entries[lo] + entries[hi]; {
			case sum == 2020:
				return a * entries[lo] * entries[hi]
			case sum < 2020:
				lo++
			default:
				hi--
			}
		}
	}
	return "no triple"
}
