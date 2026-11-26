// Dijkstra with std.container's BinaryHeap. It's a max-heap over a predicate,
// so "a.risk > b.risk" turns it into a min-heap with no wrapper types.
module part1;

import std.algorithm, std.array, std.container, std.string;

struct State { int risk; size_t r, c; }

auto solve(string input) {
    return lowestTotalRisk(input, 1);
}

/// Lowest risk across the cave tiled `tiles`×`tiles`; each tile step adds 1,
/// wrapping 9 back round to 1.
int lowestTotalRisk(string input, size_t tiles) {
    auto cave = input.strip.splitLines;
    immutable h = cave.length, w = cave[0].length;
    immutable rows = h * tiles, cols = w * tiles;
    int risk(size_t r, size_t c) {
        return cast(int)((cave[r % h][c % w] - '0' + r / h + c / w - 1) % 9 + 1);
    }

    auto dist = new int[][](rows, cols);
    foreach (ref row; dist) row[] = int.max;
    dist[0][0] = 0;
    auto heap = BinaryHeap!(State[], "a.risk > b.risk")([State(0, 0, 0)]);
    while (!heap.empty) {
        auto cur = heap.front;
        heap.removeFront();
        if (cur.r == rows - 1 && cur.c == cols - 1) return cur.risk;
        if (cur.risk > dist[cur.r][cur.c]) continue;
        // size_t wraps below zero, so one bounds check covers all four sides.
        foreach (n; [[cur.r - 1, cur.c], [cur.r + 1, cur.c], [cur.r, cur.c - 1], [cur.r, cur.c + 1]]) {
            if (n[0] >= rows || n[1] >= cols) continue;
            auto next = State(cur.risk + risk(n[0], n[1]), n[0], n[1]);
            if (next.risk < dist[n[0]][n[1]]) {
                dist[n[0]][n[1]] = next.risk;
                heap.insert(next);
            }
        }
    }
    assert(0, "bottom-right is unreachable");
}
