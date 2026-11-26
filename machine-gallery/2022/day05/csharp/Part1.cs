// Parse columns of the drawing into Stack<char>s and moves into a record, then replay.
// The crane strategy is a delegate so part 2 can swap it.
using System.Text.RegularExpressions;

record Move(int Count, int From, int To);

static partial class Part1
{
    [GeneratedRegex(@"move (\d+) from (\d+) to (\d+)")]
    private static partial Regex MoveLine();

    public static (List<Stack<char>> Stacks, List<Move> Moves) Parse(string input)
    {
        var sections = input.Split("\n\n", 2);
        var rows = sections[0].Split('\n');
        var width = rows[^1].Split(' ', StringSplitOptions.RemoveEmptyEntries).Length;
        var stacks = Enumerable.Range(0, width)
            .Select(i => new Stack<char>(rows[..^1].Reverse()           // bottom row first
                .Select(row => 1 + 4 * i < row.Length ? row[1 + 4 * i] : ' ')
                .Where(char.IsLetter)))
            .ToList();
        var moves = MoveLine().Matches(sections[1])
            .Select(m => new Move(int.Parse(m.Groups[1].Value), int.Parse(m.Groups[2].Value) - 1, int.Parse(m.Groups[3].Value) - 1))
            .ToList();
        return (stacks, moves);
    }

    public static string Operate(string input, Action<Stack<char>, Stack<char>, int> crane)
    {
        var (stacks, moves) = Parse(input);
        foreach (var (count, from, to) in moves) crane(stacks[from], stacks[to], count);
        return string.Concat(stacks.Select(s => s.Peek()));
    }

    public static object Solve(string input) => Operate(input, (from, to, count) =>
    {
        for (var i = 0; i < count; i++) to.Push(from.Pop());
    });
}
