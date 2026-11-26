# Shared: memoised recursion on (remaining row, remaining groups) with functools.cache.
from functools import cache


@cache
def arrangements(row: str, groups: tuple[int, ...]) -> int:
    if not row:
        return 0 if groups else 1
    total = 0
    if row[0] in ".?":
        total += arrangements(row[1:], groups)
    if row[0] in "#?" and groups:
        size = groups[0]
        if len(row) >= size and "." not in row[:size] and row[size:size + 1] != "#":
            total += arrangements(row[size + 1:], groups[1:])
    return total


def total_arrangements(input: str, copies: int) -> int:
    total = 0
    for line in input.splitlines():
        row, groups = line.split()
        total += arrangements("?".join([row] * copies), tuple(map(int, groups.split(","))) * copies)
    return total
