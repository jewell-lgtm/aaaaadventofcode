// Monkey Math, part 2: root checks equality; walk down the branch containing humn,
// inverting each operation against the value the other (known) branch evaluates to.
import { dependsOn, evaluate, parse, type OpJob, type Tree } from "./monkeys";

function solveFor(tree: Tree, name: string, target: number): number {
  if (name === "humn") return target;
  const job = tree.get(name)!;
  if (job.kind === "num") throw new Error("humn not under " + name);
  const unknownLeft = dependsOn(tree, job.left, "humn");
  const known = evaluate(tree, unknownLeft ? job.right : job.left);
  const next = unknownLeft ? job.left : job.right;
  switch (job.op) {
    case "+": return solveFor(tree, next, target - known);
    case "*": return solveFor(tree, next, target / known);
    case "-": return solveFor(tree, next, unknownLeft ? target + known : known - target);
    default: return solveFor(tree, next, unknownLeft ? target * known : known / target);
  }
}

export function solve(input: string): number {
  const tree = parse(input);
  // left = right  <=>  left - right = 0
  tree.set("root", { ...(tree.get("root") as OpJob), op: "-" });
  return solveFor(tree, "root", 0);
}
