// One alternation regex finds mul/do/don't in order; a flag toggles as we walk the matches.
package main

import "regexp"

var instructionPattern = regexp.MustCompile(`mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)`)

func part2(input string) any {
	total, enabled := 0, true
	for _, m := range instructionPattern.FindAllStringSubmatch(input, -1) {
		switch m[0] {
		case "do()":
			enabled = true
		case "don't()":
			enabled = false
		default:
			if enabled {
				total += product(m[1], m[2])
			}
		}
	}
	return total
}
