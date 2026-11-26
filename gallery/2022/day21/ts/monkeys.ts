// Shared: the monkeys form an expression tree. A tagged union per node; evaluate and invert.
export type Job = { kind: "num"; value: number } | { kind: "op"; left: string; op: string; right: string };
export type OpJob = Extract<Job, { kind: "op" }>;
export type Tree = Map<string, Job>;

export function parse(input: string): Tree {
  return new Map(
    input.trimEnd().split("\n").map((line) => {
      const [name, job] = line.split(": ");
      const [left, op, right] = job.split(" ");
      return [name, op ? { kind: "op", left, op, right } : { kind: "num", value: +job }];
    }),
  );
}

export function evaluate(tree: Tree, name: string): number {
  const job = tree.get(name)!;
  if (job.kind === "num") return job.value;
  const [a, b] = [evaluate(tree, job.left), evaluate(tree, job.right)];
  switch (job.op) {
    case "+": return a + b;
    case "-": return a - b;
    case "*": return a * b;
    default: return a / b;
  }
}

export function dependsOn(tree: Tree, name: string, target: string): boolean {
  const job = tree.get(name)!;
  return name === target || (job.kind === "op" && (dependsOn(tree, job.left, target) || dependsOn(tree, job.right, target)));
}
