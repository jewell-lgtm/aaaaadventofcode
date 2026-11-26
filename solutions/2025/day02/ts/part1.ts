export function solve(input: string): number | string {
  const ranges = input
    .trim()
    .split("\n")
    .flatMap((line) => line.split(","))
    .map((r) => parseRange(r));

  let seen = [] as number[];
  console.time("brute");
  for (const [first, last] of ranges) {
    for (let i = first; i <= last; i++) {
      const string = i.toString();
      if (string.length % 2 !== 0) continue;
      if (firstHalf(string) == secondHalf(string)) {
        seen.push(i);
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

function sum(arr: number[]) {
  return arr.reduce((a, b) => a + b, 0);
}
