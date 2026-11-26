// humn appears once in the tree. Walk from root towards it, inverting each operation
// against the value of the other (fully known) subtree. Names index a flat array.
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

static bool has_human(int id) {
    return id == encode("humn") || (jobs[id].op && (has_human(jobs[id].left) || has_human(jobs[id].right)));
}

// The humn value that makes the subtree at id evaluate to target.
static long long solve_for(int id, long long target) {
    if (id == encode("humn")) return target;
    job j = jobs[id];
    if (has_human(j.left)) {
        long long known = eval(j.right);
        switch (j.op) {
            case '+': return solve_for(j.left, target - known);
            case '-': return solve_for(j.left, target + known);
            case '*': return solve_for(j.left, target / known);
            default: return solve_for(j.left, target * known);
        }
    }
    long long known = eval(j.left);
    switch (j.op) {
        case '+': return solve_for(j.right, target - known);
        case '-': return solve_for(j.right, known - target);
        case '*': return solve_for(j.right, target / known);
        default: return solve_for(j.right, known / target);
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
    job root = jobs[encode("root")];
    return aoc_int(has_human(root.left) ? solve_for(root.left, eval(root.right))
                                        : solve_for(root.right, eval(root.left)));
}
