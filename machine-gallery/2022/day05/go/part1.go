// Parse the crate drawing column by column into byte slices (bottom first), then
// replay the moves. Slices double as stacks: append to push, reslice to pop.
package main

import (
	"fmt"
	"strings"
)

type move struct{ count, from, to int }

func part1(input string) any {
	stacks, moves := parseCrates(input)
	for _, m := range moves {
		for range m.count {
			top := len(stacks[m.from]) - 1
			stacks[m.to] = append(stacks[m.to], stacks[m.from][top])
			stacks[m.from] = stacks[m.from][:top]
		}
	}
	return tops(stacks)
}

func parseCrates(input string) ([][]byte, []move) {
	drawing, procedure, _ := strings.Cut(input, "\n\n")
	rows := strings.Split(drawing, "\n")
	labels := rows[len(rows)-1]
	stacks := make([][]byte, len(strings.Fields(labels)))
	for i := len(rows) - 2; i >= 0; i-- {
		for s := range stacks {
			col := 1 + 4*s
			if col < len(rows[i]) && rows[i][col] != ' ' {
				stacks[s] = append(stacks[s], rows[i][col])
			}
		}
	}

	var moves []move
	for _, line := range strings.Split(strings.TrimSpace(procedure), "\n") {
		var m move
		if _, err := fmt.Sscanf(line, "move %d from %d to %d", &m.count, &m.from, &m.to); err != nil {
			panic(err)
		}
		m.from--
		m.to--
		moves = append(moves, m)
	}
	return stacks, moves
}

func tops(stacks [][]byte) string {
	var sb strings.Builder
	for _, s := range stacks {
		if len(s) > 0 {
			sb.WriteByte(s[len(s)-1])
		}
	}
	return sb.String()
}
