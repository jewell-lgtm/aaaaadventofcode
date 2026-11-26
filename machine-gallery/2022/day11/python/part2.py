# Monkey in the Middle, part 2: 10000 rounds, no relief; reduce worry modulo the divisor product.
# Python: ints are arbitrary precision, but the modulus keeps them small and fast.
from monkeys import divisor_product, monkey_business


def solve(input: str) -> int:
    modulus = divisor_product(input)
    return monkey_business(input, 10_000, lambda w: w % modulus)
