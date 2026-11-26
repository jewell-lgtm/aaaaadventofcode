// No regex: walk the string once, matching do(), don't() and mul( by prefix.
// A tiny hand parser checks "X,Y)" after each mul(.
#include <ctype.h>
#include <string.h>
#include "aoc.h"

static bool starts_with(const char *s, const char *prefix) {
    return strncmp(s, prefix, strlen(prefix)) == 0;
}

// Reads a 1-3 digit number at *p and advances past it.
static bool read_number(const char **p, long *out) {
    int digits = 0;
    for (*out = 0; isdigit((unsigned char)**p) && digits < 4; (*p)++, digits++) *out = *out * 10 + (**p - '0');
    return digits >= 1 && digits <= 3;
}

// Parses "X,Y)" (the part after "mul(") and stores X*Y.
static bool parse_mul(const char *p, long *product) {
    long x, y;
    if (!read_number(&p, &x) || *p++ != ',') return false;
    if (!read_number(&p, &y) || *p != ')') return false;
    *product = x * y;
    return true;
}

answer solve(char *input) {
    long total = 0, product;
    bool enabled = true;
    for (const char *p = input; *p; p++) {
        if (starts_with(p, "do()")) enabled = true;
        else if (starts_with(p, "don't()")) enabled = false;
        else if (enabled && starts_with(p, "mul(") && parse_mul(p + 4, &product)) total += product;
    }
    return aoc_int(total);
}
