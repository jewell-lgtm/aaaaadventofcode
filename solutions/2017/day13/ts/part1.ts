export function solve(input: string): number | string {
  const lines = input
    .trim()
    .split("\n")
    .map(
      (line) => line.split(": ").map((it) => parseInt(it)) as [number, number],
    );

  const size = lines
    .map((it) => it[0])
    .reduce((a, b) => Math.max(a, b), -Infinity);

  const map = new Map(lines);

  let result = 0;
  for (const [layer, range] of map.entries()) {
    if (hit(layer, range)) {
      result += range * layer;
    }
  }

  return result;
}

function hit(at: number, range: number): boolean {
  // cycles round every N positions, once per time unit
  if (!range || range < 2) return false;

  // scans L-R (only at each edge for 1 time unit)
  // 2 = 0 1 (2 pos)
  // 3 = 0 1 2 1 (4 pos)
  // 4 = 0 1 2 3 2 1 (6 pos)
  // 5 = 0 1 2 3 4 3 2 1 (8 pos) = 2N-2
  // 6 = 0 1 2 3 4 5 4 3 2 1 = (10 pos) = 2N-2

  const positions = range * 2 - 2;
  const posAtTime = at % positions;

  return posAtTime == 0;
}
