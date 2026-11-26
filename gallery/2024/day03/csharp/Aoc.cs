// Harness helpers.
//   Aoc.Example: true when running an example (aoc test).
//   Aoc.Arg("size", 71): example-specific constant from examples.toml `args`, else the default.
using System.Text.Json;

static class Aoc
{
    public static readonly bool Example = Environment.GetEnvironmentVariable("AOC_EXAMPLE") == "1";

    static readonly Dictionary<string, JsonElement> Args =
        JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(Environment.GetEnvironmentVariable("AOC_ARGS") ?? "{}") ?? [];

    public static T Arg<T>(string name, T fallback) =>
        Args.TryGetValue(name, out var v) ? v.Deserialize<T>()! : fallback;
}
