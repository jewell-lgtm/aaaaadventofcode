# Report Repair, part 2: itertools.combinations over triples; math.prod for the answer.
# Python: brute force is perfectly fine for ~200 numbers and reads in one line.
from itertools import combinations
from math import prod


def solve(input: str) -> int:
    nums = [int(line) for line in input.split()]
    return next(prod(c) for c in combinations(nums, 3) if sum(c) == 2020)
