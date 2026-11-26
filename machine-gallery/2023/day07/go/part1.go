// Each hand gets a sort key: its card-count shape (e.g. [3 2] for a full house)
// then its card values. slices.SortFunc + cmp.Or chain the two comparisons.
package main

import (
	"cmp"
	"slices"
	"strconv"
	"strings"
)

func part1(input string) any {
	return totalWinnings(input, "23456789TJQKA", false)
}

type hand struct {
	shape  []int // card counts, largest first
	values []int // card strengths in hand order
	bid    int
}

func totalWinnings(input, order string, jokers bool) int {
	var hands []hand
	for _, line := range strings.Split(strings.TrimSpace(input), "\n") {
		cards, bidText, _ := strings.Cut(line, " ")
		bid, _ := strconv.Atoi(bidText)
		h := hand{shape: shapeOf(cards, jokers), bid: bid}
		for _, c := range cards {
			h.values = append(h.values, strings.IndexRune(order, c))
		}
		hands = append(hands, h)
	}

	slices.SortFunc(hands, func(a, b hand) int {
		return cmp.Or(slices.Compare(a.shape, b.shape), slices.Compare(a.values, b.values))
	})
	total := 0
	for rank, h := range hands {
		total += (rank + 1) * h.bid
	}
	return total
}

// shapeOf returns card counts sorted descending. With jokers, J joins the biggest group.
func shapeOf(cards string, jokers bool) []int {
	counts := map[rune]int{}
	for _, c := range cards {
		counts[c]++
	}
	wild := 0
	if jokers {
		wild = counts['J']
		delete(counts, 'J')
	}
	shape := make([]int, 0, len(counts))
	for _, n := range counts {
		shape = append(shape, n)
	}
	slices.SortFunc(shape, func(a, b int) int { return b - a })
	if len(shape) == 0 {
		return []int{wild}
	}
	shape[0] += wild
	return shape
}
