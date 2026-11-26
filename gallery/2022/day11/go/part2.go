// No relief, 10000 rounds: keep worry modulo the product of all divisors, which
// preserves every divisibility test while keeping numbers inside an int.
package main

func part2(input string) any {
	monkeys := parseMonkeys(input)
	modulus := 1
	for _, m := range monkeys {
		modulus *= m.divisor
	}
	return monkeyBusiness(monkeys, 10000, func(w int) int { return w % modulus })
}
