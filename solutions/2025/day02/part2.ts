export function solve(input: string): number | string {
  const ranges = input
    .trim()
    .split("\n")
    .flatMap((line) => line.split(","))
    .map((r) => parseRange(r));

  let seen = new Set<number>();
  for (const num of allNums(ranges)) {
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

function* rangeGen(start: number, end: number): Generator<number> {
  for (let i = start; i <= end; i++) {
    yield i;
  }
}

function* allNums(ranges: [number, number][]): Generator<number> {
  for (const [start, end] of ranges) {
    yield* rangeGen(start, end);
  }
}

function parseRange(range: string) {
  return range.split("-").map((it) => parseInt(it)) as [number, number];
}

function sum(arr: number[] | Set<number>) {
  return [...arr].reduce((a, b) => a + b, 0);
}
