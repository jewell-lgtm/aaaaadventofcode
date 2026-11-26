// CrateMover 9001 lifts a block: pop into a temporary stack, then push back, keeping order.
static class Part2
{
    public static object Solve(string input) => Part1.Operate(input, (from, to, count) =>
    {
        var lifted = new Stack<char>();
        for (var i = 0; i < count; i++) lifted.Push(from.Pop());
        while (lifted.Count > 0) to.Push(lifted.Pop());
    });
}
