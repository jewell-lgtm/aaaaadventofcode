// Hot Springs, part 2: unfold each row 5x (joined by '?') and its groups 5x.
// Dart: List.filled(...).join does the unfolding; native int is 64-bit.
import 'springs.dart';

Object solve(String input) => totalArrangements(input, 5);
