// Shared: grid of code units, BFS with a dart:collection Queue of (row, col) records.
import 'dart:collection';

int _height(String ch) => switch (ch) { 'S' => 'a', 'E' => 'z', _ => ch }.codeUnitAt(0);

int shortestPath(String input, Set<String> starts) {
  final grid = input.trimRight().split('\n');
  final dist = <(int, int), int>{};
  final queue = Queue<(int, int)>();
  for (var r = 0; r < grid.length; r++) {
    for (var c = 0; c < grid[r].length; c++) {
      if (starts.contains(grid[r][c])) {
        dist[(r, c)] = 0;
        queue.add((r, c));
      }
    }
  }
  while (queue.isNotEmpty) {
    final p = queue.removeFirst();
    final (r, c) = p;
    if (grid[r][c] == 'E') return dist[p]!;
    for (final q in [(r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)]) {
      final (nr, nc) = q;
      if (nr < 0 || nr >= grid.length || nc < 0 || nc >= grid[nr].length) continue;
      if (dist.containsKey(q) || _height(grid[nr][nc]) - _height(grid[r][c]) > 1) continue;
      dist[q] = dist[p]! + 1;
      queue.add(q);
    }
  }
  throw StateError('no path');
}
