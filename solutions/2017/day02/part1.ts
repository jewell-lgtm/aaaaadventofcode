export function solve(input: string): number | string {
  const lines = input.trim().split("\n");
  const digs = lines.map((line) =>
    line.split(/\s+/).map((it) => parseInt(it, 10)),
  );

  let result = 0;

  for (const line of digs) {
    const hi = maxOf(line);
    const lo = minOf(line);
    result += hi - lo;
  }

  return result;
}

const maxOf = (nums: number[]) =>
  nums.reduce((a, b) => Math.max(a, b), -Infinity);
const minOf = (numbs: number[]) =>
  numbs.reduce((a, b) => Math.min(a, b), Infinity);
