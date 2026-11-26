# Monkey Math, part 1: recursively evaluate the expression tree from root.
# Python: structural pattern matching on int vs (left, op, right); Fraction keeps division exact.
from monkeys import evaluate, parse


def solve(input: str) -> int:
    return int(evaluate(parse(input), "root"))
