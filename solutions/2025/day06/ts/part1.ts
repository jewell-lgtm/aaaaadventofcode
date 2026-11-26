export function solve(input: string): number | string {
  const cols = readCols(input);

  return cols.reduce((result, sum) => (result += compute(sum)), 0n).toString();
}

function readCols(input: string): string[][] {
  const lines = input
    .trim()
    .split("\n")
    .map((line) => line.trim().split(/\s+/));
  const w = lines[0].length;
  const h = lines.length;
  const result: string[][] = Array.from({ length: w }, () =>
    Array.from({ length: h }, () => ""),
  );

  for (let x = 0; x < w; x++) {
    for (let y = 0; y < h; y++) {
      result[x][y] = lines[y][x];
    }
  }

  return result;
}

function compute(col: string[]): bigint {
  const last = col[col.length - 1];
  const rest = col.slice(0, -1);
  if (last === "+") return rest.reduce((a, b) => a + BigInt(b), 0n);
  if (last === "*") return rest.reduce((a, b) => a * BigInt(b), 1n);
  throw new Error(`Unknown operator: ${last}`);
}
