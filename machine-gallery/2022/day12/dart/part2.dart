// Hill Climbing Algorithm, part 2: multi-source BFS from every lowest square.
// Dart: same search, seeded with every S and a.
import 'hill.dart';

Object solve(String input) => shortestPath(input, {'S', 'a'});
