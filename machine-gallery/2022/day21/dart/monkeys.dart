// Shared: a sealed class hierarchy for the tree; exhaustive switches evaluate it.
// Plain int with ~/ is enough: the puzzle's divisions are always exact.
sealed class Job {}

class Number extends Job {
  Number(this.value);
  final int value;
}

class Op extends Job {
  Op(this.left, this.op, this.right);
  final String left, op, right;
}

Map<String, Job> parseTree(String input) => {
      for (final line in input.trim().split('\n'))
        if (line.split(': ') case [final name, final job])
          name: switch (job.split(' ')) {
            [final l, final op, final r] => Op(l, op, r),
            _ => Number(int.parse(job)),
          },
    };

int apply(String op, int a, int b) => switch (op) {
      '+' => a + b,
      '-' => a - b,
      '*' => a * b,
      _ => a ~/ b,
    };

int evaluate(Map<String, Job> tree, String name) => switch (tree[name]!) {
      Number(:final value) => value,
      Op(:final left, :final op, :final right) => apply(op, evaluate(tree, left), evaluate(tree, right)),
    };

bool dependsOnHumn(Map<String, Job> tree, String name) =>
    name == 'humn' ||
    switch (tree[name]!) {
      Op(:final left, :final right) => dependsOnHumn(tree, left) || dependsOnHumn(tree, right),
      Number() => false,
    };
