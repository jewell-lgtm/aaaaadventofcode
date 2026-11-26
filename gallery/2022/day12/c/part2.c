// BFS from E going downhill (edges reversed) until the first square at elevation a.
// The grid is the input lines themselves; flat int arrays hold the queue and distances.
#include <stdlib.h>
#include <string.h>
#include "aoc.h"

static char height(char **lines, int r, int c) {
    char ch = lines[r][c];
    return ch == 'S' ? 'a' : ch == 'E' ? 'z' : ch;
}

answer solve(char *input) {
    size_t n;
    char **lines = aoc_lines(input, &n);
    int rows = (int)n, cols = (int)strlen(lines[0]);
    int start = 0, end = 0;
    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
            if (lines[r][c] == 'S') start = r * cols + c;
            if (lines[r][c] == 'E') end = r * cols + c;
        }
    }

    int *dist = malloc(sizeof(int) * rows * cols);
    int *queue = malloc(sizeof(int) * rows * cols);
    for (int i = 0; i < rows * cols; i++) dist[i] = -1;
    int head = 0, tail = 0;
    dist[end] = 0;
    queue[tail++] = end;

    static const int dr[] = {-1, 1, 0, 0}, dc[] = {0, 0, -1, 1};
    while (head < tail) {
        int p = queue[head++];
        if (height(lines, p / cols, p % cols) == 'a') return aoc_int(dist[p]);
        int r = p / cols, c = p % cols;
        for (int d = 0; d < 4; d++) {
            int nr = r + dr[d], nc = c + dc[d], q = nr * cols + nc;
            if (nr < 0 || nr >= rows || nc < 0 || nc >= cols || dist[q] >= 0) continue;
            if (height(lines, r, c) > height(lines, nr, nc) + 1) continue;
            dist[q] = dist[p] + 1;
            queue[tail++] = q;
        }
    }
    return aoc_str("no path");
}
