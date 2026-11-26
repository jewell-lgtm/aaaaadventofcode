// Shared: parse the heightmap and run a multi-source BFS (climb at most one step up).
type Point = [number, number];

export function parse(input: string) {
  const grid = input.trimEnd().split("\n").map((row) => [...row]);
  const find = (ch: string): Point[] =>
    grid.flatMap((row, r) => row.flatMap((c, col) => (c === ch ? [[r, col] as Point] : [])));
  const height = ([r, c]: Point) => {
    const ch = grid[r][c];
    return (ch === "S" ? "a" : ch === "E" ? "z" : ch).charCodeAt(0);
  };
  return { grid, find, height };
}

export function shortestPath(input: string, startChars: string[]): number {
  const { grid, find, height } = parse(input);
  const [end] = find("E");
  let frontier = startChars.flatMap(find);
  const seen = new Set(frontier.map((p) => p.join()));
  for (let steps = 0; frontier.length; steps++) {
    const next: Point[] = [];
    for (const p of frontier) {
      if (p[0] === end[0] && p[1] === end[1]) return steps;
      for (const [dr, dc] of [[1, 0], [-1, 0], [0, 1], [0, -1]]) {
        const q: Point = [p[0] + dr, p[1] + dc];
        if (grid[q[0]]?.[q[1]] === undefined || seen.has(q.join())) continue;
        if (height(q) - height(p) > 1) continue;
        seen.add(q.join());
        next.push(q);
      }
    }
    frontier = next;
  }
  throw new Error("no path");
}
