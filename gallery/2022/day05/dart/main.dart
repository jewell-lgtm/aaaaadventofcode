// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
import 'dart:convert';
import 'dart:io';

import 'part1.dart' as part1;
import 'part2.dart' as part2;

Future<void> main() async {
  final input = await stdin.transform(utf8.decoder).join();
  final solve = Platform.environment['AOC_PART'] == '2' ? part2.solve : part1.solve;
  print(solve(input));
}
