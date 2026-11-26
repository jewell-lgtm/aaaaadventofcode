# Chiton, part 2: the map tiles 5x5 with risk incremented per tile (wrapping 9 -> 1).
# Python: a closure computes tiled risk lazily; same Dijkstra.
from chiton import lowest_risk


def solve(input: str) -> int:
    return lowest_risk(input, tiles=5)
