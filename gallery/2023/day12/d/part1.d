// Memoised recursion over (position, group index). Nested functions are closures in
// D, so the memo table sits beside the recursion with no struct or globals.
module part1;

import std.algorithm, std.array, std.conv, std.string, std.typecons;

long arrangements(string springs, int[] groups) {
    auto memo = new long[][](springs.length + 1, groups.length + 1);
    foreach (ref row; memo) row[] = -1;

    // Can a run of n damaged springs start at i (and be followed by a gap)?
    bool fits(size_t i, size_t n) {
        return i + n <= springs.length && !springs[i .. i + n].canFind('.')
            && (i + n == springs.length || springs[i + n] != '#');
    }

    long count(size_t i, size_t g) {
        if (i >= springs.length) return g == groups.length;
        if (memo[i][g] >= 0) return memo[i][g];
        long ways = 0;
        if (springs[i] != '#') ways += count(i + 1, g); // operational
        if (springs[i] != '.' && g < groups.length && fits(i, groups[g]))
            ways += count(i + groups[g] + 1, g + 1); // start a damaged run here
        return memo[i][g] = ways;
    }

    return count(0, 0);
}

auto parseRecord(string line) {
    auto parts = line.split;
    return tuple(parts[0], parts[1].split(",").map!(to!int).array);
}

auto solve(string input) {
    return input.strip.splitLines.map!parseRecord.map!(r => arrangements(r[0], r[1])).sum;
}
