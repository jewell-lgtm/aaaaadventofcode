// Unfold each row five times; the memo keeps it fast.
static class Part2
{
    public static object Solve(string input) => Part1.Rows(input).Sum(r => r.Unfold(5).Arrangements());
}
