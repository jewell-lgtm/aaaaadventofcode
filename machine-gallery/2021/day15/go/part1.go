// Dijkstra with container/heap. Go's heap wants a type implementing heap.Interface,
// which is a few lines of boilerplate but keeps the search loop itself plain.
package main

import (
	"container/heap"
	"math"
	"strings"
)

type cave [][]int

func part1(input string) any {
	return parseCave(input).lowestTotalRisk(1)
}

func parseCave(input string) cave {
	var c cave
	for _, line := range strings.Fields(input) {
		row := make([]int, len(line))
		for i, ch := range line {
			row[i] = int(ch - '0')
		}
		c = append(c, row)
	}
	return c
}

// lowestTotalRisk runs Dijkstra over the cave repeated tiles×tiles times.
// Each tile step adds 1 to the risk, wrapping 9 back round to 1.
func (c cave) lowestTotalRisk(tiles int) int {
	h, w := len(c), len(c[0])
	rows, cols := h*tiles, w*tiles
	risk := func(r, col int) int {
		return (c[r%h][col%w]+r/h+col/w-1)%9 + 1
	}

	dist := make([]int, rows*cols)
	for i := range dist {
		dist[i] = math.MaxInt
	}
	dist[0] = 0
	pq := &queue{{pos: 0, risk: 0}}
	for pq.Len() > 0 {
		cur := heap.Pop(pq).(state)
		if cur.risk > dist[cur.pos] {
			continue
		}
		r, col := cur.pos/cols, cur.pos%cols
		if r == rows-1 && col == cols-1 {
			return cur.risk
		}
		for _, d := range [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}} {
			nr, nc := r+d[0], col+d[1]
			if nr < 0 || nr >= rows || nc < 0 || nc >= cols {
				continue
			}
			next := state{pos: nr*cols + nc, risk: cur.risk + risk(nr, nc)}
			if next.risk < dist[next.pos] {
				dist[next.pos] = next.risk
				heap.Push(pq, next)
			}
		}
	}
	return -1
}

type state struct{ pos, risk int }

// queue is a min-heap of states ordered by risk.
type queue []state

func (q queue) Len() int           { return len(q) }
func (q queue) Less(i, j int) bool { return q[i].risk < q[j].risk }
func (q queue) Swap(i, j int)      { q[i], q[j] = q[j], q[i] }
func (q *queue) Push(x any)        { *q = append(*q, x.(state)) }
func (q *queue) Pop() any {
	old := *q
	last := old[len(old)-1]
	*q = old[:len(old)-1]
	return last
}
