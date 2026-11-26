export function solve(input: string): number | string {
  const lines = input
    .trim()
    .split("\n")
    .map((it) => {
      const [head, tail] = it.split(": ");
      return [head, tail.split(" ")] as const;
    });

  let result = 0;

  const nodes = new Map<string, string[]>(
    lines.map(([node, edges]) => [node, edges]),
  );

  const paths = ["you"];

  // assume no cycles

  while (paths.length) {
    const curr = paths.pop()!!;
    const next = nodes.get(curr) ?? [];
    for (const n of next) {
      if (n === "out") result += 1;
      else {
        paths.push(n);
      }
    }
  }

  return result;
}
