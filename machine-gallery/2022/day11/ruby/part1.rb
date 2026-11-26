# Monkey in the Middle, part 1: 20 rounds, worry divided by 3 after each inspection.
# Ruby: public_send(sym, ...) turns the parsed "*" or "+" straight into a method call.
require "aoc"
require "monkeys"

def solve(input) = Monkeys.business(Monkeys.parse(input), 20) { _1 / 3 }
