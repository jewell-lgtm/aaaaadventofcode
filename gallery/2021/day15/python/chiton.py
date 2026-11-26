# Shared: Dijkstra with heapq over (risk, row, col) tuples; tiled risk computed on the fly.
import heapq


def lowest_risk(input: str, tiles: int) -> int:
    base = [list(map(int, row)) for row in input.split()]
    h, w = len(base), len(base[0])
    H, W = h * tiles, w * tiles

    def risk(r: int, c: int) -> int:
        return (base[r % h][c % w] + r // h + c // w - 1) % 9 + 1

    best = {(0, 0): 0}
    heap = [(0, 0, 0)]
    while heap:
        d, r, c = heapq.heappop(heap)
        if (r, c) == (H - 1, W - 1):
            return d
        if d > best[r, c]:
            continue
        for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
            if 0 <= nr < H and 0 <= nc < W and d + risk(nr, nc) < best.get((nr, nc), float("inf")):
                best[nr, nc] = d + risk(nr, nc)
                heapq.heappush(heap, (best[nr, nc], nr, nc))
    raise ValueError("unreachable")
