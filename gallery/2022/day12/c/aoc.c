#include "aoc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

answer aoc_int(long long n) {
    answer a;
    snprintf(a.text, sizeof a.text, "%lld", n);
    return a;
}

answer aoc_str(const char *s) {
    answer a;
    snprintf(a.text, sizeof a.text, "%s", s);
    return a;
}

bool aoc_example(void) {
    const char *e = getenv("AOC_EXAMPLE");
    return e && strcmp(e, "1") == 0;
}

// AOC_ARGS is a flat JSON object like {"size": 7}: find "name" and read the number after ':'.
long long aoc_arg(const char *name, long long fallback) {
    const char *json = getenv("AOC_ARGS");
    if (!json) return fallback;
    char key[128];
    snprintf(key, sizeof key, "\"%s\"", name);
    const char *at = strstr(json, key);
    if (!at) return fallback;
    at = strchr(at + strlen(key), ':');
    if (!at) return fallback;
    at++;
    while (*at == ' ' || *at == '"') at++;
    if (strncmp(at, "true", 4) == 0) return 1;
    if (strncmp(at, "false", 5) == 0) return 0;
    return strtoll(at, NULL, 10);
}

char **aoc_lines(char *input, size_t *count) {
    size_t len = strlen(input);
    while (len > 0 && input[len - 1] == '\n') input[--len] = '\0';
    size_t n = 1;
    for (char *p = input; *p; p++) n += *p == '\n';
    char **lines = malloc(n * sizeof *lines);
    lines[0] = input;
    size_t i = 1;
    for (char *p = input; *p; p++) {
        if (*p == '\n') {
            *p = '\0';
            lines[i++] = p + 1;
        }
    }
    *count = n;
    return lines;
}
