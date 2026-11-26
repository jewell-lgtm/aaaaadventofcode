// Supply Stacks, part 1: lists as stacks; the CrateMover 9000 moves one crate at a time.
// Dart: collection-for in the parser, record destructuring in the loop header.
import 'stacks.dart';

Object solve(String input) {
  final (stacks, moves) = parse(input);
  for (final (:count, :from, :to) in moves) {
    final src = stacks[from];
    stacks[to].addAll(src.sublist(src.length - count).reversed);
    src.removeRange(src.length - count, src.length);
  }
  return tops(stacks);
}
