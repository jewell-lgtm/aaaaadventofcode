// Two-sum with a lookup table: entries are positive and at most 2020, so a bool
// array indexed by value is the set. No hashing needed when the key space is small.
#include <stdlib.h>
#include "aoc.h"

answer solve(char *input) {
    bool seen[2021] = {};
    char *end;
    for (long n = strtol(input, &end, 10); end != input; n = strtol(input, &end, 10)) {
        input = end;
        if (n > 2020) continue;
        if (seen[2020 - n]) return aoc_int(n * (2020 - n));
        seen[n] = true;
    }
    return aoc_str("no pair");
}
