// Memoised recursion over (spring index, group index) with a Dictionary cache; spans
// make the "does a group fit here" check allocation-free.
record Row(string Springs, int[] Groups)
{
    public static Row Parse(string line)
    {
        var parts = line.Split(' ');
        return new Row(parts[0], parts[1].Split(',').Select(int.Parse).ToArray());
    }

    public long Arrangements() => Count(0, 0, new Dictionary<(int, int), long>());

    private long Count(int i, int g, Dictionary<(int, int), long> memo)
    {
        if (i >= Springs.Length) return g == Groups.Length ? 1 : 0;
        if (memo.TryGetValue((i, g), out var cached)) return cached;
        long ways = 0;
        if (Springs[i] != '#') ways += Count(i + 1, g, memo);                         // operational
        if (Springs[i] != '.' && g < Groups.Length && Fits(i, Groups[g]))
            ways += Count(i + Groups[g] + 1, g + 1, memo);                                // group + gap
        return memo[(i, g)] = ways;
    }

    /// <summary>A damaged group of length n can start at i: no '.' inside, no '#' right after.</summary>
    private bool Fits(int i, int n) =>
        i + n <= Springs.Length
        && !Springs.AsSpan(i, n).Contains('.')
        && (i + n == Springs.Length || Springs[i + n] != '#');

    public Row Unfold(int times) =>
        new(string.Join('?', Enumerable.Repeat(Springs, times)), Enumerable.Repeat(Groups, times).SelectMany(g => g).ToArray());
}

static class Part1
{
    public static IEnumerable<Row> Rows(string input) =>
        input.Split('\n', StringSplitOptions.RemoveEmptyEntries).Select(Row.Parse);

    public static object Solve(string input) => Rows(input).Sum(r => r.Arrangements());
}
