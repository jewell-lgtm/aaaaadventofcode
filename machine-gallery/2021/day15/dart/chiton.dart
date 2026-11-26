// Shared: Dijkstra using a SplayTreeSet ordered by (distance, row, col) as the priority queue.
import 'dart:collection';

int lowestRisk(String input, int tiles) {
  final base = [for (final row in input.trim().split('\n')) row.split('').map(int.parse).toList()];
  final (h, w) = (base.length, base[0].length);
  final (rows, cols) = (h * tiles, w * tiles);
  int risk(int r, int c) => (base[r % h][c % w] + r ~/ h + c ~/ w - 1) % 9 + 1;

  final dist = List.generate(rows, (_) => List.filled(cols, 1 << 62));
  final queue = SplayTreeSet<(int, int, int)>((a, b) =>
      a.$1 != b.$1 ? a.$1 - b.$1 : a.$2 != b.$2 ? a.$2 - b.$2 : a.$3 - b.$3);
  dist[0][0] = 0;
  queue.add((0, 0, 0));
  while (queue.isNotEmpty) {
    final (d, r, c) = queue.first;
    queue.remove(queue.first);
    if (r == rows - 1 && c == cols - 1) return d;
    for (final (nr, nc) in [(r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)]) {
      if (nr < 0 || nc < 0 || nr >= rows || nc >= cols) continue;
      final nd = d + risk(nr, nc);
      if (nd >= dist[nr][nc]) continue;
      queue.remove((dist[nr][nc], nr, nc)); // decrease-key: drop the stale entry
      dist[nr][nc] = nd;
      queue.add((nd, nr, nc));
    }
  }
  throw StateError('unreachable');
}
