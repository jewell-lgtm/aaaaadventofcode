// Two-sum with a built-in associative array as the set: `in` tests membership.
// Parsing is one UFCS pipeline: split, map!(to!long), array.
module part1;

import std.algorithm, std.array, std.conv;

long[] entries(string input) {
    return input.split.map!(to!long).array;
}

auto solve(string input) {
    bool[long] seen;
    foreach (n; entries(input)) {
        if (2020 - n in seen) return n * (2020 - n);
        seen[n] = true;
    }
    throw new Exception("no pair sums to 2020");
}
