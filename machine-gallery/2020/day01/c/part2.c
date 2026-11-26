// Three-sum: parse into an array, qsort it, then sweep two pointers for each first entry.
#include <stdlib.h>
#include "aoc.h"

static int by_value(const void *a, const void *b) {
    long x = *(const long *)a, y = *(const long *)b;
    return (x > y) - (x < y);
}

answer solve(char *input) {
    size_t n;
    char **lines = aoc_lines(input, &n);
    long *entries = malloc(n * sizeof *entries);
    for (size_t i = 0; i < n; i++) entries[i] = strtol(lines[i], NULL, 10);
    qsort(entries, n, sizeof *entries, by_value);

    for (size_t i = 0; i + 2 < n; i++) {
        size_t lo = i + 1, hi = n - 1;
        while (lo < hi) {
            long sum = entries[i] + entries[lo] + entries[hi];
            if (sum == 2020) return aoc_int(entries[i] * entries[lo] * entries[hi]);
            if (sum < 2020) lo++;
            else hi--;
        }
    }
    return aoc_str("no triple");
}
