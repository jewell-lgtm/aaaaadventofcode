// One alternation regex finds mul/do/don't in order; a final switch on the
// matched text toggles the flag (D switches work on strings).
module part2;

import std.regex;
import part1 : product;

auto solve(string input) {
    long total = 0;
    bool enabled = true;
    foreach (c; input.matchAll(regex(`mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)`))) {
        switch (c.hit) {
            case "do()": enabled = true; break;
            case "don't()": enabled = false; break;
            default: if (enabled) total += product(c);
        }
    }
    return total;
}
