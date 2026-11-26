// Monkey Math, part 1: recursively evaluate the expression tree from root.
// Dart: a sealed class hierarchy + switch expressions with object patterns, checked exhaustively.
import 'monkeys.dart';

Object solve(String input) => evaluate(parseTree(input), 'root');
