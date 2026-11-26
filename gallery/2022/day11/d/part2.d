// No relief, 10000 rounds: keep worry modulo the product of all divisors, which
// preserves every divisibility test and keeps numbers inside a long.
module part2;

import std.algorithm;
import part1 : monkeyBusiness, parseMonkeys;

auto solve(string input) {
    auto monkeys = parseMonkeys(input);
    immutable modulus = monkeys.map!(m => m.divisor).fold!"a * b";
    return monkeyBusiness(monkeys, 10_000, w => w % modulus);
}
