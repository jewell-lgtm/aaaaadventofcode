// Hill Climbing Algorithm, part 1: BFS from S to E.
// Dart: records (r, c) are value-equal, so they work directly as Map keys.
import 'hill.dart';

Object solve(String input) => shortestPath(input, {'S'});
