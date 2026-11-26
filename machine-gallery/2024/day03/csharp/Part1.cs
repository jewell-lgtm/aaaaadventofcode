// A source-generated Regex ([GeneratedRegex]) and LINQ Sum over its matches.
using System.Text.RegularExpressions;

static partial class Part1
{
    [GeneratedRegex(@"mul\((\d{1,3}),(\d{1,3})\)")]
    private static partial Regex Mul();

    public static long Product(Match m) => long.Parse(m.Groups[1].Value) * long.Parse(m.Groups[2].Value);

    public static object Solve(string input) => Mul().Matches(input).Sum(Product);
}
