// Report Repair, part 2: a sync* generator yields index triples, filtered lazily.
// Dart: sync* generators and records ((a, b, c)) with destructuring.
Iterable<(int, int, int)> triples(List<int> xs) sync* {
  for (var i = 0; i < xs.length; i++) {
    for (var j = i + 1; j < xs.length; j++) {
      for (var k = j + 1; k < xs.length; k++) {
        yield (xs[i], xs[j], xs[k]);
      }
    }
  }
}

Object solve(String input) {
  final nums = input.trim().split('\n').map(int.parse).toList();
  final (a, b, c) = triples(nums).firstWhere((t) => t.$1 + t.$2 + t.$3 == 2020);
  return a * b * c;
}
