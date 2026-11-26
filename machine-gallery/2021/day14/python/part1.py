# Extended Polymerization, part 1: 10 steps, then most common minus least common element.
# Python: Counter + itertools.pairwise; most_common() hands back both ends sorted.
from polymer import polymer_spread


def solve(input: str) -> int:
    return polymer_spread(input, steps=10)
