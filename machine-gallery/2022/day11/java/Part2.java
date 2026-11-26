// No more relief, 10,000 rounds: keep worry levels modulo the product of all
// divisors, which preserves every divisibility test while staying inside a long.
class Part2 {
    static Object solve(String input) {
        var monkeys = Part1.parse(input);
        long modulus = monkeys.stream().mapToLong(Part1.Monkey::divisor).reduce(1, (a, b) -> a * b);
        return Part1.monkeyBusiness(monkeys, 10_000, w -> w % modulus);
    }
}
