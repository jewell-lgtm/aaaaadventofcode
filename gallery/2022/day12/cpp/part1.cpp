// BFS from E going downhill (edges reversed) until we reach S, with std::queue and a
// distance grid. Structured bindings unpack positions; the grid is a vector<string>.
#include <queue>
#include <utility>
#include "aoc.hpp"

using Pos = std::pair<int, int>;

aoc::Answer solve(std::string_view input) {
    std::vector<std::string> grid;
    for (auto line : aoc::lines(input)) grid.emplace_back(line);
    int rows = static_cast<int>(grid.size()), cols = static_cast<int>(grid[0].size());

    Pos start, end;
    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
            if (grid[r][c] == 'S') start = {r, c}, grid[r][c] = 'a';
            if (grid[r][c] == 'E') end = {r, c}, grid[r][c] = 'z';
        }
    }

    std::vector dist(rows, std::vector(cols, -1));
    std::queue<Pos> queue{{end}};
    dist[end.first][end.second] = 0;
    while (!queue.empty()) {
        auto p = queue.front();
        auto [r, c] = p;
        queue.pop();
        if (p == start) return dist[r][c];
        for (auto [dr, dc] : {Pos{-1, 0}, {1, 0}, {0, -1}, {0, 1}}) {
            int nr = r + dr, nc = c + dc;
            if (nr < 0 || nr >= rows || nc < 0 || nc >= cols || dist[nr][nc] >= 0) continue;
            if (grid[r][c] > grid[nr][nc] + 1) continue;
            dist[nr][nc] = dist[r][c] + 1;
            queue.push({nr, nc});
        }
    }
    return "no path";
}
