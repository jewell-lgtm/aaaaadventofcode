// Mull It Over, part 1: RegExp.allMatches with groups, folded into a sum.
// Dart: Iterable.fold over typed matches; int.parse on each group.
final _mul = RegExp(r'mul\((\d{1,3}),(\d{1,3})\)');

Object solve(String input) => _mul
    .allMatches(input)
    .fold<int>(0, (sum, m) => sum + int.parse(m[1]!) * int.parse(m[2]!));
