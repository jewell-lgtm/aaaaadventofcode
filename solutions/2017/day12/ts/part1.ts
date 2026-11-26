export function solve(input: string): number | string {
  const lines = input
    .trim()
    .split("\n")
    .map((it) => parseLine(it));

  const pipes = createPipes();
  for (const [from, allTo] of lines) {
    for (const to of allTo) {
      pipes.link(from, to);
    }
  }

  return pipes.connected("0").size;
}

function parseLine(input: string): [string, string[]] {
  const [from, allTo] = input.split(" <-> ");
  return [from, allTo.split(",").map((it) => it.trim())];
}

function createPipes() {
  const pipes = new Map<string, Set<string>>();
  return {
    get _pipes() {
      return pipes;
    },
    link(a: string, b: string) {
      if (!pipes.has(a)) {
        pipes.set(a, new Set());
      }
      if (!pipes.has(b)) {
        pipes.set(b, new Set());
      }
      pipes.get(a)!.add(b);
      pipes.get(b)!.add(a);
    },
    connected(to: string) {
      const toSearch: string[] = [to];
      const result = new Set<string>([to]);

      while (toSearch.length > 0) {
        const pipe = toSearch.pop()!!;
        const connections = pipes.get(pipe) ?? new Set();
        for (const connection of connections) {
          if (!result.has(connection)) {
            toSearch.push(connection);
          }
          result.add(connection);
        }
      }

      return result;
    },
  };
}
