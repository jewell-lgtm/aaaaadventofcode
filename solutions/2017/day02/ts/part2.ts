export function solve(input: string): number | string {
  const lines = input.trim().split("\n");
  const digs = lines.map((line) =>
    line.split(/\s+/).map((it) => parseInt(it, 10)),
  );

  let result = 0;

  for (const line of digs) {
    let skip = false;
    for (let i = 0; !skip && i < line.length; i++) {
      for (let j = i + 1; j < line.length; j++) {
        const first = line[i];
        const second = line[j];
        if ((Math.max(first, second) / Math.min(first, second)) % 1 === 0) {
          result += Math.max(first, second) / Math.min(first, second);
          skip = true;
          break;
        }
      }
    }
  }

  return result;
}

const maxOf = (nums: number[]) =>
  nums.reduce((a, b) => Math.max(a, b), -Infinity);
const minOf = (numbs: number[]) =>
  numbs.reduce((a, b) => Math.min(a, b), Infinity);
