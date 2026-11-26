export function solve(input: string): number | string {
  const [ranges, ids] = input
    .trim()
    .split("\n\n")
    .map((it) => it.split("\n"));

  let result = 0;
  for (const id of parseIds(ids)) {
    if (parseRanges(ranges).some(([start, end]) => id >= start && id <= end)) {
      result += 1;
    }
  }

  return result;
}

function parseIds(ids: string[]): number[] {
  return ids.map(Number);
}

function parseRanges(ranges: string[]): [number, number][] {
  return ranges.map((range) => {
    const [start, end] = range.split("-").map(Number);
    return [start, end];
  });
}
