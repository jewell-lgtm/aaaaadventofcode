# Monkey in the Middle, part 1: 20 rounds, worry floor-divided by 3 after each inspection.
# Python: a dataclass per monkey and operator.mul/add looked up from the parsed symbol.
from monkeys import monkey_business


def solve(input: str) -> int:
    return monkey_business(input, 20, lambda w: w // 3)
