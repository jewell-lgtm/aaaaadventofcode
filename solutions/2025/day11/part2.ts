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

  const memo = new Map<string, bigint>();
  function pathsFrom(src: string, dest: string): bigint {
    const key = [src, dest].join(".");
    if (memo.has(key)) return memo.get(key)!!;
    let result = 0n;

    if (src === dest) return 1n;

    for (const nextNode of nodes.get(src) ?? []) {
      result += pathsFrom(nextNode, dest);
    }

    memo.set(key, result);
    return result;
  }

  return (
    pathsFrom("svr", "dac") *
      pathsFrom("dac", "fft") *
      pathsFrom("fft", "out") +
    pathsFrom("svr", "fft") * pathsFrom("fft", "dac") * pathsFrom("dac", "out")
  ).toString();
}
