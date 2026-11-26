# Monkey in the Middle, part 2: 10000 rounds, no relief; reduce worry modulo the divisor product.
# Ruby: Integers are bignums anyway, the modulus just keeps them fast.
require "aoc"
require "monkeys"

def solve(input)
  monkeys = Monkeys.parse(input)
  modulus = monkeys.map(&:divisor).inject(:*)
  Monkeys.business(monkeys, 10_000) { _1 % modulus }
end
