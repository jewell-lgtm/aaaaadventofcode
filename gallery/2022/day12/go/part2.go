// Same backwards BFS from E; stop at the first square of elevation 'a'.
package main

func part2(input string) any {
	h := parseHeightmap(input)
	return h.stepsFromEnd(func(p point) bool { return h.grid[p.r][p.c] == 'a' })
}
