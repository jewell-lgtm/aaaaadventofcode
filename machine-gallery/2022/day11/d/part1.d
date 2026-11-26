// Monkeys parse into structs holding a delegate for their operation; worry relief
// is a delegate parameter too, so part 2 just passes a different lambda.
module part1;

import std.algorithm, std.array, std.conv, std.range, std.string;

struct Monkey {
    long[] items;
    long delegate(long) operation;
    long divisor;
    size_t ifTrue, ifFalse;
}

Monkey[] parseMonkeys(string input) {
    return input.strip.split("\n\n").map!((block) {
        auto lines = block.splitLines.map!strip.array;
        auto lastNumber = (string line) => line.split.back.to!long;
        auto expr = lines[2].split; // ["Operation:", "new", "=", "old", "*", "19"]
        immutable op = expr[4], rhs = expr[5];
        return Monkey(
            lines[1].findSplitAfter(": ")[1].split(", ").map!(to!long).array,
            (long old) {
                immutable operand = rhs == "old" ? old : rhs.to!long;
                return op == "*" ? old * operand : old + operand;
            },
            lastNumber(lines[3]),
            lastNumber(lines[4]),
            lastNumber(lines[5]),
        );
    }).array;
}

long monkeyBusiness(Monkey[] monkeys, int rounds, long delegate(long) relief) {
    auto inspected = new long[](monkeys.length);
    foreach (_; 0 .. rounds) {
        foreach (i, ref m; monkeys) {
            inspected[i] += m.items.length;
            foreach (item; m.items) {
                immutable worry = relief(m.operation(item));
                monkeys[worry % m.divisor == 0 ? m.ifTrue : m.ifFalse].items ~= worry;
            }
            m.items.length = 0;
            m.items.assumeSafeAppend();
        }
    }
    return inspected.sort!"a > b".take(2).fold!"a * b";
}

auto solve(string input) {
    return monkeyBusiness(parseMonkeys(input), 20, w => w / 3);
}
