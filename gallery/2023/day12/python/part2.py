# Hot Springs, part 2: unfold each row 5x (joined by '?') and its groups 5x.
# Python: the same cached recursion; tuple * 5 repeats the groups.
from springs import total_arrangements


def solve(input: str) -> int:
    return total_arrangements(input, copies=5)
