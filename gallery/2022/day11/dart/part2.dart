// Monkey in the Middle, part 2: 10000 rounds, no relief; reduce worry modulo the divisor product.
// Dart native ints are 64-bit, so values below modulus^2 stay exact.
import 'monkeys.dart';

Object solve(String input) {
  final monkeys = parseMonkeys(input);
  final modulus = monkeys.fold(1, (m, k) => m * k.divisor);
  return monkeyBusiness(monkeys, 10000, (w) => w % modulus);
}
