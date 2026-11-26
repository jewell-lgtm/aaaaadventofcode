// Three-sum: sort in place, then two pointers for each first entry.
module part2;

import std.algorithm;
import part1 : entries;

auto solve(string input) {
    auto xs = entries(input).sort.release;
    foreach (i, a; xs) {
        size_t lo = i + 1, hi = xs.length - 1;
        while (lo < hi) {
            immutable sum = a + xs[lo] + xs[hi];
            if (sum == 2020) return a * xs[lo] * xs[hi];
            if (sum < 2020) lo++;
            else hi--;
        }
    }
    throw new Exception("no triple sums to 2020");
}
