// Extended Polymerization, part 1: 10 steps, then most common minus least common element.
// Dart: a private extension method adds `bump` to Map; cascades (..) chain the two updates.
import 'polymer.dart';

Object solve(String input) => polymerSpread(input, 10);
