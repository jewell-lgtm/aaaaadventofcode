// Chiton, part 1: Dijkstra from top-left to bottom-right.
// Dart: no heap in the core libs, but a SplayTreeSet with a record comparator supports decrease-key.
import 'chiton.dart';

Object solve(String input) => lowestRisk(input, 1);
