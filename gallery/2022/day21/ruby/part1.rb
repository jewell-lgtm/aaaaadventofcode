# Monkey Math, part 1: recursively evaluate the expression tree from root.
# Ruby: case/in pattern matching on Integer vs [left, op, right]; public_send applies the operator.
require "aoc"
require "monkeys"

def solve(input) = MonkeyMath.evaluate(MonkeyMath.parse(input), "root").to_i
