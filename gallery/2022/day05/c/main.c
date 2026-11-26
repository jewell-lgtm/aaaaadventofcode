// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
// Each part is its own binary (main + aoc + partN), so both parts define `solve`.
#include <stdio.h>
#include <stdlib.h>
#include "aoc.h"

int main(void) {
    size_t cap = 1 << 16, len = 0, n;
    char *input = malloc(cap);
    while ((n = fread(input + len, 1, cap - len - 1, stdin)) > 0) {
        len += n;
        if (cap - len < 2) input = realloc(input, cap *= 2);
    }
    input[len] = '\0';
    puts(solve(input).text);
    return 0;
}
