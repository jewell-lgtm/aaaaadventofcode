// Same backwards BFS; stop at the first square of height 'a'.
static class Part2
{
    public static object Solve(string input)
    {
        var hill = new Hill(input);
        return hill.StepsFromEnd(p => hill.Height(p) == 'a');
    }
}
