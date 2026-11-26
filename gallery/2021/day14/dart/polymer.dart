// Shared: a Map of pair counts; each rule AB -> C turns every AB into AC + CB.
extension on Map<String, int> {
  void bump(String key, int n) => update(key, (v) => v + n, ifAbsent: () => n);
}

int polymerSpread(String input, int steps) {
  final [template, rulesBlock] = input.trim().split('\n\n');
  final rules = {
    for (final [pair, c] in rulesBlock.split('\n').map((l) => l.split(' -> '))) pair: c,
  };

  var pairs = <String, int>{};
  for (var i = 0; i + 1 < template.length; i++) {
    pairs.bump(template.substring(i, i + 2), 1);
  }

  for (var s = 0; s < steps; s++) {
    final next = <String, int>{};
    pairs.forEach((pair, n) {
      switch (rules[pair]) {
        case final c?:
          next..bump(pair[0] + c, n)..bump(c + pair[1], n);
        case null:
          next.bump(pair, n);
      }
    });
    pairs = next;
  }

  final elements = <String, int>{template[template.length - 1]: 1};
  pairs.forEach((pair, n) => elements.bump(pair[0], n));
  final counts = elements.values.toList()..sort();
  return counts.last - counts.first;
}
