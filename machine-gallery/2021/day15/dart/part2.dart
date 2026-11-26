// Chiton, part 2: the map tiles 5x5 with risk incremented per tile (wrapping 9 -> 1).
// Dart: a local function computes tiled risk with ~/ (integer division).
import 'chiton.dart';

Object solve(String input) => lowestRisk(input, 5);
