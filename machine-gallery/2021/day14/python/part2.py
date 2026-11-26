# Extended Polymerization, part 2: 40 steps; the polymer is astronomically long, the pair counts aren't.
# Python: identical code, arbitrary-precision ints never overflow.
from polymer import polymer_spread


def solve(input: str) -> int:
    return polymer_spread(input, steps=40)
