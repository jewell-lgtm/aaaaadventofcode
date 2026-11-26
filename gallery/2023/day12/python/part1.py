# Hot Springs, part 1: count arrangements per row by branching on each '?'.
# Python: @functools.cache on a function of (str, tuple) is memoisation for free.
from springs import total_arrangements


def solve(input: str) -> int:
    return total_arrangements(input, copies=1)
