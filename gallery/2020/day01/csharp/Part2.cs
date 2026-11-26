// Three entries: fix each number and search the rest for a pair summing to the remainder.
static class Part2
{
    public static object Solve(string input)
    {
        var nums = Part1.Parse(input);
        return nums
            .Select((a, i) => a * Part1.PairProduct(nums.Skip(i + 1), Part1.Target - a))
            .First(p => p is not null)!;
    }
}
