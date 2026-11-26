// Shared parser: crate letters sit at columns 1, 5, 9, ...; read the drawing bottom-up.
typedef Move = ({int count, int from, int to});

final _move = RegExp(r'move (\d+) from (\d+) to (\d+)');

(List<List<String>>, List<Move>) parse(String input) {
  final [drawing, procedure] = input.trimRight().split('\n\n');
  final rows = drawing.split('\n')..removeLast();
  final width = (rows.map((r) => r.length).reduce((a, b) => a > b ? a : b) + 1) ~/ 4;
  final stacks = [
    for (var i = 0; i < width; i++)
      [
        for (final row in rows.reversed)
          if (1 + 4 * i < row.length && row[1 + 4 * i] != ' ') row[1 + 4 * i],
      ],
  ];
  final moves = [
    for (final m in _move.allMatches(procedure))
      (count: int.parse(m[1]!), from: int.parse(m[2]!) - 1, to: int.parse(m[3]!) - 1),
  ];
  return (stacks, moves);
}

String tops(List<List<String>> stacks) => stacks.map((s) => s.last).join();
