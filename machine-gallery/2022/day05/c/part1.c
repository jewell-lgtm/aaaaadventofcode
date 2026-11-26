// Fixed-size char arrays are the stacks, filled bottom-up from the drawing.
// The CrateMover 9000 moves crates one at a time.
#include <stdio.h>
#include <string.h>
#include "aoc.h"

enum { MAX_STACKS = 10, MAX_CRATES = 512 };

typedef struct {
    char crates[MAX_CRATES];
    int height;
} stack;

answer solve(char *input) {
    size_t n;
    char **lines = aoc_lines(input, &n);
    size_t blank = 0;
    while (lines[blank][0] != '\0') blank++;

    // The label line " 1   2   3" sits just above the blank line; each stack is 4 chars wide.
    stack s[MAX_STACKS] = {};
    int stacks = (int)(strlen(lines[blank - 1]) + 2) / 4;
    for (size_t row = blank - 1; row-- > 0;) {
        size_t width = strlen(lines[row]);
        for (int i = 0; i < stacks; i++) {
            size_t col = 1 + 4 * (size_t)i;
            if (col < width && lines[row][col] != ' ') s[i].crates[s[i].height++] = lines[row][col];
        }
    }

    for (size_t i = blank + 1; i < n; i++) {
        int count, from, to;
        if (sscanf(lines[i], "move %d from %d to %d", &count, &from, &to) != 3) continue;
        from--, to--;
        for (int k = 0; k < count; k++) s[to].crates[s[to].height++] = s[from].crates[--s[from].height];
    }

    char tops[MAX_STACKS + 1] = {};
    for (int i = 0; i < stacks; i++) tops[i] = s[i].height ? s[i].crates[s[i].height - 1] : ' ';
    return aoc_str(tops);
}
