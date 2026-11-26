// Count pairs, not the polymer: each rule AB -> C turns AB into AC and CB.
// LINQ GroupBy/Sum merges counts each step; the pair keys are plain strings.
static class Part1
{
    public static (string Template, Dictionary<string, char> Rules) Parse(string input)
    {
        var sections = input.Trim().Split("\n\n");
        var rules = sections[1].Split('\n', StringSplitOptions.RemoveEmptyEntries)
            .Select(l => l.Split(" -> "))
            .ToDictionary(p => p[0], p => p[1][0]);
        return (sections[0].Trim(), rules);
    }

    static Dictionary<string, long> Step(Dictionary<string, long> pairs, Dictionary<string, char> rules) =>
        pairs.SelectMany(kv => rules.TryGetValue(kv.Key, out var c)
                ? [($"{kv.Key[0]}{c}", kv.Value), ($"{c}{kv.Key[1]}", kv.Value)]
                : new[] { (kv.Key, kv.Value) })
            .GroupBy(p => p.Item1)
            .ToDictionary(g => g.Key, g => g.Sum(p => p.Item2));

    /// <summary>Most common element count minus least common after the given steps.</summary>
    public static long Spread(string input, int steps)
    {
        var (template, rules) = Parse(input);
        var pairs = template.Zip(template.Skip(1), (a, b) => $"{a}{b}")
            .GroupBy(p => p).ToDictionary(g => g.Key, g => (long)g.Count());
        for (var i = 0; i < steps; i++) pairs = Step(pairs, rules);

        // Every element but the template's last is the first letter of exactly one pair.
        var counts = pairs.GroupBy(kv => kv.Key[0]).ToDictionary(g => g.Key, g => g.Sum(kv => kv.Value));
        counts[template[^1]] = counts.GetValueOrDefault(template[^1]) + 1;
        return counts.Values.Max() - counts.Values.Min();
    }

    public static object Solve(string input) => Spread(input, 10);
}
