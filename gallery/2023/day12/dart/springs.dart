// Shared: memoised recursion over (index, group) with a Map<(int, int), int> keyed by records.
int arrangements(String row, List<int> groups) {
  final memo = <(int, int), int>{};

  // A damaged run of `size` can start at i: no '.' inside and not followed by '#'.
  bool fits(int i, int size) =>
      i + size <= row.length &&
      !row.substring(i, i + size).contains('.') &&
      (i + size == row.length || row[i + size] != '#');

  int count(int i, int g) {
    if (i >= row.length) return g == groups.length ? 1 : 0;
    return memo[(i, g)] ??= [
      if (row[i] != '#') count(i + 1, g),
      if (row[i] != '.' && g < groups.length && fits(i, groups[g])) count(i + groups[g] + 1, g + 1),
    ].fold(0, (a, b) => a + b);
  }

  return count(0, 0);
}

int totalArrangements(String input, int copies) {
  var total = 0;
  for (final [row, groups] in input.trim().split('\n').map((l) => l.split(' '))) {
    total += arrangements(
      List.filled(copies, row).join('?'),
      List.filled(copies, groups).join(',').split(',').map(int.parse).toList(),
    );
  }
  return total;
}
