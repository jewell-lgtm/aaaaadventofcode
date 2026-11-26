// Dijkstra over the input tiled 5×5, with risk computed on the fly by a lambda.
// std::priority_queue + std::greater<> gives a min-heap of (risk, position) pairs.
#include <climits>
#include <functional>
#include <queue>
#include <utility>
#include "aoc.hpp"

constexpr int tiles = 5;

aoc::Answer solve(std::string_view input) {
    auto cave = aoc::lines(input);
    int h = static_cast<int>(cave.size()), w = static_cast<int>(cave[0].size());
    int rows = h * tiles, cols = w * tiles;
    // +1 per tile step, wrapping 9 back round to 1.
    auto risk = [&](int r, int c) { return (cave[r % h][c % w] - '0' + r / h + c / w - 1) % 9 + 1; };

    std::vector dist(rows * cols, INT_MAX);
    using Entry = std::pair<int, int>;  // (risk, flat position)
    std::priority_queue<Entry, std::vector<Entry>, std::greater<>> pq;
    pq.push({0, 0});
    dist[0] = 0;
    while (!pq.empty()) {
        auto [d, pos] = pq.top();
        pq.pop();
        if (pos == rows * cols - 1) return d;
        if (d > dist[pos]) continue;
        int r = pos / cols, c = pos % cols;
        for (auto [dr, dc] : {std::pair{-1, 0}, {1, 0}, {0, -1}, {0, 1}}) {
            int nr = r + dr, nc = c + dc;
            if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;
            int next = nr * cols + nc, nd = d + risk(nr, nc);
            if (nd < dist[next]) {
                dist[next] = nd;
                pq.push({nd, next});
            }
        }
    }
    return "unreachable";
}
