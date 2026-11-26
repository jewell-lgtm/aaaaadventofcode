// BFS on a char[][] grid with an ArrayDeque. We search backwards from E (a step down
// may be at most 1), so part 2 is the same search with a different goal.
import java.util.*;
import java.util.function.Predicate;

class Part1 {
    record Pos(int r, int c) {}

    record Hill(char[][] grid, Pos start, Pos end) {
        int height(Pos p) {
            char ch = grid[p.r()][p.c()];
            return switch (ch) {
                case 'S' -> 'a';
                case 'E' -> 'z';
                default -> ch;
            };
        }

        boolean inside(Pos p) {
            return p.r() >= 0 && p.r() < grid.length && p.c() >= 0 && p.c() < grid[0].length;
        }
    }

    static Hill parse(String input) {
        var grid = input.lines().filter(l -> !l.isEmpty()).map(String::toCharArray).toArray(char[][]::new);
        Pos start = null, end = null;
        for (int r = 0; r < grid.length; r++)
            for (int c = 0; c < grid[r].length; c++) {
                if (grid[r][c] == 'S') start = new Pos(r, c);
                if (grid[r][c] == 'E') end = new Pos(r, c);
            }
        return new Hill(grid, start, end);
    }

    /** Fewest steps from any square matching goal up to E. */
    static int stepsFromEnd(Hill hill, Predicate<Pos> goal) {
        var dist = new HashMap<Pos, Integer>(Map.of(hill.end(), 0));
        var queue = new ArrayDeque<>(List.of(hill.end()));
        while (!queue.isEmpty()) {
            var cur = queue.poll();
            if (goal.test(cur)) return dist.get(cur);
            for (int[] d : new int[][] {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}) {
                var next = new Pos(cur.r() + d[0], cur.c() + d[1]);
                if (hill.inside(next) && !dist.containsKey(next) && hill.height(cur) - hill.height(next) <= 1) {
                    dist.put(next, dist.get(cur) + 1);
                    queue.add(next);
                }
            }
        }
        throw new IllegalStateException("no path");
    }

    static Object solve(String input) {
        var hill = parse(input);
        return stepsFromEnd(hill, hill.start()::equals);
    }
}
