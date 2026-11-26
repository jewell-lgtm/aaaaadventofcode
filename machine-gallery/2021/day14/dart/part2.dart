// Extended Polymerization, part 2: 40 steps; the polymer is astronomically long, the pair counts aren't.
// Dart: native 64-bit ints hold ~1e13 exactly.
import 'polymer.dart';

Object solve(String input) => polymerSpread(input, 40);
