// Supply Stacks, part 2: the CrateMover 9001 keeps the slice's order.
// Dart: part 1 without .reversed.
import 'stacks.dart';

Object solve(String input) {
  final (stacks, moves) = parse(input);
  for (final (:count, :from, :to) in moves) {
    final src = stacks[from];
    stacks[to].addAll(src.sublist(src.length - count));
    src.removeRange(src.length - count, src.length);
  }
  return tops(stacks);
}
