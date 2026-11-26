// The CrateMover 9001 lifts several crates at once, so each move is one slice append.
package main

func part2(input string) any {
	stacks, moves := parseCrates(input)
	for _, m := range moves {
		cut := len(stacks[m.from]) - m.count
		stacks[m.to] = append(stacks[m.to], stacks[m.from][cut:]...)
		stacks[m.from] = stacks[m.from][:cut]
	}
	return tops(stacks)
}
