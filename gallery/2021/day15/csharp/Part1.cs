// Dijkstra with .NET's PriorityQueue<TElement, TPriority> over an int[,] grid;
// stale queue entries are skipped rather than decreased.
static class Part1
{
    public static int[,] Parse(string input)
    {
        var lines = input.Split('\n', StringSplitOptions.RemoveEmptyEntries);
        var grid = new int[lines.Length, lines[0].Length];
        for (var r = 0; r < lines.Length; r++)
            for (var c = 0; c < lines[r].Length; c++)
                grid[r, c] = lines[r][c] - '0';
        return grid;
    }

    public static int LowestRisk(int[,] risk)
    {
        int rows = risk.GetLength(0), cols = risk.GetLength(1);
        var best = new int[rows, cols];
        foreach (var (r, c) in Cells(rows, cols)) best[r, c] = int.MaxValue;
        best[0, 0] = 0;
        var queue = new PriorityQueue<(int R, int C), int>([((0, 0), 0)]);
        while (queue.TryDequeue(out var p, out var d))
        {
            if (p == (rows - 1, cols - 1)) return d;
            if (d > best[p.R, p.C]) continue;
            (int R, int C)[] next = [(p.R + 1, p.C), (p.R - 1, p.C), (p.R, p.C + 1), (p.R, p.C - 1)];
            foreach (var (r, c) in next)
            {
                if (r < 0 || r >= rows || c < 0 || c >= cols) continue;
                var nd = d + risk[r, c];
                if (nd >= best[r, c]) continue;
                best[r, c] = nd;
                queue.Enqueue((r, c), nd);
            }
        }
        throw new InvalidOperationException("unreachable");
    }

    public static IEnumerable<(int R, int C)> Cells(int rows, int cols) =>
        from r in Enumerable.Range(0, rows) from c in Enumerable.Range(0, cols) select (r, c);

    public static object Solve(string input) => LowestRisk(Parse(input));
}
