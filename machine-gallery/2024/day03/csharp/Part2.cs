// One alternation regex; a switch expression on each token updates (enabled, sum).
using System.Text.RegularExpressions;

static partial class Part2
{
    [GeneratedRegex(@"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)")]
    private static partial Regex Token();

    public static object Solve(string input) =>
        Token().Matches(input).Aggregate((Enabled: true, Sum: 0L), (s, m) => m.Value switch
        {
            "do()" => s with { Enabled = true },
            "don't()" => s with { Enabled = false },
            _ when s.Enabled => s with { Sum = s.Sum + Part1.Product(m) },
            _ => s,
        }).Sum;
}
