// Two entries summing to 2020: one pass with a HashSet of numbers seen so far.
// LINQ for parsing, a plain loop for the search.
static class Part1
{
    public const int Target = 2020;

    public static int[] Parse(string input) =>
        input.Split('\n', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries).Select(int.Parse).ToArray();

    /// <summary>Product of some a, b in nums with a + b == target, or null.</summary>
    public static long? PairProduct(IEnumerable<int> nums, int target)
    {
        var seen = new HashSet<int>();
        foreach (var n in nums)
        {
            if (seen.Contains(target - n)) return (long)n * (target - n);
            seen.Add(n);
        }
        return null;
    }

    public static object Solve(string input) => PairProduct(Parse(input), Target) ?? throw new InvalidOperationException("no pair");
}
