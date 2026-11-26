// Harness helpers.
#pragma once
#include <stddef.h>

// What solve() returns: build it with aoc_int(42) or aoc_str("CMZ").
typedef struct { char text[256]; } answer;

answer solve(char *input);
answer aoc_int(long long n);
answer aoc_str(const char *s);

// True when running an example (aoc test).
bool aoc_example(void);

// Example-specific constant from examples.toml `args`, else the real-input default.
long long aoc_arg(const char *name, long long fallback);

// Splits input into lines in place (keeps blank lines, drops the trailing newline).
// Returns a malloc'd array of pointers into input; *count gets the number of lines.
char **aoc_lines(char *input, size_t *count);
