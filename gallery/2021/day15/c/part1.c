// Dijkstra with a hand-rolled binary min-heap of (risk, position) pairs.
// Positions are flat indices into the grid; dist is one malloc'd int array.
#include <limits.h>
#include <stdlib.h>
#include <string.h>
#include "aoc.h"

enum { TILES = 1 };

typedef struct {
    int risk, pos;
} node;

typedef struct {
    node *items;
    size_t len, cap;
} heap;

static void swap(node *a, node *b) {
    node t = *a;
    *a = *b;
    *b = t;
}

static void heap_push(heap *h, node x) {
    if (h->len == h->cap) h->items = realloc(h->items, (h->cap = h->cap ? h->cap * 2 : 1024) * sizeof(node));
    size_t i = h->len++;
    h->items[i] = x;
    for (; i > 0 && h->items[i].risk < h->items[(i - 1) / 2].risk; i = (i - 1) / 2)
        swap(&h->items[i], &h->items[(i - 1) / 2]);
}

static node heap_pop(heap *h) {
    node top = h->items[0];
    h->items[0] = h->items[--h->len];
    for (size_t i = 0;;) {
        size_t l = 2 * i + 1, r = l + 1, min = i;
        if (l < h->len && h->items[l].risk < h->items[min].risk) min = l;
        if (r < h->len && h->items[r].risk < h->items[min].risk) min = r;
        if (min == i) break;
        swap(&h->items[i], &h->items[min]);
        i = min;
    }
    return top;
}

static char **cave;
static int h, w;

// Risk at (r, c) of the tiled map: +1 per tile step, wrapping 9 back round to 1.
static int risk(int r, int c) {
    return (cave[r % h][c % w] - '0' + r / h + c / w - 1) % 9 + 1;
}

answer solve(char *input) {
    size_t n;
    cave = aoc_lines(input, &n);
    h = (int)n, w = (int)strlen(cave[0]);
    int rows = h * TILES, cols = w * TILES, goal = rows * cols - 1;

    int *dist = malloc(sizeof(int) * rows * cols);
    for (int i = 0; i <= goal; i++) dist[i] = INT_MAX;
    dist[0] = 0;
    heap pq = {};
    heap_push(&pq, (node){0, 0});

    static const int dr[] = {-1, 1, 0, 0}, dc[] = {0, 0, -1, 1};
    while (pq.len > 0) {
        node cur = heap_pop(&pq);
        if (cur.pos == goal) return aoc_int(cur.risk);
        if (cur.risk > dist[cur.pos]) continue;
        int r = cur.pos / cols, c = cur.pos % cols;
        for (int d = 0; d < 4; d++) {
            int nr = r + dr[d], nc = c + dc[d];
            if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;
            node next = {cur.risk + risk(nr, nc), nr * cols + nc};
            if (next.risk < dist[next.pos]) {
                dist[next.pos] = next.risk;
                heap_push(&pq, next);
            }
        }
    }
    return aoc_str("unreachable");
}
