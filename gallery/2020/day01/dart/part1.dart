// Report Repair, part 1: one pass with a Set of seen numbers; stop at the first complement.
// Dart: a typed Set<int> and a plain for-in loop.
Object solve(String input) {
  final seen = <int>{};
  for (final n in input.trim().split('\n').map(int.parse)) {
    if (seen.contains(2020 - n)) return n * (2020 - n);
    seen.add(n);
  }
  throw StateError('no pair sums to 2020');
}
