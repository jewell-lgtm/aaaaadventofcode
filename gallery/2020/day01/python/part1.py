# Report Repair, part 1: itertools.combinations over pairs; math.prod for the answer.
# Python: brute force over ~200 numbers is instant and reads like the spec.
from itertools import combinations
from math import prod


def solve(input: str) -> int:
    nums = [int(line) for line in input.split()]
    return next(prod(c) for c in combinations(nums, 2) if sum(c) == 2020)
