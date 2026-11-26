// Mull It Over, part 2: scan an alternation in order; a switch on the matched text flips state.
// Dart: switch statements on strings, with a when-guard for the enabled case.
final _token = RegExp(r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)");

Object solve(String input) {
  var enabled = true;
  var total = 0;
  for (final m in _token.allMatches(input)) {
    switch (m[0]) {
      case 'do()':
        enabled = true;
      case "don't()":
        enabled = false;
      case _ when enabled:
        total += int.parse(m[1]!) * int.parse(m[2]!);
    }
  }
  return total;
}
