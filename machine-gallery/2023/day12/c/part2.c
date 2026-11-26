// Unfold each record five times (joined by ?), then the same memoised recursion over
// (position, group index). A context struct stands in for closures.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "aoc.h"

typedef struct {
    const char *springs;
    size_t len;
    int *groups, ngroups;
    long long *memo;  // (len + 1) × (ngroups + 1), -1 = unknown
} record;

// Can a run of n damaged springs start at i (and be followed by a gap)?
static bool fits(const record *r, size_t i, int n) {
    if (i + n > r->len) return false;
    for (size_t k = i; k < i + n; k++)
        if (r->springs[k] == '.') return false;
    return i + n == r->len || r->springs[i + n] != '#';
}

static long long count(record *r, size_t i, int g) {
    if (i >= r->len) return g == r->ngroups;
    long long *cached = &r->memo[i * (r->ngroups + 1) + g];
    if (*cached >= 0) return *cached;
    long long ways = 0;
    if (r->springs[i] != '#') ways += count(r, i + 1, g);  // operational
    if (r->springs[i] != '.' && g < r->ngroups && fits(r, i, r->groups[g]))
        ways += count(r, i + r->groups[g] + 1, g + 1);  // start a damaged run here
    return *cached = ways;
}

answer solve(char *input) {
    size_t n;
    char **lines = aoc_lines(input, &n);
    long long total = 0;
    for (size_t i = 0; i < n; i++) {
        char *springs = strtok(lines[i], " ");
        int groups[256], ngroups = 0;
        for (char *g = strtok(NULL, ","); g; g = strtok(NULL, ",")) groups[ngroups++] = atoi(g);
        char unfolded[512];
        snprintf(unfolded, sizeof unfolded, "%s?%s?%s?%s?%s", springs, springs, springs, springs, springs);
        record r = {.springs = unfolded, .len = strlen(unfolded), .groups = groups};
        for (int k = 1; k < 5; k++) memcpy(groups + k * ngroups, groups, ngroups * sizeof *groups);
        ngroups *= 5;
        r.ngroups = ngroups;
        size_t cells = (r.len + 1) * (size_t)(ngroups + 1);
        r.memo = malloc(cells * sizeof *r.memo);
        memset(r.memo, -1, cells * sizeof *r.memo);
        total += count(&r, 0, 0);
        free(r.memo);
    }
    return aoc_int(total);
}
