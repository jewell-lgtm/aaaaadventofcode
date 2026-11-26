// Monkey names are four lowercase letters, so each encodes to an index < 26^4 and a
// plain array replaces a hash map. Evaluate the expression tree recursively.
#include <stdlib.h>
#include "aoc.h"

enum { NAMES = 26 * 26 * 26 * 26 };

typedef struct {
    char op;  // 0 for a number
    long long value;
    int left, right;
} job;

static job jobs[NAMES];

static int encode(const char *name) {
    return ((name[0] - 'a') * 26 + (name[1] - 'a')) * 26 * 26 + (name[2] - 'a') * 26 + (name[3] - 'a');
}

static long long eval(int id) {
    job j = jobs[id];
    if (!j.op) return j.value;
    long long a = eval(j.left), b = eval(j.right);
    switch (j.op) {
        case '+': return a + b;
        case '-': return a - b;
        case '*': return a * b;
        default: return a / b;
    }
}

answer solve(char *input) {
    size_t n;
    char **lines = aoc_lines(input, &n);
    for (size_t i = 0; i < n; i++) {
        // "root: pppw + sjmn" or "dbpl: 5"
        const char *line = lines[i];
        job *j = &jobs[encode(line)];
        if (line[6] >= 'a' && line[6] <= 'z') {
            *j = (job){.op = line[11], .left = encode(line + 6), .right = encode(line + 13)};
        } else {
            *j = (job){.value = atoll(line + 6)};
        }
    }
    return aoc_int(eval(encode("root")));
}
