// Hot Springs, part 1: count arrangements per row by branching on each '?'.
// Dart: ??= on a record-keyed Map memoises; collection-if lists the two branches.
import 'springs.dart';

Object solve(String input) => totalArrangements(input, 1);
