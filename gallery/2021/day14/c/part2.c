// 40 steps would build ~20 trillion elements; pair counts stay small. Elements are
// capital letters, so 26×26 arrays index pairs directly; no hashing.
#include <string.h>
#include "aoc.h"

enum { STEPS = 40 };

answer solve(char *input) {
    size_t n;
    char **lines = aoc_lines(input, &n);
    const char *polymer = lines[0];

    char rule[26][26] = {};  // inserted letter + 1, or 0 for no rule
    for (size_t i = 2; i < n; i++) rule[lines[i][0] - 'A'][lines[i][1] - 'A'] = lines[i][6] - 'A' + 1;

    long long pairs[26][26] = {};
    size_t len = strlen(polymer);
    for (size_t i = 0; i + 1 < len; i++) pairs[polymer[i] - 'A'][polymer[i + 1] - 'A']++;

    for (int step = 0; step < STEPS; step++) {
        long long next[26][26] = {};
        for (int a = 0; a < 26; a++) {
            for (int b = 0; b < 26; b++) {
                if (!pairs[a][b]) continue;
                if (rule[a][b]) {
                    int c = rule[a][b] - 1;
                    next[a][c] += pairs[a][b];
                    next[c][b] += pairs[a][b];
                } else {
                    next[a][b] += pairs[a][b];
                }
            }
        }
        memcpy(pairs, next, sizeof pairs);
    }

    // Every element is the first letter of exactly one pair, except the last one.
    long long counts[26] = {};
    counts[polymer[len - 1] - 'A'] = 1;
    for (int a = 0; a < 26; a++)
        for (int b = 0; b < 26; b++) counts[a] += pairs[a][b];

    long long most = 0, least = -1;
    for (int a = 0; a < 26; a++) {
        if (!counts[a]) continue;
        if (counts[a] > most) most = counts[a];
        if (least < 0 || counts[a] < least) least = counts[a];
    }
    return aoc_int(most - least);
}
