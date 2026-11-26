// No relief, 10,000 rounds: worry modulo the product of all divisors keeps every
// divisibility test intact while staying inside a long.
static class Part2
{
    public static object Solve(string input)
    {
        var monkeys = Part1.Parse(input);
        var modulus = monkeys.Aggregate(1L, (acc, m) => acc * m.Divisor);
        return Part1.MonkeyBusiness(monkeys, 10_000, w => w % modulus);
    }
}
