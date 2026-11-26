// Regex scan with std.regex: matchAll is a lazy range of captures, so the
// whole solution is one map + sum pipeline.
module part1;

import std.algorithm, std.conv, std.regex;

long product(C)(C c) {
    return c[1].to!long * c[2].to!long;
}

auto solve(string input) {
    return input.matchAll(regex(`mul\((\d{1,3}),(\d{1,3})\)`)).map!(c => product(c)).sum;
}
