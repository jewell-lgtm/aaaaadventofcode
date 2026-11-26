// Jokers: J is the weakest card for ties but joins the largest group when typing a hand.
// Same struct + qsort comparator as part 1; only the shape calculation changes.
#include <stdlib.h>
#include <string.h>
#include "aoc.h"

static const char ORDER[] = "J23456789TQKA";

typedef struct {
    int shape[5];   // card counts, largest first, zero-padded
    int values[5];  // card strengths in hand order
    int bid;
} hand;

static int descending(const void *a, const void *b) {
    return *(const int *)b - *(const int *)a;
}

static int compare_hands(const void *a, const void *b) {
    const hand *x = a, *y = b;
    for (int i = 0; i < 5; i++)
        if (x->shape[i] != y->shape[i]) return x->shape[i] - y->shape[i];
    for (int i = 0; i < 5; i++)
        if (x->values[i] != y->values[i]) return x->values[i] - y->values[i];
    return 0;
}

static hand parse_hand(const char *line) {
    hand h = {};
    int counts[13] = {};
    for (int i = 0; i < 5; i++) {
        h.values[i] = (int)(strchr(ORDER, line[i]) - ORDER);
        counts[h.values[i]]++;
    }
    int wild = counts[0];  // J is index 0 in this order
    counts[0] = 0;
    qsort(counts, 13, sizeof(int), descending);
    memcpy(h.shape, counts, sizeof h.shape);
    h.shape[0] += wild;
    h.bid = atoi(line + 6);
    return h;
}

answer solve(char *input) {
    size_t n;
    char **lines = aoc_lines(input, &n);
    hand *hands = malloc(n * sizeof *hands);
    for (size_t i = 0; i < n; i++) hands[i] = parse_hand(lines[i]);
    qsort(hands, n, sizeof *hands, compare_hands);

    long total = 0;
    for (size_t i = 0; i < n; i++) total += (long)(i + 1) * hands[i].bid;
    return aoc_int(total);
}
