// BFS on the grid, run backwards from E so both parts share one search:
// a step q→p is legal when p is at most one higher than q.
// Plain slices as the queue and the visited grid; no containers needed.
package main

import "strings"

type point struct{ r, c int }

type heightmap struct {
	grid       [][]byte
	start, end point
}

func part1(input string) any {
	h := parseHeightmap(input)
	return h.stepsFromEnd(func(p point) bool { return p == h.start })
}

func parseHeightmap(input string) heightmap {
	var h heightmap
	for r, line := range strings.Split(strings.TrimSpace(input), "\n") {
		row := []byte(line)
		for c, ch := range row {
			switch ch {
			case 'S':
				h.start, row[c] = point{r, c}, 'a'
			case 'E':
				h.end, row[c] = point{r, c}, 'z'
			}
		}
		h.grid = append(h.grid, row)
	}
	return h
}

// stepsFromEnd walks downhill from E and returns the distance to the first square where done holds.
func (h heightmap) stepsFromEnd(done func(point) bool) int {
	dist := make([][]int, len(h.grid))
	for r := range dist {
		dist[r] = make([]int, len(h.grid[r]))
		for c := range dist[r] {
			dist[r][c] = -1
		}
	}
	dist[h.end.r][h.end.c] = 0
	queue := []point{h.end}
	for len(queue) > 0 {
		p := queue[0]
		queue = queue[1:]
		if done(p) {
			return dist[p.r][p.c]
		}
		for _, d := range []point{{-1, 0}, {1, 0}, {0, -1}, {0, 1}} {
			q := point{p.r + d.r, p.c + d.c}
			if q.r < 0 || q.r >= len(h.grid) || q.c < 0 || q.c >= len(h.grid[q.r]) {
				continue
			}
			if dist[q.r][q.c] >= 0 || h.grid[p.r][p.c] > h.grid[q.r][q.c]+1 {
				continue
			}
			dist[q.r][q.c] = dist[p.r][p.c] + 1
			queue = append(queue, q)
		}
	}
	return -1
}
