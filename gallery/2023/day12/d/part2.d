// Unfold each record five times (repeat + join); the memoised count absorbs the blow-up.
module part2;

import std.algorithm, std.array, std.range, std.string;
import part1 : arrangements, parseRecord;

auto solve(string input) {
    return input.strip.splitLines.map!parseRecord
        .map!(r => arrangements(r[0].repeat(5).join("?"), r[1].repeat(5).join))
        .sum;
}
