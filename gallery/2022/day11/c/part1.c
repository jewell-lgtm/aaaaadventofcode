// Monkeys parse into structs with fixed item arrays; sscanf handles the fixed phrasing.
// 20 rounds with worry divided by 3 after each inspection.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "aoc.h"

enum { MAX_MONKEYS = 16, MAX_ITEMS = 128, ROUNDS = 20 };

typedef struct {
    long long items[MAX_ITEMS];
    int count;
    char op;           // '+' or '*'
    long long operand; // 0 means "old"
    long long divisor;
    int if_true, if_false;
    long long inspected;
} monkey;

// Reads one monkey block starting at lines[i] (the "Monkey N:" line).
static monkey parse_monkey(char **lines, size_t i) {
    monkey m = {};
    for (char *p = strchr(lines[i + 1], ':') + 1; *p; p++) {
        char *end;
        long long v = strtoll(p, &end, 10);
        if (end == p) continue;
        m.items[m.count++] = v;
        p = end - 1;
    }
    char rhs[16];
    sscanf(lines[i + 2], " Operation: new = old %c %15s", &m.op, rhs);
    m.operand = strcmp(rhs, "old") == 0 ? 0 : atoll(rhs);
    sscanf(lines[i + 3], " Test: divisible by %lld", &m.divisor);
    sscanf(lines[i + 4], " If true: throw to monkey %d", &m.if_true);
    sscanf(lines[i + 5], " If false: throw to monkey %d", &m.if_false);
    return m;
}

static int descending(const void *a, const void *b) {
    long long x = *(const long long *)a, y = *(const long long *)b;
    return (x < y) - (x > y);
}

answer solve(char *input) {
    size_t n;
    char **lines = aoc_lines(input, &n);
    monkey monkeys[MAX_MONKEYS];
    int count = 0;
    for (size_t i = 0; i < n; i++)
        if (strncmp(lines[i], "Monkey", 6) == 0) monkeys[count++] = parse_monkey(lines, i);

    for (int round = 0; round < ROUNDS; round++) {
        for (int i = 0; i < count; i++) {
            monkey *m = &monkeys[i];
            for (int k = 0; k < m->count; k++) {
                long long operand = m->operand ? m->operand : m->items[k];
                long long worry = m->op == '*' ? m->items[k] * operand : m->items[k] + operand;
                worry /= 3;
                monkey *target = &monkeys[worry % m->divisor == 0 ? m->if_true : m->if_false];
                target->items[target->count++] = worry;
            }
            m->inspected += m->count;
            m->count = 0;
        }
    }

    long long inspected[MAX_MONKEYS];
    for (int i = 0; i < count; i++) inspected[i] = monkeys[i].inspected;
    qsort(inspected, count, sizeof *inspected, descending);
    return aoc_int(inspected[0] * inspected[1]);
}
