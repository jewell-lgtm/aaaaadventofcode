// Monkey in the Middle, part 1: 20 rounds, worry divided by 3 after each inspection.
// Dart: a switch on an (operator, operand?) record picks the operation closure.
import 'monkeys.dart';

Object solve(String input) => monkeyBusiness(parseMonkeys(input), 20, (w) => w ~/ 3);
