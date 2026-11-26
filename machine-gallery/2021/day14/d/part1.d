// Count pairs, not the polymer: each step maps pair AB (rule AB -> C) to AC and CB.
// Built-in associative arrays keyed by 2-char strings; `in` returns a pointer or null.
module part1;

import std.algorithm, std.array, std.range, std.string;

long polymerStrength(string input, int steps) {
    auto sections = input.strip.split("\n\n");
    auto polymer = sections[0];
    char[string] rules;
    foreach (line; sections[1].splitLines) rules[line[0 .. 2]] = line[6];

    long[string] pairs;
    foreach (i; 0 .. polymer.length - 1) pairs[polymer[i .. i + 2]]++;
    foreach (_; 0 .. steps) {
        long[string] next;
        foreach (pair, n; pairs) {
            if (auto c = pair in rules) {
                next[[pair[0], *c].idup] += n;
                next[[*c, pair[1]].idup] += n;
            } else {
                next[pair] += n;
            }
        }
        pairs = next;
    }

    // Every element is the first letter of exactly one pair, except the last one.
    long[char] counts = [polymer[$ - 1]: 1];
    foreach (pair, n; pairs) counts[pair[0]] += n;
    return counts.values.maxElement - counts.values.minElement;
}

auto solve(string input) {
    return polymerStrength(input, 10);
}
