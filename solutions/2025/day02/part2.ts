export function solve(input: string): number | string {
  const nums = input
    .trim()
    .split("\n")
    .flatMap((line) => line.split(","))
    .map((r) => parseRange(r))
    .flatMap(([start, end]) =>
      Array.from({ length: end - start + 1 }, (_, i) => start + i),
    );

  let seen = new Set<number>();
  for (const num of nums) {
    const string = num.toString();
    for (let len = 1; len <= Math.floor(string.length / 2); len++) {
      if (string.length % len !== 0) continue;
      const header = string.slice(0, len);
      let i = len;
      let valid = true;
      while (i < string.length) {
        if (string.slice(i, i + len) !== header) {
          valid = false;
          break;
        }
        i += len;
      }
      if (valid) {
        seen.add(num);
      }
    }
  }

  return sum(seen);
}

function parseRange(range: string) {
  return range.split("-").map((it) => parseInt(it)) as [number, number];
}

function firstHalf(string: string) {
  const half = Math.floor(string.length / 2);
  return string.slice(0, half);
}
function secondHalf(string: string) {
  const half = Math.ceil(string.length / 2);
  return string.slice(half);
}

function sum(arr: number[] | Set<number>) {
  return [...arr].reduce((a, b) => a + b, 0);
}
