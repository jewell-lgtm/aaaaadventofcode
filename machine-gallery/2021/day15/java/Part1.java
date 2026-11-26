// Dijkstra over an int[][] risk grid with java.util.PriorityQueue of {dist, r, c}
// entries; stale entries are skipped instead of decreasing keys.
import java.util.*;

class Part1 {
    static int[][] parse(String input) {
        return input.lines().filter(l -> !l.isEmpty())
            .map(l -> l.chars().map(ch -> ch - '0').toArray())
            .toArray(int[][]::new);
    }

    static int lowestRisk(int[][] risk) {
        int rows = risk.length, cols = risk[0].length;
        var best = new int[rows][cols];
        for (var row : best) Arrays.fill(row, Integer.MAX_VALUE);
        best[0][0] = 0;
        var queue = new PriorityQueue<int[]>(Comparator.comparingInt(e -> e[0]));
        queue.add(new int[] {0, 0, 0});
        int[][] dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        while (!queue.isEmpty()) {
            var e = queue.poll();
            int d = e[0], r = e[1], c = e[2];
            if (r == rows - 1 && c == cols - 1) return d;
            if (d > best[r][c]) continue;
            for (var dir : dirs) {
                int nr = r + dir[0], nc = c + dir[1];
                if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;
                int nd = d + risk[nr][nc];
                if (nd < best[nr][nc]) {
                    best[nr][nc] = nd;
                    queue.add(new int[] {nd, nr, nc});
                }
            }
        }
        throw new IllegalStateException("unreachable");
    }

    static Object solve(String input) {
        return lowestRisk(parse(input));
    }
}
