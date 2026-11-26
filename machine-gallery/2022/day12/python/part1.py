# Hill Climbing Algorithm, part 1: BFS from S to E.
# Python: complex numbers as 2D points make neighbour arithmetic trivial.
from hill import shortest_path


def solve(input: str) -> int:
    return shortest_path(input, "S")
