// Monkeys form an expression tree keyed by name; evaluate it recursively.
// A small struct with an op byte is enough; a zero op means a number leaf.
package main

import (
	"strconv"
	"strings"
)

type job struct {
	value       int
	left, right string
	op          byte
}

type tribe map[string]job

func part1(input string) any {
	return parseTribe(input).eval("root")
}

func parseTribe(input string) tribe {
	t := tribe{}
	for _, line := range strings.Split(strings.TrimSpace(input), "\n") {
		name, expr, _ := strings.Cut(line, ": ")
		if fields := strings.Fields(expr); len(fields) == 3 {
			t[name] = job{left: fields[0], op: fields[1][0], right: fields[2]}
		} else {
			n, _ := strconv.Atoi(expr)
			t[name] = job{value: n}
		}
	}
	return t
}

func (t tribe) eval(name string) int {
	j := t[name]
	if j.op == 0 {
		return j.value
	}
	a, b := t.eval(j.left), t.eval(j.right)
	switch j.op {
	case '+':
		return a + b
	case '-':
		return a - b
	case '*':
		return a * b
	default:
		return a / b
	}
}
