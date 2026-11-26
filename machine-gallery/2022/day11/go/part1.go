// Parse each monkey block into a struct holding a closure for its operation,
// then simulate rounds. Worry relief is a func parameter so part 2 can swap it.
package main

import (
	"fmt"
	"slices"
	"strconv"
	"strings"
)

type monkey struct {
	items           []int
	operation       func(old int) int
	divisor         int
	ifTrue, ifFalse int
}

func part1(input string) any {
	return monkeyBusiness(parseMonkeys(input), 20, func(w int) int { return w / 3 })
}

func parseMonkeys(input string) []monkey {
	var monkeys []monkey
	for _, block := range strings.Split(strings.TrimSpace(input), "\n\n") {
		lines := strings.Split(block, "\n")
		var m monkey
		_, items, _ := strings.Cut(lines[1], ": ")
		for _, item := range strings.Split(items, ", ") {
			n, _ := strconv.Atoi(item)
			m.items = append(m.items, n)
		}
		m.operation = parseOperation(strings.TrimPrefix(strings.TrimSpace(lines[2]), "Operation: new = "))
		fmt.Sscanf(strings.TrimSpace(lines[3]), "Test: divisible by %d", &m.divisor)
		fmt.Sscanf(strings.TrimSpace(lines[4]), "If true: throw to monkey %d", &m.ifTrue)
		fmt.Sscanf(strings.TrimSpace(lines[5]), "If false: throw to monkey %d", &m.ifFalse)
		monkeys = append(monkeys, m)
	}
	return monkeys
}

// parseOperation turns "old * 19" or "old * old" into a function.
func parseOperation(expr string) func(int) int {
	fields := strings.Fields(expr)
	op, rhs := fields[1], fields[2]
	return func(old int) int {
		operand := old
		if rhs != "old" {
			operand, _ = strconv.Atoi(rhs)
		}
		if op == "*" {
			return old * operand
		}
		return old + operand
	}
}

func monkeyBusiness(monkeys []monkey, rounds int, relief func(int) int) int {
	inspected := make([]int, len(monkeys))
	for range rounds {
		for i := range monkeys {
			m := &monkeys[i]
			for _, worry := range m.items {
				worry = relief(m.operation(worry))
				target := m.ifFalse
				if worry%m.divisor == 0 {
					target = m.ifTrue
				}
				monkeys[target].items = append(monkeys[target].items, worry)
			}
			inspected[i] += len(m.items)
			m.items = m.items[:0]
		}
	}
	slices.Sort(inspected)
	return inspected[len(inspected)-1] * inspected[len(inspected)-2]
}
