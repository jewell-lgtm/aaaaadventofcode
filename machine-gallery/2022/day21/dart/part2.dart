// Monkey Math, part 2: rewrite root as left - right == 0, then walk down the branch holding humn,
// inverting each operation against the value of the other (known) branch.
import 'monkeys.dart';

int solveFor(Map<String, Job> tree, String name, int target) {
  if (name == 'humn') return target;
  final Op(:left, :op, :right) = tree[name]! as Op;
  if (dependsOnHumn(tree, left)) {
    final known = evaluate(tree, right);
    return solveFor(tree, left, switch (op) {
      '+' => target - known,
      '-' => target + known,
      '*' => target ~/ known,
      _ => target * known,
    });
  }
  final known = evaluate(tree, left);
  return solveFor(tree, right, switch (op) {
    '+' => target - known,
    '-' => known - target,
    '*' => target ~/ known,
    _ => known ~/ target,
  });
}

Object solve(String input) {
  final tree = parseTree(input);
  final root = tree['root']! as Op;
  tree['root'] = Op(root.left, '-', root.right);
  return solveFor(tree, 'root', 0);
}
