# Shared: heightmap as a dict {complex: height}, BFS with collections.deque.
from collections import deque


def parse(input: str):
    grid = {complex(c, r): ch for r, row in enumerate(input.split()) for c, ch in enumerate(row)}
    height = {p: ord({"S": "a", "E": "z"}.get(ch, ch)) for p, ch in grid.items()}
    return grid, height


def shortest_path(input: str, start_chars: str) -> int:
    grid, height = parse(input)
    queue = deque((p, 0) for p, ch in grid.items() if ch in start_chars)
    seen = {p for p, _ in queue}
    while queue:
        p, steps = queue.popleft()
        if grid[p] == "E":
            return steps
        for q in (p + 1, p - 1, p + 1j, p - 1j):
            if q in height and q not in seen and height[q] - height[p] <= 1:
                seen.add(q)
                queue.append((q, steps + 1))
    raise ValueError("no path")
