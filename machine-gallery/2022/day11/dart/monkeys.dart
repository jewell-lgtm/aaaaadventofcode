// Shared: a Monkey class built by a factory constructor; the relief step is a function parameter.
class Monkey {
  Monkey(this.items, this.op, this.divisor, this.ifTrue, this.ifFalse);

  factory Monkey.parse(String block) {
    final lines = block.split('\n');
    int lastNum(String line) => int.parse(RegExp(r'\d+$').firstMatch(line.trim())![0]!);
    final [_, sym, rhs] = RegExp(r'old (.) (\w+)').firstMatch(lines[2])!.groups([0, 1, 2]);
    final op = switch ((sym, int.tryParse(rhs!))) {
      ('*', null) => (int old) => old * old,
      ('*', final n?) => (int old) => old * n,
      (_, null) => (int old) => old + old,
      (_, final n?) => (int old) => old + n,
    };
    final items = RegExp(r'\d+').allMatches(lines[1]).map((m) => int.parse(m[0]!)).toList();
    return Monkey(items, op, lastNum(lines[3]), lastNum(lines[4]), lastNum(lines[5]));
  }

  List<int> items;
  final int Function(int) op;
  final int divisor, ifTrue, ifFalse;
  int inspected = 0;
}

List<Monkey> parseMonkeys(String input) => input.trim().split('\n\n').map(Monkey.parse).toList();

int monkeyBusiness(List<Monkey> monkeys, int rounds, int Function(int) relieve) {
  for (var round = 0; round < rounds; round++) {
    for (final m in monkeys) {
      for (final item in m.items) {
        final worry = relieve(m.op(item));
        monkeys[worry % m.divisor == 0 ? m.ifTrue : m.ifFalse].items.add(worry);
      }
      m.inspected += m.items.length;
      m.items = [];
    }
  }
  final counts = monkeys.map((m) => m.inspected).toList()..sort((a, b) => b - a);
  return counts[0] * counts[1];
}
