# Chiton, part 1: Dijkstra from top-left to bottom-right.
# Python: heapq orders tuples lexicographically, so (distance, r, c) is the whole priority queue.
from chiton import lowest_risk


def solve(input: str) -> int:
    return lowest_risk(input, tiles=1)
