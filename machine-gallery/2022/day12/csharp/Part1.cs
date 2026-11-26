// BFS backwards from E with Queue<T> over (int R, int C) tuples; a step down may
// drop at most one. Part 2 reuses it with a different goal predicate.
using Pos = (int R, int C);

class Hill
{
    private readonly string[] rows;
    public Pos Start { get; }
    public Pos End { get; }

    public Hill(string input)
    {
        rows = input.Split('\n', StringSplitOptions.RemoveEmptyEntries);
        Start = Find('S');
        End = Find('E');
    }

    private Pos Find(char ch)
    {
        var r = Array.FindIndex(rows, row => row.Contains(ch));
        return (r, rows[r].IndexOf(ch));
    }

    public char? Height(Pos p) =>
        p.R < 0 || p.R >= rows.Length || p.C < 0 || p.C >= rows[p.R].Length ? null
        : rows[p.R][p.C] switch { 'S' => 'a', 'E' => 'z', var ch => ch };

    /// <summary>Fewest steps from any square satisfying goal up to E.</summary>
    public int StepsFromEnd(Func<Pos, bool> goal)
    {
        var dist = new Dictionary<Pos, int> { [End] = 0 };
        var queue = new Queue<Pos>([End]);
        while (queue.TryDequeue(out var cur))
        {
            if (goal(cur)) return dist[cur];
            Pos[] next = [(cur.R + 1, cur.C), (cur.R - 1, cur.C), (cur.R, cur.C + 1), (cur.R, cur.C - 1)];
            foreach (var n in next)
            {
                if (Height(n) is not { } h || dist.ContainsKey(n) || Height(cur) - h > 1) continue;
                dist[n] = dist[cur] + 1;
                queue.Enqueue(n);
            }
        }
        throw new InvalidOperationException("no path");
    }
}

static class Part1
{
    public static object Solve(string input)
    {
        var hill = new Hill(input);
        return hill.StepsFromEnd(p => p == hill.Start);
    }
}
