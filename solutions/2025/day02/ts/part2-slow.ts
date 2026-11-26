import assert from "assert";

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
      const [head, ...rest] = chunk(string, len);
      if (rest.some((it) => it !== head)) continue;

      seen.add(num);
    }
  }

  return sum(seen);
}

function parseRange(range: string) {
  return range.split("-").map((it) => parseInt(it)) as [number, number];
}

function chunk(str: string, size: number): string[] {
  assert(size > 0, "Size must be greater than 0");
  assert(str.length % size === 0, "String length must be multiple of size");
  let tail = str;
  const result: string[] = [];
  let i = 0;
  while (tail.length) {
    const head = tail.slice(0, size);
    tail = tail.slice(size);
    result.push(head);
  }
  return result;
}

function sum(arr: number[] | Set<number>) {
  return [...arr].reduce((a, b) => a + b, 0);
}
