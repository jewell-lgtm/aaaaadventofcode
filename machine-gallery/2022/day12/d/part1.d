// BFS from E going downhill (edges reversed), so both parts share one search.
// A plain dynamic array is the queue: popFront slices it, ~= appends.
module part1;

import std.algorithm, std.array, std.range, std.string;

struct Pos { size_t r, c; }

struct Heightmap {
    char[][] grid;
    Pos start, end;

    static Heightmap parse(string input) {
        Heightmap h;
        h.grid = input.strip.splitLines.map!(l => l.dup).array;
        foreach (r, row; h.grid) {
            foreach (c, ref cell; row) {
                if (cell == 'S') { h.start = Pos(r, c); cell = 'a'; }
                if (cell == 'E') { h.end = Pos(r, c); cell = 'z'; }
            }
        }
        return h;
    }

    /// Steps from E to the nearest square where `done` holds.
    long stepsFromEnd(scope bool delegate(Pos) done) {
        long[Pos] dist = [end: 0];
        auto queue = [end];
        while (!queue.empty) {
            auto p = queue.front;
            queue.popFront();
            if (done(p)) return dist[p];
            // size_t wraps below zero, so one bounds check covers all four sides.
            foreach (q; [Pos(p.r - 1, p.c), Pos(p.r + 1, p.c), Pos(p.r, p.c - 1), Pos(p.r, p.c + 1)]) {
                if (q.r >= grid.length || q.c >= grid[q.r].length || q in dist) continue;
                if (grid[p.r][p.c] > grid[q.r][q.c] + 1) continue;
                dist[q] = dist[p] + 1;
                queue ~= q;
            }
        }
        return -1;
    }
}

auto solve(string input) {
    auto h = Heightmap.parse(input);
    return h.stepsFromEnd(p => p == h.start);
}
