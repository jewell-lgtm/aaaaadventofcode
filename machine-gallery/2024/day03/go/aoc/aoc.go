// Package aoc holds harness helpers.
package aoc

import (
	"encoding/json"
	"os"
)

// Example is true when running an example (aoc test).
var Example = os.Getenv("AOC_EXAMPLE") == "1"

var args = func() map[string]any {
	m := map[string]any{}
	if s := os.Getenv("AOC_ARGS"); s != "" {
		_ = json.Unmarshal([]byte(s), &m)
	}
	return m
}()

// Arg returns the example-specific constant from examples.toml `args`, else fallback.
func Arg[T int | float64 | string | bool](name string, fallback T) T {
	v, ok := args[name]
	if !ok {
		return fallback
	}
	if f, isNum := v.(float64); isNum {
		if _, wantInt := any(fallback).(int); wantInt {
			v = int(f)
		}
	}
	if t, ok := v.(T); ok {
		return t
	}
	return fallback
}
